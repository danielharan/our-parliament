ActionController::Routing::Routes.draw do |map|

  map.about '/about', :controller => 'application', :action => 'about'
  map.contact '/contact', :controller => 'application', :action => 'contact'

  map.root :controller => 'application', :action => 'show'

  map.resources :members, :member => {:votes => :get}
  map.resources :debates
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

#ActionController::Routing::Translator.translate_from_file('config','locales','routes.yml')