source 'https://rubygems.org'

gemspec

ruby '3.4.1'

rails_version = ENV['RAILS_VERSION'] || 'default'

rails = case rails_version
when 'master'
  { :github => 'rails/rails'}
when 'default'
  '~> 7.2.0'
else
  "~> #{rails_version}"
end

gem 'rails', rails
