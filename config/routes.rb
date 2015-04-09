Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json }, path: "1" do
    resources :models, only: [], path: "objects" do
      collection do
        post   :create,  path: ":type"
        delete :destroy, path: ":type/:id"
        get    :index,   path: ":type"
        get    :show,    path: ":type/:id"
        patch  :update,  path: ":type/:id"
        put    :update,  path: ":type/:id"
      end
    end
  end
end
