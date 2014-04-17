Wtf::Application.routes.draw do

  resources :events
  resources :committees

  match '/events' => 'events#index', as: "admin_events"

  match '/diagnostics(/:action)', controller: 'diagnostics' if Rails.env.development?

  match '/login', to: 'auth#index'
  match '/logout', to: 'auth#logout'
  post '/auth(/:action)', controller: 'auth'

  match '/events_public' => 'events#public_index', as: "events_public_events"
  # root
  root :to => 'root#index'

  # for dynamic pages
  # match '/*path', to: 'pages#dynamic_page'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
