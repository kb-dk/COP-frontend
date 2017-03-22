Rails.application.routes.draw do
  
  mount Blacklight::Engine => '/'
  root to: "catalog#index"
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  get 'editions/any/2009/jul/editions/:locale',   to: 'catalog#index',  constraint: {locale:/en|da/ }
  get ':medium/:collection/:year/:month/:edition/:locale',   to: 'catalog#index',  constraint: {locale:/en|da/ }
  get ':medium/:collection/:year/:month/:edition/object:obj_id/:locale',   to: 'catalog#show',  constraint: {obj_id:  /\d+/, locale:/en|da/ }
  get ':medium/:collection/:year/:month/:edition/subject:subj_id/:locale', to: 'catalog#index', constraint: {subj_id: /\d+/, locale:/en|da/ }
  get ':medium/:collection/:year/:month/:edition/:cobjectId/:locale/track',to: 'catalog#track'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end



#  get ':medium/:collection/:year/:month/:edition/:cobjectId', to: 'catalog#show', constraint: {medium: /[pamphlets|letters|maps|books|manus]/ }
#  
#  get ':medium/:collection/:year/:month/:edition/subject:subj_id', to: 'catalog#index', constraint: {subj_id: /\d+/ }



# 
#  


#  get ':medium/:collection/:year/:month/:edition/subject:subj_id/:locale/track', to: 'catalog#track', constraint: {subj_id: /\d+/, locale:/(en)|(da)/ }
#  get ':medium/:collection/:year/:month/:edition/subject:subj_id', to: 'catalog#index', constraint: {subj_id: /\d+/ }
#  get ':medium/:collection/:year/:month/:edition/object:obj_id/:locale/track',   to: 'catalog#track', constraint: {obj_id: /\d+/, locale:/(en)|(da)/ }
#  get 'editions/any/2009/jul/editions/:locale', to: 'catalog#index', constraint: {locale:/(en)|(da)/ }
#  get 'editions/any/2009/jul/editions/:locale/track', to: 'catalog#track', constraint: {locale:/(en)|(da)/ }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

