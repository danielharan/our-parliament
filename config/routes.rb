ActionController::Routing::Routes.draw do |map|

  map.about '/about', :controller => 'application', :action => 'about'
  map.contact '/contact', :controller => 'application', :action => 'contact'
  map.francais '/francais', :controller => 'application', :action => 'francais'

  map.root :controller => 'application', :action => 'show'

  map.resources :members, :member => {:votes => :get}
  map.resources :hansards
  map.resources :votes
  map.resources :senators
  map.resources :committees
  map.resources :bills

  map.namespace :admin do |admin|
    admin.resources :members
    admin.resources :senators
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end