class HomePageMailer < ApplicationMailer
  default from: 'shootme.cbm@gmail.com'

  def contact_mailer(user, message)
    @user = user
    @message = message
    mail(to: @user.email, subject: 'Hello Shoot-Me')
  end

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Shoot Me!')
  end

  def creation_confirmation(request)
    @request = request

    mail(
      to:       @request.client.email,
      subject:  "Request at #{@request.location} created!"
    )
  end
end




