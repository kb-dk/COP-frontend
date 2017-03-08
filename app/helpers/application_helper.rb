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

  def show_mods_record args
    # Get hold of the mods record from the solr doc and transform it in relation to the medium
    mods = args[:document]['mods_ts']
    mods_dom = Nokogiri::XML(mods)
    xslt_file           = Rails.root.join('config', 'mods_views', 'mods_renderer_images.xsl')
    lang_selector_sheet = Rails.root.join('config', 'mods_views', 'choose_lang.xsl')
    stylesheet          = Nokogiri::XSLT(File.open(xslt_file))
    lang_selector       = Nokogiri::XSLT(File.open(lang_selector_sheet))
    transformed_doc     = lang_selector.transform(stylesheet.transform(mods_dom, {}),["lang","'da'"])
    transformed_doc.to_s.html_safe
  end

end
