Rails.application.routes.draw do
  get 'home/index'
  get 'home/seed'
  get 'home/work_hard'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
