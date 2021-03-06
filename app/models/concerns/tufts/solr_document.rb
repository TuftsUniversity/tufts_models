# -*- encoding : utf-8 -*-
module Tufts::SolrDocument

  def download
    if self['download_ssi'] == 'no-link'
      'Do not show a download link to any users'
    else
      'Show a download link to all users'
    end
  end

  def visibility
   # if document.visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    if self['visibility_ssi'] == 'authenticated'
      'Tufts University'
    else
      'Open'
    end
  end

  def reviewed?
    Array(self['qrStatus_tesim']).include?(Reviewable.batch_review_text)
  end

  def reviewable?
    !template? && !reviewed? && in_a_batch?
  end

  def in_a_batch?
    !Array(self['batch_id_ssim']).empty?
  end

  def published?
    self[Solrizer.solr_name("edited_at", :stored_sortable, type: :date)] ==
      self[Solrizer.solr_name("published_at", :stored_sortable, type: :date)]
  end

  def publishable?
    !published? && !template?
  end

  def template?
    self['active_fedora_model_ssi'] == 'TuftsTemplate'
  end

  def image?
    self['active_fedora_model_ssi'] == 'TuftsImage'
  end

  def collection?
    self['active_fedora_model_ssi'] == 'CuratedCollection'
  end

  def preview_fedora_path
    Settings.preview_fedora_url + "/objects/#{id}"
  end

  def to_model
    if collection?
      m = ActiveFedora::Base.load_instance_from_solr(id, self)
      m.class == ActiveFedora::Base ? self : m
    else
      self
    end
  end

end
