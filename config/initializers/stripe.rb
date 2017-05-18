Rails.configuration.stripe = {
  publishable_key: 'pk_test_5RlwKtafN0ekv28eTsQ1etmQ', # pk_test_zI4d2dniOWZqgU7LCm0RXB5u
  secret_key:      'sk_test_RDQ2OvHT5avxYmei7AeplbDG' # sk_test_LBDquoZ4gZ7OuStYRJQknXwl
}

Stripe.api_key = Rails.configuration.stripe[:secret_key];
