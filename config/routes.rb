Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    resources :models, only: [] do
      collection do
        get :index, path: ":type"
        get :show,  path: ":type/:id"
      end
    end
  end
end
