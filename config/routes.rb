Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "signup", to: "auth#signup"
      post "login", to: "auth#login"

      resources :boards, only: %i[index show create update destroy] do
        resources :columns, only: %i[index create update destroy] do
          resources :cards, only: %i[index create update destroy] do
            patch :move, on: :member
          end
        end
      end
    end
  end
end
