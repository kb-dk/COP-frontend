# This class should be called statically to execute common Solr queries
class Finder

  def self.get_solr
     return RSolr.connect :url => "#{Rails.application.config_for(:blacklight)["url"]}"
  end

  # Function to return the solr document by id
  def self.get_doc_by_id(id)
    query = "id:#{id}"
    response = get_solr.get 'select', :params => {:q => query}
    return response['response']['docs']
  end

end
