source 'https://rubygems.org'

ruby "2.2.3", { :engine => "jruby", :engine_version => "9.0.5.0" }

gem 'rails', '4.2.5.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem "pg", "0.17.2", { :platform => :jruby, :git => "git://github.com/nuvi/jruby-pg.git", :branch => :master }
gem "dotenv-rails"
# Needed in jruby?
#gem "concurrent-ruby"
gem "puma"


group :test do
  gem "mocha", { :require => false }
  gem "rubocop", { :require => false }
  gem "simplecov", { :require => false }
end

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :development, :test do
  gem "pry"
  gem "pry-nav"
end



