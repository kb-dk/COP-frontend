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
  end
end
