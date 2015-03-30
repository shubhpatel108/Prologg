Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks'}
  root to: 'profiles#index'

  get '/:username', to: 'profiles#show', as: :profile
  get '/users/edit_links', to: 'profiles#edit_links', as: :edit_links
  post '/users/update_links', to: 'profiles#update_links'

  get '/integrations/codeforces/new', to: 'codeforces_profile#new', as: :cfp_profile_new
  post '/integrations/codeforces/create', to: 'codeforces_profile#create'
  get '/integrations/codeforces/recent_submissions/:handle', to: 'codeforces_profile#recent_submissions', as: :cfp_submissions
  get '/integrations/codeforces/show/:username', to: 'codeforces_profile#show_cfp_profile', as: :cfp_show_profile
  get '/integrations/codeforces/update', to: 'codeforces_profile#update', as: :cfp_update_profile

  get '/integrations/edit', to: 'profiles#edit_integrations', as: :edit_integrations

  get '/integrations/github/create', to: 'github_profile#create', as: :github_profile_create
  get '/integrations/github/show/:username', to: 'github_profile#show', as: :github_show_profile

  get '/integrations/topcoder/new', to: 'topcoder_profile#new', as: :topcoder_profile_new
  post '/integrations/topcoder/create', to: 'topcoder_profile#create', as: :topcoder_profile_create
  get '/integrations/topcoder/show/:username', to: 'topcoder_profile#show_tcp_profile', as: :tcp_show_profile

  get '/integrations/linkedin/create', to: 'linkedin_profile#create', as: :linkedin_profile_create
  get '/integrations/linkedin/show/:username', to: 'linkedin_profile#show_profile', as: :linkedin_show_profile
  post '/integrations/linkedin/refine', to: 'linkedin_profile#refine', as: :linkedin_refine

  #get '/mails/_show'
  get '/mails/new/:username', to: 'mails#new', as: :new_mails
  post '/mails/send/:username', to: 'mails#send_mail', as: :send_mails

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
