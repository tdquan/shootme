class ChargesController < ApplicationController
  def new
  end

  def create
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    if charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => params[:amount],
      :currency    => 'eur',
    )
      booking = Booking.find(params[:booking])
      booking.paid = true
      booking.save
    end
    redirect_to inbox_path(current_user)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
