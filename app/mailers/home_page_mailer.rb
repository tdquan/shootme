class HomePageMailer < ApplicationMailer
  default from: 'shootme.cbm@gmail.com'

  def contact_mailer(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: 'Hello Shoot-Me')
  end
end
