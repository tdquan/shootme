Rails.configuration.stripe = {
  publishable_key: 'pk_test_oqxcVbV2SGxUWqO8cEv8y1DV',
  secret_key:      'sk_test_SiCSTvXSN1dlaDF4a6FgsNw9'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key];
