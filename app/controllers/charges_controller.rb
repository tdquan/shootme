class ChargesController < ApplicationController
  def new
  end

  def create
    if current_user.stripe_id
      customer = Stripe::Customer.retrieve(current_user.stripe_id)
    else
      customer = Stripe::Customer.create(
        email:  current_user.email,
        source: params[:stripeToken]
      )
      current_user.stripe_id = customer.id
      current_user.save!
    end

    if charge = Stripe::Charge.create(
      customer: customer.id,
      amount:   params[:amount],
      currency: 'eur',
    )
      if params[:booking] && charge.amount == Booking.find(params[:booking]).price_cents
        booking = Booking.find(params[:booking])
        booking.paid = true
        booking.save
      end
    end
    redirect_to inbox_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to booking_charge_path(amount: params[:amount], booking: params[:booking])
  end
end
