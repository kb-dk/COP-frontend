source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "~> 2.6.5"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# gem 'rails', '~> 5.0.1'
gem "actionview", ">= 5.0.7.2"
#
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
#
gem "nokogiri", ">= 1.13.6"
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'xray-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'blacklight', '~> 6.0'
gem 'blacklight-gallery'

group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end

gem 'rsolr', '~> 1.0'
gem "devise", ">= 4.6.0"
gem 'devise-guests', '~> 0.5'
gem 'devise_cas_authenticatable'
gem "bootstrap-sass", ">= 3.4.1"
gem "rack", ">= 2.0.6"
gem "rails-html-sanitizer", ">= 1.4.3"
gem "loofah", ">= 2.2.3"

#Makes it possible to find a file path using fx. page_path
gem 'high_voltage', '~> 3.0.0'
#Used in openseadragon
gem 'font-awesome-rails'

# Makes it possible to xraying the partials from the browser

# jstree
gem "jstree-rails-4"
# nicer scrollbars
gem 'perfect-scrollbar-rails'
# fixes the problem with javascript libraries(calendar and tree). Before they somethimes needed reloading to work
gem 'jquery-turbolinks'
