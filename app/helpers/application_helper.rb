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
    # Check if there in an english version for the name
    if get_lang(params).eql? 'en' and !doc['node_tesim'].nil?
      doc['node_tesim'].first
    else
      doc['node_tdsim'].first
    end
  end

  # Helper to return an array with all the subcategories for a facet in this format
  # [{"uri" =>"...", "id"=>"...", "node"=>"..."}, ...]
  def find_subcategories subject_id
    content = []
    docs = Finder.get_subcats_by_id subject_id
    docs.each do |doc|
      content << {
        "uri" =>"#{doc['id']}/#{get_lang(params)}/",
        "id"=>doc['id'], 
        "node"=>show_category_name(doc['id']),
        "key"=>show_category_name(doc['id']).strip.downcase
      }
    end
    return content
  end

  # Get the language parameter from the URL
  def get_lang params
    params['locale'].blank? ? lang = "da" : lang = params['locale']
    return lang
  end

  # Helper to get the breadcrumb for a category
  def get_breadcrumb_path cat_id
    # Find the document with the specific id
    doc = Finder.get_doc_by_id(cat_id)
    # Get the array and revert the order
    return doc['bread_crumb_ssim'].reverse unless doc['bread_crumb_ssim'].nil?
  end

  def show_scaled_image(doc, opts)
    uri = doc['thumbnail_url_ssm'].first
    if uri[/ull\/ful/]
      uri = uri.gsub(/full\/full/,'full/!225,')
    end
    img_tag = image_tag(URI(uri))
    return img_tag
  end

  def show_pdf_link doc
    # Get hold of the mods record from the solr doc and transform it in relation to the medium
    mods = doc['processed_mods_ts']
    mods_dom = Nokogiri::XML(mods) do |config|
      config.strict
    end
    md="http://www.loc.gov/mods/v3" 
    mods_dom.xpath("//md:mods/md:identifier[@displayLabel='pdf' and @type='uri']/text()",'md' => md).to_s
  end

  def show_mods_record args
    # Get hold of the mods record from the solr doc and transform it in relation to the medium
    mods = args[:document]['processed_mods_ts']
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

  def get_subject_id
   # if current_searcn_session
      query_params = current_search_session.try(:query_params) || ActionController::Parameters.new
      query_params[:subj_id]
    #end
  end


  # Default route to the search action (used e.g. in global partials). Override this method
  # in a controller or in your ApplicationController to introduce custom logic for choosing
  # which action the search form should use
  def search_action_url_local options = {}
    # Rails 4.2 deprecated url helpers accepting string keys for 'controller' or 'action'
    #search_catalog_url(options.except(:controller, :action))
    sub_id =  get_subject_id
    if params[:subj_id]
      "/#{params[:medium]}/#{params[:collection]}/#{params[:year]}/#{params[:month]}/#{params[:edition]}/subject#{params[:subj_id]}/#{params[:locale]}/"
    elsif !sub_id
      lang = params[:locale]? params[:locale]:"da"
      "/editions/any/2009/jul/editions/#{lang}/"
    else
      "/#{params[:medium]}/#{params[:collection]}/#{params[:year]}/#{params[:month]}/#{params[:edition]}/subject#{sub_id}/#{params[:locale]}/"
    end
  end


end
