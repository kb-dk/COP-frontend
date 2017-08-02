module Cop
  module RenderConstraintsHelper
    include Blacklight::RenderConstraintsHelperBehavior

    ##
    # DGJ: we override this function to delete the page param from the remove constraint url
    # this could be a bug in blacklight
    def remove_constraint_url(localized_params)
      scope = localized_params.delete(:route_set) || self

      unless localized_params.is_a? ActionController::Parameters
        localized_params = ActionController::Parameters.new(localized_params)
      end

      options = localized_params.merge(q: nil, action: 'index')
      options.delete(:page) # we do not want to keep the page param, since removing a constrint is a new search and should start on the first page
      options.permit!
      scope.url_for(options)
    end
  end
end