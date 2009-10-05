ActionController::Routing::Routes.draw do |map|
  map.root :controller => :posts
  map.resources :posts do |posts|
    posts.resources :comments, :only => [:create]
  end
end
