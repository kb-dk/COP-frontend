module Cop
  module BlacklightUrlHelper
    include Blacklight::UrlHelperBehavior
    def url_for_document doc, options = {}
      "#{doc[:id]}/#{params[:locale]}/" unless doc.nil?
    end

    ##
    # Get the path to the search action with any parameters (e.g. view type)
    # that should be persisted across search sessions.
    def start_over_path query_params = params
      "/editions/any/2009/jul/editions/#{get_lang(params)}/"
    end

    # Create a link back to the index screen, keeping the user's facet, query and paging choices intact by using session.
    # @example
    #   link_back_to_catalog(label: 'Back to Search')
    #   link_back_to_catalog(label: 'Back to Search', route_set: my_engine)
    def link_back_to_catalog(opts={:label=>nil})
      scope = opts.delete(:route_set) || self
      query_params = current_search_session.try(:query_params) || ActionController::Parameters.new

      if search_session['counter']
        per_page = (search_session['per_page'] || default_per_page).to_i
        counter = search_session['counter'].to_i

        query_params[:per_page] = per_page unless search_session['per_page'].to_i == default_per_page
        query_params[:page] = ((counter - 1)/ per_page) + 1
      end

      link_url = if query_params.empty?
                   search_action_path(only_path: true)
                 elsif !current_search_session.query_params['subj_id']
                   "/editions/any/2009/jul/editions/#{get_lang(params)}?"+scope.url_for(query_params).partition('?').last
                 else
                   scope.url_for(query_params)
                 end
      label = opts.delete(:label)

      if link_url =~ /bookmarks/
        label ||= t('blacklight.back_to_bookmarks')
      end

      label ||= t('blacklight.back_to_search')

      link_to label, link_url, opts
    end

  end
end
