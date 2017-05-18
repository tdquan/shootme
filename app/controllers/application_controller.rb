require "application_responder"

class ApplicationController < ActionController::Base
  before_action :set_locale
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address, :postal_code, :city, :country,  :longitude, :latitude, :fee_cents, :description, :pro, :equipments])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name,
      :address, :postal_code, :city, :country, :avatar, :fee_cents, :description, :pro, :role])
  end

  def set_locale
    I18n.locale = params[:locale].present? ? params[:locale].to_sym : I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end
end
