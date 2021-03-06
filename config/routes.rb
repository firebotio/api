Rails.application.routes.draw do
  get "health" => "health#index"

  # Add application specific routes under here
  #-----------------------------------------------------------------------------
  namespace :v1, defaults: { format: :json }, path: "1" do
    resources :models, only: [], path: "models" do
      collection do
        post   :create,  path: ":type"
        delete :destroy, path: ":type/:id"
        get    :index,   path: ":type"
        get    :show,    path: ":type/:id", as: :show
        patch  :update,  path: ":type/:id"
        put    :update,  path: ":type/:id"
      end
    end

    resources :objects, only: [] do
      collection do
        post   :create,  path: ":type"
        delete :destroy, path: ":type/:id"
        get    :index,   path: ":type"
        get    :show,    path: ":type/:id", as: :show
        patch  :update,  path: ":type/:id"
        put    :update,  path: ":type/:id"
      end
    end

    resources :services, only: [] do
      collection do
        post :email
        # post :sms
      end
    end
  end
end
