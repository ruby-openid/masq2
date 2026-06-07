require "test_helper"

module Masq
  class SessionsControllerTest < ActionController::TestCase
    fixtures :accounts

    def test_should_save_account_id_in_session_after_successful_login
      post(:create, params: {login: accounts(:standard).login, password: "test"})
      assert(session[:account_id])
    end

    def test_should_redirect_to_users_identity_page_after_successful_login
      account = accounts(:standard)
      post(:create, params: {login: account.login, password: "test"})
      assert_redirected_to(identity_url(account, host: Masq::Engine.config.masq["host"]))
    end

    def test_should_redirect_to_users_on_login_if_already_logged_in
      login_as(:standard)
      account = accounts(:standard)
      get(:new)
      assert_redirected_to(identity_url(account, host: Masq::Engine.config.masq["host"]))
    end

    def test_should_set_cookie_with_auth_token_if_user_chose_to_be_remembered
      post(:create, params: {login: accounts(:standard).login, password: "test", remember_me: "1"})
      assert_not_nil(@response.cookies["auth_token"])
    end

    def test_should_not_set_cookie_with_auth_token_if_user_did_not_chose_to_be_remembered
      post(:create, params: {login: accounts(:standard).login, password: "test", remember_me: "0"})
      assert_nil(@response.cookies["auth_token"])
    end

    def test_should_not_save_account_id_in_session_after_failed_login
      post(:create, params: {login: accounts(:standard).login, password: "bad password"})
      assert_nil(session[:account_id])
    end

    def test_should_not_save_account_id_in_session_after_basic_login
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(accounts(:standard).login, "test")
      post(:new)
      assert_nil(session[:account_id])
      assert(@controller.send(:logged_in?))
      assert(@controller.send(:auth_type_used) == :basic)
    end

    def test_should_set_correct_auth_type_on_basic_login
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(accounts(:standard).login, "test")
      get(:new)
      assert(@controller.send(:auth_type_used) == :basic)
    end

    def test_should_set_correct_auth_type_on_login_with_session
      login_as(:standard)
      get(:new)
      assert(@controller.send(:auth_type_used) == :session)
    end

    def test_should_set_correct_auth_type_on_login_with_cookie
      accounts(:standard).remember_me
      @request.cookies["auth_token"] = cookie_for(:standard)
      get(:new)
      assert(@controller.send(:auth_type_used) == :cookie)
    end

    def test_should_redirect_to_login_after_failed_login
      post(:create, params: {login: accounts(:standard).login, password: "bad password"})
      assert_redirected_to(login_path(error: "incorrect-password"))
      assert(flash.any?)
    end

    def test_should_reset_session_on_logout
      login_as(:standard)
      get(:destroy)
      assert_nil(session[:account_id])
    end

    def test_should_redirect_to_homepage_after_logout
      login_as(:standard)
      get(:destroy)
      assert_redirected_to(root_path)
    end

    def test_should_delete_token_on_logout
      login_as(:standard)
      get(:destroy)
      assert_nil(@response.cookies["auth_token"])
    end

    def test_should_automatically_login_users_with_valid_auth_token_cookie
      accounts(:standard).remember_me
      @request.cookies["auth_token"] = cookie_for(:standard)
      get(:new)
      assert(@controller.send(:logged_in?))
    end

    def test_should_fail_to_login_users_with_expired_auth_token_cookie
      accounts(:standard).remember_me
      accounts(:standard).update_attribute(:remember_token_expires_at, 5.minutes.ago)
      @request.cookies["auth_token"] = cookie_for(:standard)
      get(:new)
      assert(!@controller.send(:logged_in?))
    end

    def test_should_fail_to_login_users_with_invalid_auth_token_cookie
      accounts(:standard).remember_me
      @request.cookies["auth_token"] = "invalid_auth_token"
      get(:new)
      assert(!@controller.send(:logged_in?))
    end

    def test_should_set_authentication_attributes_after_successful_login
      @account = accounts(:standard)
      post(:create, params: {login: @account.login, password: "test"})
      @account.reload
      assert_not_nil(@account.last_authenticated_at)
      assert(!@account.last_authenticated_by_yubikey)
    end

    def test_should_authenticate_with_password_and_yubico_otp
      original_can_use_yubikey = Masq::Engine.config.masq["can_use_yubikey"]
      Masq::Engine.config.masq["can_use_yubikey"] = true
      @account = accounts(:with_yubico_identity)
      assert_nil(@account.last_authenticated_at)
      assert(!@account.last_authenticated_by_yubikey)
      assert(@account.login == "yubikey")
      return_to = "/super-duper"
      original_return_to = session[:return_to]
      session[:return_to] = return_to
      yubico_otp = @account.yubico_identity + "x" * 32
      Masq::Account.expects(:verify_yubico_otp).with(yubico_otp).returns(true)
      post(:create, params: {login: @account.login, password: "test" + yubico_otp})
      session[:return_to] = original_return_to # Don't bleed state, even if the login failed.
      Masq::Engine.config.masq["can_use_yubikey"] = original_can_use_yubikey
      assert_redirected_to(return_to)
      @account.reload
      assert_not_nil(@account.last_authenticated_at)
      assert(@account.last_authenticated_by_yubikey)
    end

    def test_should_redirect_to_stored_relative_path_after_successful_login
      account = accounts(:standard)
      session[:return_to] = "/super-duper?yes=1"
      post(:create, params: {login: account.login, password: "test"})
      assert_redirected_to("/super-duper?yes=1")
    end

    def test_should_normalize_same_origin_stored_url_after_successful_login
      account = accounts(:standard)
      session[:return_to] = "http://test.host/super-duper?yes=1"
      post(:create, params: {login: account.login, password: "test"})
      assert_redirected_to("/super-duper?yes=1")
    end

    def test_should_ignore_external_stored_url_after_successful_login
      account = accounts(:standard)
      session[:return_to] = "https://evil.example/super-duper"
      post(:create, params: {login: account.login, password: "test"})
      assert_redirected_to(identity_url(account, host: Masq::Engine.config.masq["host"]))
      assert_nil(session[:return_to])
    end

    def test_should_ignore_protocol_relative_stored_url_after_successful_login
      account = accounts(:standard)
      session[:return_to] = "//evil.example/super-duper"
      post(:create, params: {login: account.login, password: "test"})
      assert_redirected_to(identity_url(account, host: Masq::Engine.config.masq["host"]))
      assert_nil(session[:return_to])
    end

    def test_should_ignore_backslash_prefixed_stored_url_after_successful_login
      account = accounts(:standard)
      session[:return_to] = "/\\evil.example/super-duper"
      post(:create, params: {login: account.login, password: "test"})
      assert_redirected_to(identity_url(account, host: Masq::Engine.config.masq["host"]))
      assert_nil(session[:return_to])
    end

    def test_should_disallow_password_only_login_when_yubikey_is_mandatory
      original_can_use_yubikey = Masq::Engine.config.masq["can_use_yubikey"]
      Masq::Engine.config.masq["can_use_yubikey"] = true
      account = accounts(:with_yubico_identity)
      post(:create, params: {login: account.login, password: "test"})
      Masq::Engine.config.masq["can_use_yubikey"] = original_can_use_yubikey
      assert_redirected_to(login_path(error: "incorrect-password"))
      assert(flash.any?)
    end

    protected

    def cookie_for(account)
      accounts(account).remember_token
    end
  end
end
