module ApplicationHelper

  # Helper to show the name of the edition in facets
  def show_edition_name id
    # Find the document with the specific id
    doc = Finder.get_doc_by_id(id)
    doc['name_ssi'] unless doc['name_ssi'].blank?
  end

  # Helper to show the name of the category in facets
  def show_category_name id
    # Find the document with the specific id
    doc = Finder.get_doc_by_id(id)
    doc['node_tdsim'].first unless doc['node_tdsim'].blank?
  end

  # Helper to return an array with all the ids of the subcategories for a facet
  def find_subcategories subject_id
    ids = []
    docs = Finder.get_subcats_by_id subject_id
    docs.each do |doc|
      ids << doc['id']
    end
    # Returns an array with the subcategories' ids
    return ids
  end

  # Helper to find the top_category of an edition
  def get_top_category edition_id
    # Find the document with the specific id
    doc = Finder.get_doc_by_id(edition_id)
    doc['top_cat_ssi']
  end

end
