ActionController::Routing::Routes.draw do |map|

  map.about '/about', :controller => 'application', :action => 'about'
  map.contact '/contact', :controller => 'application', :action => 'contact'

  map.root :controller => 'application', :action => 'show'

  map.resources :members
  map.resources :hansards
  map.resources :votes

  map.namespace :admin do |admin|
    admin.resources :members
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end