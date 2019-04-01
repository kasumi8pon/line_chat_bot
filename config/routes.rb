# frozen_string_literal: true

Rails.application.routes.draw do
  post "/callback" => "webhook#callback"
  resources :items, except: [:show, :new, :edit, :update]
  resources :meals, except: [:show, :new, :edit, :update]
  get "home/top" => "home#top"
  root to: "home#top"
end
