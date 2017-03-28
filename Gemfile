source 'https://rubygems.org'
ruby '>=2.3.1'

gem 'rails', '5.0.0.1'
gem 'devise'
gem 'unicorn'
gem 'sqlite3'
gem 'figaro'
gem 'jbuilder', '~> 2.0'
gem 'redis'

gem 'sass-rails'
gem 'jquery-rails'
gem 'uglifier'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'simple_form'
gem 'autoprefixer-rails'

group :development, :test do
  gem 'binding_of_caller'
  gem 'better_errors'

  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'spring'
  gem 'listen', '~> 3.0.5'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'letter_opener' # mails
  gem 'faker'
end

group :production do
  gem 'pg'
  # capistrano
  gem "capistrano", "~> 3.7"
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-unicorn',   require: false
end

source 'https://rails-assets.org' do
  gem 'rails-assets-underscore'
end

#calendar
# gem 'simple-form-datepicker'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'

#maps
gem 'geocoder'
gem 'gmaps4rails'
gem "coffee-rails"

# authorizations:
gem 'pundit'

# authentification
gem 'simple_token_authentication'

# internationalization
gem 'rails-i18n', '~> 5.0.0'
gem 'devise-i18n'

gem 'sidekiq'

# mails
gem 'mailchimp-api', '~> 2.0', '>= 2.0.6'

# search
# gem 'elasticsearch-model'
# gem 'elasticsearch-rails'
# gem 'elasticsearch-dsl'

gem "pg_search"

#responder
gem 'responders'

#stripe payment
gem 'coffee-script'
gem 'stripe'

#facebook connect
gem 'omniauth-facebook'

#google connect
gem "omniauth-google-oauth2", git: 'https://github.com/zquestz/omniauth-google-oauth2', :branch => 'master'
#cloudinary
gem 'cloudinary'

#attachinary
gem 'attachinary', github: 'assembler/attachinary'
gem 'jquery-fileupload-rails'

#money
gem 'money-rails'
