module Cop
  module BlacklightUrlHelper
    include Blacklight::UrlHelperBehavior
    def url_for_document doc, options = {}
      "#{doc[:id]}/#{params[:locale]}" unless doc.nil?
    end

    ## Overwriting this function to generate tracking urls that fit with our URL scheme
    # DGJ
    def session_tracking_path doc, opts = {}
      return if doc.nil?
      doc_path =  "#{doc[:id]}/#{params[:locale]}"
      opts[:per_page] = default_per_page unless opts[:per_page].present? # make sure that per_page has a value
      "#{doc_path}/track?#{opts.merge({redirect: CGI.escape(doc_path)}).to_query}"
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
      # NOT a great solution, FIX the bug: "Back to search" link does not work when you come from a search on all collections.
      # When there is no subj_id in the back_url, it means that there has been a search at the home screen. So I create 
      # the url as it is created in the other cases and I keep the parameters from the URL and replace its base with 
      # our "/editions/any/2009/jul/editions/"
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
