Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  get '/admin/orders/:id/pickup' => 'admin/orders#pickup'
  post '/admin/orders/:id/pickup' => 'admin/orders#pickup'
end
