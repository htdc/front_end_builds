source 'https://rubygems.org'

gemspec

rails_version = ENV['RAILS_VERSION'] || 'default'

rails = case rails_version
when 'master'
  { :github => 'rails/rails'}
when 'default'
  '~> 7.1.0'
else
  "~> #{rails_version}"
end

gem 'rails', rails

gem 'bigdecimal', '1.4.2'

# these are here so travis will work
group :test, :development do
  gem 'sqlite3', '1.4'
end
