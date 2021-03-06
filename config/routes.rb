Qa::Application.routes.draw do

  controller :private_message do
    get "messages/inbox" => :inbox
    get "messages/outbox" => :outbox
    get "messages/unread" => :check
    post "messages" => :create
    get "messages/:message_id" => :get
    delete "messages/:message_id" => :delete
    post "users/suggest" => :suggest_users
  end

  # remove bullshit ajax test
  #get "ajaxtest" => "application#ajax_test"

  devise_for :users, :controllers => { registrations: "registrations" }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#index'


  get 'admin' => 'application#admin_test'
  get 'loggedin' => 'application#logged_in_test'

  # remove bullshit
  #wash_out :soap

  #put "rest/privilege" => 'rest#c_priv'
  #get "rest/privilege" => 'rest#r_priv'
  #get "rest/privilege/:id" => 'rest#r_priv'

  #post 'rest/privileges/:privilege_id' => 'rest#u_priv'
  #delete 'rest/privileges/:privilege_id' => 'rest#d_priv'
  #get "rest/c_log"
  #get "rest/r_log"


  controller :question do
    put 'questions' => :create
    get 'questions/:question_id' => :get
    post 'questions/:question_id' => :update
    delete 'questions/:question_id' => :delete
    post 'questions/:question_id/open' => :open_question
    post 'questions/:question_id/close' => :close_question
    get 'questions' => :get_all
    get 'static/q/:question_id' => :get_static
  end

  controller :answer do
    put 'question/:question_id/answers' => :create
    post 'question/:question_id/answers/:answer_id' => :update
    delete 'question/:question_id/answers/:answer_id' => :delete
    post 'question/:question_id/answers/:answer_id/pick' => :pick
    post 'question/:question_id/answers/:answer_id/unpick' => :unpick
    get 'question/:question_id/answers' => :get_all
  end

  controller :admin do
    get 'users/ban' => :ban
    get 'users/unban' => :unban
    get 'users/promote' =>:promote
    get 'users/demote' =>:demote
    post 'users/edit' =>:edit
    post 'users/:user_id/edit' =>:edit
    get 'users/profile' =>:profile
    get 'users' => :get_users
    get 'report' => :report
  end

  controller :user do
    get 'user/public/profile' => :profile
  end

  controller :log do
    get 'logs' => :get_logs
  end

  controller :locale do
    get 'locale/read' => :get
    post 'locale/set' => :set
  end

  controller :statistics do
    get 'statistics/registrations/daily' => :registrations_daily
    get 'statistics/registrations/distribution' => :registrations_distribution
    get 'statistics/answers/daily' => :answers_daily
    get 'statistics/answers/distribution' => :answered_distribution
    get 'statistics/privileges/distribution' => :privilege_distribution
    get 'statistics/questions/daily' => :questions_daily
  end

  controller :search do
    get 'search/questions' => :search_questions
    get 'search/questions/similar/:question_id' => :search_similar_questions
  end

  controller :vote do
    post 'question/vote' => :vote_question
    post 'answer/vote' => :vote_answer
  end

  controller :following do
    get 'followings' => :get_following_tags
    put 'following' => :create_following_tag
    delete 'followings/:following_id' => :delete_following_tag
  end


end
