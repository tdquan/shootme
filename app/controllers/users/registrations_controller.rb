class Users::RegistrationsController < Devise::RegistrationsController
  def show
    @current_user = current_user
    @request = Request.new
    @cities = ["Paris", "London"]
  end

  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  def delete
    super
  end
end
