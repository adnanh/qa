Qa::Application.routes.draw do
  get "messages/inbox" => "private_message#inbox"
  get "messages/outbox" => "private_message#outbox"
  get "messages/unread" => "private_message#check"
  post "messages" => "private_message#create"
  get "messages/:message_id" => "private_message#get"
  delete "messages/:message_id" => "private_message#delete"

  get "private_message/check"

  devise_for :users, :controllers => { :registrations => "registrations" }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'


  get 'admin' => 'application#admin_test'
  get 'loggedin' => 'application#logged_in_test'


  wash_out :soap

  put "rest/privilege" => 'rest#c_priv'
  get "rest/privilege" => 'rest#r_priv'
  get "rest/privilege/:id" => 'rest#r_priv'

  post 'rest/privileges/:privilege_id' => 'rest#u_priv'
  delete 'rest/privileges/:privilege_id' => 'rest#d_priv'
  get "rest/c_log"
  get "rest/r_log"


  controller :question do
    put 'questions' => :create
    get 'questions/:question_id' => :get
    post 'questions/:question_id' => :update
    delete 'questions/:question_id' => :delete
    post 'questions/:question_id/open' => :open_question
    post 'questions/:question_id/close' => :close_question
  end

  controller :answer do
    put 'question/:question_id/answers' => :create
    post 'question/:question_id/answers/:answer_id' => :update
    delete 'question/:question_id/answers/:answer_id' => :delete
    post 'question/:question_id/answers/:answer_id/pick' => :pick
    post 'question/:question_id/answers/:answer_id/unpick' => :unpick
  end

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
