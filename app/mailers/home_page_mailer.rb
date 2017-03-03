class HomePageMailer < ApplicationMailer
  default from: 'trinhquan@gmail.com'

  def contact_mailer(user, message)
    @user = user
    @message = message
    mail(to: 'trinhquan@gmail.com', subject: 'Hello Shoot-Me')
  end
end
