Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  get '/admin/orders/:id/pickup' => 'admin/orders#pickup'
  post '/admin/orders/:id/pickup' => 'admin/orders#pickup'
  put '/admin/orders/:id/pickup' => 'admin/orders#pickup'

  get '/admin/orders/:id/dropoff' => 'admin/orders#dropoff'
  post '/admin/orders/:id/dropoff' => 'admin/orders#dropoff'
  put '/admin/orders/:id/dropoff' => 'admin/orders#dropoff'
end
