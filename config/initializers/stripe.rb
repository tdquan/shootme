Rails.configuration.stripe = {
  publishable_key: ENV['pk_test_rfgjub3u3gdmYPBETIDHlRH5'],
  secret_key:      ENV['sk_test_uSW7wOvuxqlkXl3Hnf9f0zGm']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
