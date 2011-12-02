Wtf::Application.routes.draw do

  scope "/admin" do
    resources :pages

    match '/diagnostics(/:action)', controller: 'diagnostics' if Rails.env.development?

    root to: 'admin#index'
  end

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
