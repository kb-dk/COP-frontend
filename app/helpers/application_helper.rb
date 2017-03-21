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

  def show_mods_record args
    # Get hold of the mods record from the solr doc and transform it in relation to the medium
    mods = args[:document]['mods_ts']
    xslt_file = 'mods_renderer_' + params['medium'] + '.xsl'
    mods_dom = Nokogiri::XML(mods)
    xslt_file_path      = Rails.root.join('config', 'mods_views', xslt_file )
    lang_selector_sheet = Rails.root.join('config', 'mods_views', 'choose_lang.xsl')
    stylesheet          = Nokogiri::XSLT(File.open(xslt_file_path))
    lang_selector       = Nokogiri::XSLT(File.open(lang_selector_sheet))
    locale              = params['locale']
    transformed_doc     = lang_selector.transform(stylesheet.transform(mods_dom, {}),["lang","'" + locale + "'"])
    transformed_doc.to_s.html_safe
  end

end
