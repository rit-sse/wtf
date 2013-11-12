Wtf::Application.routes.draw do


  scope "/admin" do
    resources :events
    resources :committees
    resources :uploads

    match '/events' => 'events#index', as: "admin_events"

    match '/diagnostics(/:action)', controller: 'diagnostics' if Rails.env.development?

    root to: 'admin#index', as: "admin"
  end

  namespace "admin" do
    resources :pages
    resources :blocks
  end

  match '/login', to: 'auth#index'
  match '/logout', to: 'auth#logout'
  post '/auth(/:action)', controller: 'auth'

  match '/events' => 'events#public_index', as: "events_public_events"
  match '/events/current', to: 'events#current'
  match '/events/gtv', to: 'events#gtv'
  match '/events/ftv', to: 'events#ftv'
  match '/events(/:id)' => 'events#public_show', as: "events_public_show"
  
  get '/orbiter/add'
  get '/orbiter/destroy'
  match '/orbiter/edit' => 'orbiter#edit', :via => [:post]
  
  get '/membership', to: 'membership#index', as: 'memberships'
  get '/membership/new', to: 'membership#new'
  post '/membership/new', to: 'membership#create'

  # static routes and redirects
  # ...

  # root
  root :to => 'root#index'

  # for dynamic pages
  match '/*path', to: 'pages#dynamic_page'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
