class ForgotPasswordMailer < ApplicationMailer

  def forgot_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Request to Reset Your Password')
  end

end
