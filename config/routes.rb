require 'resque/server'

Redass::Application.routes.draw do

  mount Resque::Server.new, :at => "/resque", as: 'resque'
  # mount Peek::Railtie => "/peek"

  scope 'namespaces' do
    post 'delete', to: 'namespaces#delete'
    get ':namespace', to: 'namespaces#view', requirements: { namespace: %r([^/;:,?]+) }
    get '/', to: 'namespaces#list'
  end

  scope 'keys' do
    post '/key', to: 'keys#delete'
    get '/', to: 'keys#all'
  end

  root 'home#index'
end
