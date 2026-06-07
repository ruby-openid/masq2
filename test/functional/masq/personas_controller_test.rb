require "test_helper"

module Masq
  class PersonasControllerTest < ActionController::TestCase
    fixtures :accounts, :personas

    def test_should_require_login_for_index
      get(:index)
      assert_login_required
    end

    def test_should_have_list_of_personas_on_index
      login_as(:standard)
      get(:index)
      assert_response(:success)
      assert_not_nil(assigns(:personas))
    end

    def test_should_require_login_for_new
      get(:new)
      assert_login_required
    end

    def test_should_get_new
      login_as(:standard)
      get(:new)
      assert_response(:success)
    end

    def test_should_require_login_for_create
      post(:create, params: {persona: valid_persona_attributes})
      assert_login_required
    end

    def test_should_create_persona
      login_as(:standard)
      assert_difference("Masq::Persona.count", 1) do
        post(:create, params: {persona: valid_persona_attributes})
      end
      assert_redirected_to(account_personas_path)
    end

    def test_should_require_login_for_edit
      get(:edit, params: {id: personas(:public).id})
      assert_login_required
    end

    def test_should_get_edit
      login_as(:standard)
      get(:edit, params: {id: personas(:public).id})
      assert_response(:success)
    end

    def test_should_store_relative_return_url_for_edit
      login_as(:standard)
      get(:edit, params: {id: personas(:public).id, return: "/server/decide"})
      assert_equal("/server/decide", session[:return_to])
    end

    def test_should_normalize_same_origin_return_url_for_edit
      login_as(:standard)
      get(:edit, params: {id: personas(:public).id, return: "http://test.host/server/decide"})
      assert_equal("/server/decide", session[:return_to])
    end

    def test_should_ignore_external_return_url_for_edit
      login_as(:standard)
      get(:edit, params: {id: personas(:public).id, return: "https://evil.example/server/decide"})
      assert_nil(session[:return_to])
    end

    def test_should_ignore_protocol_relative_return_url_for_edit
      login_as(:standard)
      get(:edit, params: {id: personas(:public).id, return: "//evil.example/server/decide"})
      assert_nil(session[:return_to])
    end

    def test_should_ignore_backslash_prefixed_return_url_for_edit
      login_as(:standard)
      get(:edit, params: {id: personas(:public).id, return: "/\\evil.example/server/decide"})
      assert_nil(session[:return_to])
    end

    def test_should_require_login_for_update
      put(:update, params: {id: personas(:public).id, persona: valid_persona_attributes})
      assert_login_required
    end

    def test_should_update_persona
      login_as(:standard)
      put(:update, params: {id: personas(:public).id, persona: valid_persona_attributes})
      assert_redirected_to(account_personas_path)
      expected_attributes = Masq::Persona.new(valid_persona_attributes).attributes.reject { |_, v| v.nil? }
      assert_equal(expected_attributes, Masq::Persona.find(personas(:public).id).attributes.slice(*expected_attributes.keys))
    end

    def test_should_require_login_for_destroy
      delete(:destroy, params: {id: personas(:public).id})
      assert_login_required
    end

    def test_should_destroy_persona
      login_as(:standard)
      assert_difference("Masq::Persona.count", -1) do
        delete(:destroy, params: {id: personas(:public).id})
      end
      assert_redirected_to(account_personas_path)
    end
  end
end
