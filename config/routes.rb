Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  get '/autocomplete/products', to: 'taxons#autocomplete', as: :autocomplete
end
