module Cop
  module BlacklightUrlHelper
    include Blacklight::UrlHelperBehavior
    def url_for_document doc, options = {}
      doc[:id] unless doc.nil?
    end
  end
end