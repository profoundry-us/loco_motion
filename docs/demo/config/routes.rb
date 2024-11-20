Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Dynamic route which shows various examples
  get "/examples/:id", to: "examples#discover"

  get "/api-docs", to: "api_docs#index"

  post "/taas/generate", to: "tailwind_as_a_service#generate"

  # Defines the root path route ("/")
  root "application#home"
end
