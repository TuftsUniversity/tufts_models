ALLOW_DOTS ||= /[a-zA-Z0-9_.:]+/

Tufts::Application.routes.draw do
  root :to => "catalog#index"

  resources :catalog, :only => [:show, :update], :constraints => { :id => ALLOW_DOTS, :format => false }
  Blacklight::Routes.new(self, {}).catalog
  # This is from Blacklight::Routes#solr_document, but with the constraints added which allows periods in the id
  resources :solr_document,  :path => 'catalog', :controller => 'catalog', :only => [:show, :update] 
  resources :downloads, :only =>[:show], :constraints => { :id => ALLOW_DOTS }

  
  HydraHead.add_routes(self)
  mount FcrepoAdmin::Engine => '/admin', :as=> 'fcrepo_admin'
  mount HydraEditor::Engine => '/'
  post 'records/:id/publish', to: 'records#publish', as: 'publish_record', constraints: { id: ALLOW_DOTS }

  resources :records, only: [], constraints: { id: ALLOW_DOTS } do
    resources :attachments, constraints: { id: ALLOW_DOTS }
  end
    

  devise_for :users
  mount Hydra::RoleManagement::Engine => '/'
end
