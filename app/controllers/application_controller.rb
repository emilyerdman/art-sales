class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  helper_method :current_user, :current_user_approved
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def current_user_approved(category)
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
      if @current_user.category == category
        true
      end
    end
      false
  end

end
