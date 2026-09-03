source 'https://rubygems.org'

gemspec

ruby '3.4.2'

rails_version = ENV['RAILS_VERSION'] || 'default'

rails = case rails_version
when 'master'
  { :github => 'rails/rails'}
when 'default'
  '~> 8.0.0'
else
  "~> #{rails_version}"
end

gem 'rails', rails

gem 'activestorage', '>= 8.0.5.1'

gem 'nokogiri', '>= 1.18.9'

gem "concurrent-ruby", ">= 1.3.7"
