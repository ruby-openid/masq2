require "uri"

module Masq
  module AuthenticatedSystem
    protected

    # Returns true or false if the account is logged in.
    # Preloads @current_account with the account model if they're logged in.
    def logged_in?
      current_account != :false
    end

    # Accesses the current account from the session.  Set it to :false if login fails
    # so that future calls do not hit the database.
    def current_account
      @current_account ||= login_from_session || login_from_basic_auth || login_from_cookie || :false
    end

    # Store the given account id in the session.
    def current_account=(new_account)
      if auth_type_used != :basic
        session[:account_id] = (new_account.nil? || new_account.is_a?(Symbol)) ? nil : new_account.id
      end
      @current_account = new_account || :false
    end

    # Check if the account is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the account
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_account.login != "bob"
    #  end
    def authorized?
      logged_in?
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_action :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_action :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_action :login_required
    #
    def login_required
      authorized? || access_denied
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the account is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |format|
        format.html do
          store_location
          redirect_to(login_path)
        end
        format.any do
          request_http_basic_authentication("Web Password")
        end
      end
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location(url = request.fullpath)
      safe_url = safe_return_url(url)
      session[:return_to] = safe_url if safe_url
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(safe_return_url(session[:return_to]) || default)
      session[:return_to] = nil
    end

    def safe_return_url(url)
      return if url.blank?

      location = url.to_s
      uri = URI.parse(location)

      if uri.scheme.nil? && uri.host.nil?
        return if location.start_with?("//")
        return if location.start_with?("/\\")

        path = relative_return_path(uri)
        return path if path.start_with?("/")
      end

      return unless %w[http https].include?(uri.scheme.to_s.downcase)
      return unless same_origin_return_uri?(uri)

      uri.request_uri.presence || "/"
    rescue URI::InvalidURIError
      nil
    end

    def relative_return_path(uri)
      path = uri.path.to_s
      path = "/" if path.empty?
      uri.query ? "#{path}?#{uri.query}" : path
    end

    def same_origin_return_uri?(uri)
      uri.scheme.to_s.downcase == request.scheme.to_s.downcase &&
        uri.host.to_s.downcase == request.host.to_s.downcase &&
        effective_return_port(uri) == request.port
    end

    def effective_return_port(uri)
      return uri.port if uri.port
      return 443 if uri.scheme == "https"

      80
    end

    # Inclusion hook to make #current_account and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send(:helper_method, :current_account, :logged_in?, :auth_type_used)
    end

    # Called from #current_account.  First attempt to log in by the account id stored in the session.
    def login_from_session
      account = Account.find(session[:account_id]) if session[:account_id]
      self.auth_type_used = :session if !account.nil?
      self.current_account = account
    end

    def auth_type_used
      @auth_type_used if defined?(@auth_type_used)
    end

    def auth_type_used= t
      @auth_type_used = t
    end

    # Called from #current_account.  Now, attempt to log in by basic authentication information.
    def login_from_basic_auth
      authenticate_with_http_basic do |accountname, password|
        account = Account.authenticate(accountname, password, true)
        self.auth_type_used = :basic if !account.nil?
        self.current_account = account
        account
      end
    end

    # Called from #current_account.  Finally, attempt to log in by an expiring token in the cookie.
    def login_from_cookie
      account = cookies[:auth_token] && Account.find_by(remember_token: cookies[:auth_token])
      if account && account.remember_token?
        account.remember_me
        cookies[:auth_token] = {value: account.remember_token, expires: account.remember_token_expires_at}
        self.auth_type_used = :cookie if !account.nil?
        self.current_account = account
        account
      end
    end
  end
end
