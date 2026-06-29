require "test_helper"

module Masq
  class SignupTest < ActiveSupport::TestCase
    def test_signup_with_valid_account
      signup = Masq::Signup.create_account!(valid_account_attributes)
      assert(signup.succeeded?)
      assert_kind_of(Masq::Account, signup.account)
    end

    def test_signup_with_invalid_account
      signup = Masq::Signup.create_account!
      assert(!signup.succeeded?)
      assert_kind_of(Masq::Account, signup.account)
    end

    def test_should_assign_activation_code_on_create_if_send_activation_mail_is_enabled
      Masq::Engine.config.masq["send_activation_mail"] = true
      signup = Masq::Signup.create_account!(valid_account_attributes)
      assert_not_nil(signup.account.activation_code)
    end

    def test_should_send_activation_mail_on_create_if_send_activation_mail_is_enabled
      Masq::Engine.config.masq["send_activation_mail"] = true
      mail = mock("mail", deliver_now: true)
      Masq::AccountMailer.expects(:signup_notification).returns(mail)
      Masq::Signup.create_account!(valid_account_attributes)
    end

    def test_should_not_assign_activation_code_on_create_if_send_activation_mail_is_disabled
      Masq::Engine.config.masq["send_activation_mail"] = false
      signup = Masq::Signup.create_account!(valid_account_attributes)
      assert_nil(signup.account.activation_code)
    end

    def test_should_not_send_activation_mail_on_create_if_send_activation_mail_is_disabled
      Masq::Engine.config.masq["send_activation_mail"] = false
      Masq::AccountMailer.expects(:signup_notification).never
      Masq::Signup.create_account!(valid_account_attributes)
    end

    def test_should_create_default_personas_on_create
      signup = Masq::Signup.create_account!(valid_account_attributes)
      account = signup.account
      persona = account.personas.first
      assert_not_nil(persona)
      assert_equal("Standard", persona.title)
      assert_equal(account.email, persona.email)
      assert_equal(1, account.personas.size)
    end
  end
end
