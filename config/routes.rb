Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :models, only: [] do
      member do
        get :index
        get :show
      end
    end
  end
end
