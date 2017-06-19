# This class should be called statically to execute common Solr queries
class Finder

  def self.get_solr
     return RSolr.connect :url => "#{Rails.application.config_for(:blacklight)["url"]}"
  end

  # Function to return the solr document by id
  def self.get_doc_by_id(id)
    query = "id:#{id}"
    response = get_solr.get 'select', :params => {:q => query}
    # Return the first document
    return response['response']['docs'].first
  end

  # Function to return the solr documents that are subcategories, searching by id
  def self.get_subcats_by_id id
    query = "parent_ssi:#{id}" # Set the query
    response = get_solr.get 'select', :params => {:q => query, :rows => 1000} # Return all the subcategories (by default the rows: 10)
    return response['response']['docs'].delete_if { |x| x["id"]=="/images/luftfo/2011/maj/luftfoto/subject203" } # Return all the documents except luftfoto
  end

end
