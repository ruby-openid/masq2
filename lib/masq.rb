# frozen_string_literal: true

# external gems
require "version_gem"
require_relative "masq/version"

# this library's version

module Masq
  # Load order matters here!
  # This gem must be loaded **after** Rails in order for the Engine to register itself automatically.
  # Otherwise, you'd have to manually require what you need from below.
  if defined?(::Rails) && defined?(::Rails::VERSION)
    begin
      require_relative "masq/engine"
      require_relative "masq/authenticated_system"
      require_relative "masq/openid_server_system"
      require_relative "masq/active_record_openid_store/association"
      require_relative "masq/active_record_openid_store/nonce"
      require_relative "masq/active_record_openid_store/openid_ar_store"
      require_relative "masq/signup"
    rescue StandardError, LoadError => error
      if !defined?(::Rails::Engine)
        warn("masq2 is a Rails engine, but Rails::Engine isn't defined.")
      else
        warn(<<~WARNING)
          Unable to load masq2. Please check your configuration.
          If you're using Rails 5.2 or later, you should add masq2 to your Gemfile and run `bundle install`.
          Then add:
            require "masq/engine"
    
          If unable to resolve, please report a bug to the issue tracker at https://github.com/oauth-xx/masq2

          Original Error:
          #{error.class}: #{error.message}

          BACKTRACE:
          #{Array(error.backtrace).join("\n")}
        WARNING
      end
    end
  else
    warn("masq2 was loaded before Rails. Please check your configuration.")
  end
end

# Ensure version is configured before loading the rest of the library
Masq::Version.class_eval do
  extend VersionGem::Basic
end
