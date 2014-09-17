module SessionsHelper
#   def current_user
# @current_user ||= User.find(session[:user_id]) if session[:user_id]
#     Rails.logger.info("CURRENT: #{@current_user.inspect}")
#         Rails.logger.info("CURRENT2: #{session.inspect}")
#   end

  def main_page
    current_page?('/')
  end

  def login_user!(user)
    session[:session_token] = user.session_token
  end

  def logout_current_user!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  # def require_current_user!
  #   redirect_to new_session_url if current_user.nil?
  # end
  def require_no_current_user!
    redirect_to user_url(current_user) unless current_user.nil?
  end
end