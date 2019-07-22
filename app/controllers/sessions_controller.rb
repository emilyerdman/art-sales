class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      #flash[:success] = "Successfully logged in."
      redirect_to root_url
    else
      flash[:danger] = "Email or password is invalid"
      redirect_to login_url
    end
  end

  def destroy
    session[:user_id] = nil
    #flash[:success] = "Successfully logged out."
    redirect_to login_url
  end
end