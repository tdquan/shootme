class WalletController < ApplicationController
  def index
    @wallets = [ Wallet.new(user_id: current_user.id, amount_cents: 5000),
                 Wallet.new(user_id: current_user.id, amount_cents: 10000),
                 Wallet.new(user_id: current_user.id, amount_cents: 20000)
               ]
  end

  def payment
  end

  def top_up
    customer = Stripe::Customer.create(
      email:  params[:stripeEmail],
      source: params[:stripeToken]
    )

    if charge = Stripe::Charge.create(
      customer: customer.id,
      amount:   params[:amount],
      currency: 'eur',
    )
      wallet = current_user.wallet
      current_amount = wallet.amount.fractional
      new_amount = current_amount + charge.amount
      wallet.update(amount_cents: new_amount)
    end
    redirect_to user_path(current_user)

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to user_wallet_payment_path
  end
end
