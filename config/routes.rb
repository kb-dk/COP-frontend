Rails.application.routes.draw do
  scope "(:locale)", :locale => /en|da/ do

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

  get ':medium/:collection/:year/:month/:edition/:cobjectId', to: 'catalog#show', constraint: {medium: /[pamphlets|letters|maps|books|manus]/ }
  get ':medium/:collection/:year/:month/:edition/:cobjectId/track', to: 'catalog#track'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
end
