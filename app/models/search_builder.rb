# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  self.default_processor_chain += [:add_edition,:add_subject]

  def add_edition(solr_parameters)
    if blacklight_params[:edition].present? && !blacklight_params[:subj_id].present?
      solr_parameters[:fq] << "cobject_edition_ssi:\"/#{blacklight_params[:medium]}/#{blacklight_params[:collection]}/#{blacklight_params[:year]}/#{blacklight_params[:month]}/#{blacklight_params[:edition]}\""
    end
  end

  def add_subject(solr_parameters)
    if blacklight_params[:subj_id].present?
      solr_parameters[:fq] << "subject_topic_id_ssim:\"/#{blacklight_params[:medium]}/#{blacklight_params[:collection]}/#{blacklight_params[:year]}/#{blacklight_params[:month]}/#{blacklight_params[:edition]}/subject#{blacklight_params[:subj_id]}\""
    end
  end

  ##
  # @example Adding a new step to the processor chain
  #   self.default_processor_chain += [:add_custom_data_to_query]
  #
  #   def add_custom_data_to_query(solr_parameters)
  #     solr_parameters[:custom] = blacklight_params[:user_value]
  #   end
end
