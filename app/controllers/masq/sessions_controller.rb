module Masq
  class SessionsController < BaseController
    before_action :login_required, only: :destroy
    after_action :set_login_cookie, only: :create

    def new
      redirect_after_login if logged_in?
    end

    def create
      self.current_account = Masq::Account.authenticate(params[:login], params[:password])
      if logged_in?
        flash[:notice] = t(:you_are_logged_in)
        redirect_after_login
      else
        a = Masq::Account.find_by(login: params[:login])
        if a.nil?
          redirect_to(login_path(error: "incorrect-login"), alert: t(:login_incorrect))
        elsif a.active? && a.enabled?
          redirect_to(login_path(error: "incorrect-password"), alert: t(:password_incorrect))
        elsif !a.enabled?
          redirect_to(login_path(error: "deactivated"), alert: t(:account_deactivated))
        else
          redirect_to(login_path(resend_activation_for: params[:login]), alert: t(:account_not_yet_activated))
        end
      end
    end

    def destroy
      current_account.forget_me
      cookies.delete(:auth_token)
      reset_session
      redirect_to(root_path, notice: t(:you_are_now_logged_out))
    end

    private

    def set_login_cookie
      if logged_in? and params[:remember_me] == "1"
        current_account.remember_me
        cookies[:auth_token] = {
          value: current_account.remember_token,
          expires: current_account.remember_token_expires_at
        }
      end
    end

    def redirect_after_login
      stored_return_to = session[:return_to]
      session[:return_to] = nil if stored_return_to
      return_to = safe_return_url(stored_return_to)
      redirect_to(return_to || identifier(current_account))
    end
  end
end
