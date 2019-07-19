class PasswordsController < ApplicationController

  def forgot
    if params[:email].blank? # check if email is present
      render json: {error: 'Email not present'}
    end

    user = User.find_by(email: params[:email]) # if present find user by email

    if user.present?
      user.generate_password_token! #generate pass token
      ForgotPasswordMailer.forgot_password_email(user).deliver_now
      redirect_to login_url
    else
      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
    end
  end

  def edit
    @user = User.find_by_reset_password_token!(params[:id])
  end

  def reset
    token = params[:token].to_s
    if params[:email].blank?
      render json: {error: 'Token not present'}
    end

    user = User.find_by(reset_password_token: token)

    # add the time thing so that if it's been more than an hour it won't let you reset
    puts (Time.now - user.reset_password_sent_at)
    puts user.reset_password_sent_at + 60*60

    if user.present? && user.password_token_valid? && (Time.now - user.reset_password_sent_at) <= 360
      if user.reset_password!(params[:password])
        redirect_to login_url
      else
        render json: {error: user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
    end
  end

  def show_reset
    render 'reset_password'
  end

end