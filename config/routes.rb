# frozen_string_literal: true

Rails.application.routes.draw do
  namespace "v1" do
    resources :posts
    resources :users
    mount_devise_token_auth_for "User", at: "auth"
  end
end
