source 'http://ruby.taobao.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# This gem is a port of Perl's Data::Faker library that generates fake data
gem 'faker'

############## authorization
# Doorkeeper is an OAuth 2 provider for Rails.
gem "doorkeeper", "~> 0.6.7"
# Flexible authentication solution for Rails with Warden
gem "devise", "~> 2.2.4"
# A Ruby wrapper for the OAuth 2.0 protocol built with a similar style to the original OAuth spec.
gem "oauth2", "~> 0.9.1"


# Middleware that will make Rack-based apps CORS compatible. Read more here: http://blog.sourcebender.com/2010/06/09/introducin-rack-cors.html. Fork the project here: http://github.com/cyu/rack-cors
gem 'rack-cors', :require => 'rack/cors'
########################################
# Fast and easy syntax highlighting for selected languages, written in Ruby. Comes with RedCloth integration and LOC counter.
gem "coderay", "~> 1.0.9"
# A fast, safe and extensible Markdown to (X)HTML parser
gem "redcarpet", "~> 2.2.2"


#################################
gem 'mongoid'
gem "mongoid-sequence2", "~> 0.2.0"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "jquery-rails"
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :development do
  gem 'debugger'
  gem 'thin'
  gem "quiet_assets", "~> 1.0.2"
end

group :development, :test do
  # gem 'sqlite3'
  gem 'database_cleaner'
  gem 'webrat'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'nokogiri', '~> 1.5.0'
end
