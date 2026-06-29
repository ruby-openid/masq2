require "openid/store/interface"

module Masq
  # not in OpenID module to avoid namespace conflict
  class ActiveRecordStore < OpenID::Store::Interface
    def store_association(server_url, assoc)
      remove_association(server_url, assoc.handle)
      Association.create(
        server_url: server_url,
        handle: assoc.handle,
        secret: assoc.secret,
        issued: assoc.issued,
        lifetime: assoc.lifetime,
        assoc_type: assoc.assoc_type
      )
    end

    def get_association(server_url, handle = nil)
      assocs = if handle.blank?
        Association.where(server_url: server_url)
      else
        Association.where(server_url: server_url, handle: handle)
      end

      if assocs.any?
        assocs.reverse_each do |assoc|
          a = assoc.from_record
          if a.expires_in == 0
            assoc.destroy
          else
            return a
          end
        end
      end

      nil
    end

    def remove_association(server_url, handle)
      Association.where("server_url = ? AND handle = ?", server_url, handle).delete_all > 0
    end

    def use_nonce(server_url, timestamp, salt)
      return false if Nonce.find_by(server_url: server_url, timestamp: timestamp, salt: salt)
      return false if (timestamp - Time.now.to_i).abs > OpenID::Nonce.skew
      Nonce.create(server_url: server_url, timestamp: timestamp, salt: salt)
      true
    end

    def cleanup_nonces
      now = Time.now.to_i
      Nonce.where("timestamp > ? OR timestamp < ?", now + OpenID::Nonce.skew, now - OpenID::Nonce.skew).delete_all
    end

    def cleanup_associations
      now = Time.now.to_i
      Association.where("issued + lifetime > ?", now).delete_all
    end
  end
end
