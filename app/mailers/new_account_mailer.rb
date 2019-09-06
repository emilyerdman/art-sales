class NewAccountMailer < ApplicationMailer

  def new_account_email(user)
    @user = user
    mail(to: "help@erdman-art-group.com", subject: 'New Account Notice')
  end

end