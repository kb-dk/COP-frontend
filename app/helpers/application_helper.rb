module ApplicationHelper

  # Helper to show the name of the edition in facets
  def show_edition_name name
    # Find the document with the specific id
    doc = Finder.get_doc_by_id(name)
    doc.first['name_ssi'] unless doc.first['name_ssi'].blank?
  end

  # Helper to show the name of the category in facets
  def show_category_name name
    # Find the document with the specific id
    doc = Finder.get_doc_by_id(name)
    doc.first['node_tdsim'].first unless doc.first['node_tdsim'].blank?
  end

end
