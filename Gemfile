source 'https://rubygems.org'
ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

# Bootstrap
gem 'bootstrap-sass'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.0.0.beta'
# Help jQuery work with TurboLinks
gem 'jquery-turbolinks'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma'
gem 'resque', "~> 1.22.0", :require => "resque/server"
gem 'redis'

# User authentication
gem 'devise'
gem "devise-async"
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# Pagination
gem 'kaminari'

# Sending Mass Emails
gem 'mandrill-api'

# DB For Heroku
gem 'pg'

# Easy recurring events scheduling
gem 'ice_cube'

# Calendar Building
gem 'fullcalendar-rails'

# Chart js
gem 'chart-js-rails'

# Search Forms
gem "ransack"

# Rank and Sort Rows
gem 'ranked-model'

# Form Fields
gem 'nested_form_fields'

# Date Time Picker
gem 'bootstrap3-datetimepicker-rails'
gem 'bootstrap-datepicker-rails'

# Prevents overlap of appointments
gem 'validates_overlap'



group :development, :test do
  # Catches mail in test and dev
  gem  'mailcatcher'

  # Easily create fake data for development
  gem 'faker'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'database_cleaner', github: 'bmabey/database_cleaner'

end


group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'rails_12factor'
end

