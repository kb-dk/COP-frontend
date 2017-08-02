# frozen_string_literal: true
class CatalogController < ApplicationController

  include Blacklight::Catalog

# Don't know what track does. Don't like what I don't understand
  before_action :set_id, only: [:show,:track]

  configure_blacklight do |config|
    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm

    config.show.partials.insert(1, :openseadragon)
    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
        rows: 10,
        # Exclude the luftfoto images from everywhere
        :fq => ['-cobject_edition_ssi:"/images/luftfo/2011/maj/luftfoto"', '-medium_ssi:categories','-medium_ssi:editions']
    }

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    config.per_page = [30,50,100]
    config.default_per_page = 30

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  qt: 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # fl: '*',
    #  # rows: 1,
    #  # q: '{!term f=id v=$id}'
    #}

    # solr field configuration for search results/index views
    config.index.title_field = 'cobject_title_ssi'
    config.index.display_type_field = 'format'
    config.index.thumbnail_method =  :show_scaled_image

    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)

    # I put the limit at 300000 here, to get all the facets to iterate through in the _facet_category.html.erb so we can
    # calculate the hits. SO FAR we have ~30000 subjects in solr (search for: parent_ssi:[* TO *])
    #config.add_facet_field 'contributor_tsim', label: 'Contributor', limit: 20

    #config.add_facet_field 'example_query_facet_field', label: 'Publish Date', :query => {
    #   :years_5 => { label: 'within 5 Years', fq: "pub_date:[#{Time.zone.now.year - 5 } TO *]" },
    #   :years_10 => { label: 'within 10 Years', fq: "pub_date:[#{Time.zone.now.year - 10 } TO *]" },
    #   :years_25 => { label: 'within 25 Years', fq: "pub_date:[#{Time.zone.now.year - 25 } TO *]" }
    #}


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    #config.add_index_field 'cobject_title_ssi'
    config.add_index_field 'creator_tsim'
    config.add_index_field 'description_tsim'
    config.add_index_field 'pub_dat_tsi'


    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'mods_ts', label: 'mods',  helper_method: :show_mods_record

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', label: 'Fritekst' do |field|
      # Free text search in these fields: title, creator, description
      field.solr_local_parameters = {
          :qf => 'cobject_title_ssi^100 full_title_tsi^90 creator_tsim^80 description_tsim^50 pub_dat_tsi^40 readable_dat_string_tsim^40 type_tdsim^30 dc_type_ssim^30 subject_tdsim^30 coverage_tdsim^30 local_id_ssi^30 shelf_mark_tdsim^20 subject_topic_facet_tdsim^20 subject_topic_facet_tesim^20 processed_mods_ts^10'
      }
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field 'title', label: 'Titel' do |field|

      field.solr_local_parameters = {
          qf: 'full_title_tsi',
          pf: 'full_title_tsi'
      }
    end

    config.add_search_field 'creator', label: 'Ophav' do |field|

      field.solr_local_parameters = {
          qf: 'creator_nasim',
          pf: 'creator_nasim'
      }
    end

    config.add_search_field 'person', label: 'Person' do |field|

      field.solr_local_parameters = {
          qf: 'cobject_person_tsim',
          pf: 'cobject_person_tsim'
      }
    end

    config.add_search_field 'location', label: 'Lokalitet' do |field|

      field.solr_local_parameters = {
          qf: 'cobject_location_tsim',
          pf: 'cobject_location_tsim'
      }
    end

    config.add_search_field('editions') do |field|
      field.include_in_simple_select = false
      field.solr_parameters = {
          :fq => ['medium_ssi:editions']
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc', label: '' #search after relevance
    config.add_sort_field 'cobject_title_ssi asc, score desc', label: I18n.t('blacklight.search.sort.title')
    config.add_sort_field 'creator_ssi asc, score desc', label: I18n.t('blacklight.search.sort.author')
    config.add_sort_field 'cobject_not_before_dtsi asc', label: I18n.t('blacklight.search.sort.not_before')
    config.add_sort_field 'cobject_not_after_dtsi desc', label: I18n.t('blacklight.search.sort.not_after')


    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'

    # Remove all actions from the navbar
    config.navbar.partials = {}
    # The individual actions can be brought back by uncommenting the lines below
    #config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    #config.add_nav_action(:saved_searches, partial: 'blacklight/nav/saved_searches', if: :render_saved_searches?)
    #config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')
    # And we can add our own custom actions
    config.add_nav_action(:language, partial: 'blacklight/nav/language')
   # config.add_nav_action(:copinfo, partial: 'blacklight/nav/copinfo')
  end

  #Disable login -- remove this function to get login back
  def has_user_authentication_provider?
    false
  end

  private

  def set_id
    params[:locale] = "da" unless params[:locale].present?
    params[:id] = "/#{params[:medium]}/#{params[:collection]}/#{params[:year]}/#{params[:month]}/#{params[:edition]}/object#{params[:obj_id]}" if params[:medium].present? and params[:obj_id].present?
  end

  def fetch_editions
    search_results({search_field: 'editions', rows: 100})
  end
  helper_method :fetch_editions

  def get_edition_image_url(editionId)
    res,docs = search_results({f:{cobject_edition_ssi: [editionId]},per_page: 1})
    url = ""
    if docs.size > 0
      url = docs.first['thumbnail_url_ssm'].first
    end
    url
  end

  helper_method :get_edition_image_url

# Configuration for autocomplete suggestor
  config.autocomplete_enabled = true
  config.autocomplete_path = 'suggest'

end
