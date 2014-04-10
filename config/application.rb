require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Redass
  class Application < Rails::Application

    config.autoload_paths += %W(#{config.root}/lib)

    config.session_store :redis_store, :servers => {
      :host => ENV['REDIS_HOST'],
      :port => ENV['REDIS_PORT'],
      :db => 0,
      :namespace => ENV['REDIS_SESSION_NAMESPACE'],
      :expires_in => 90.minutes
    }

    Slim::Engine.set_default_options pretty: true, sort_attrs: false
  end
end
