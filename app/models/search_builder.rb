# frozen_string_literal: true
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  self.default_processor_chain += [:add_edition,:add_subject,:add_notAfter,:add_notBefore]

  def add_edition(solr_parameters)
    if blacklight_params[:edition].present? && !'editions'.eql?(blacklight_params[:medium]) && !blacklight_params[:subj_id].present?
      solr_parameters[:fq] << "cobject_edition_ssi:\"/#{blacklight_params[:medium]}/#{blacklight_params[:collection]}/#{blacklight_params[:year]}/#{blacklight_params[:month]}/#{blacklight_params[:edition]}\""
    end
  end

  def add_subject(solr_parameters)
    if blacklight_params[:subj_id].present? && !'editions'.eql?(blacklight_params[:medium])
    solr_parameters[:fq] << "subject_topic_id_ssim:\"/#{blacklight_params[:medium]}/#{blacklight_params[:collection]}/#{blacklight_params[:year]}/#{blacklight_params[:month]}/#{blacklight_params[:edition]}/subject#{blacklight_params[:subj_id]}\""
    end
  end

  def add_notBefore(solr_parameters)
    solr_date = get_solr_date(blacklight_params[:notBefore])
    unless solr_date.nil?
      solr_parameters[:fq] << "cobject_not_after_dtsi:["+solr_date+" TO *]"
    end
  end

  def add_notAfter(solr_parameters)
    solr_date = get_solr_date(blacklight_params[:notAfter])
    unless solr_date.nil?
      solr_parameters[:fq] << "cobject_not_before_dtsi:[* TO "+solr_date+"]"
    end
  end

  private

  def get_solr_date(date)
    begin
      if date.present?
        DateTime.parse(date).utc.iso8601
      else
        nil
      end
    rescue
      nil
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
