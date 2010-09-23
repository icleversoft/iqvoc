class CompoundForm::Content::Base < ActiveRecord::Base
  
  set_table_name 'compound_form_contents'
  
  belongs_to :compound_form, :class_name => 'CompoundForm::Base', :foreign_key => 'compound_form_id'
  belongs_to :label,         :class_name => 'Label::Base', :foreign_key => 'label_id'

  def temporary_name
    "CompoundFromContent"
  end
  
  # FIXME: hardcoded table names
  scope :published, lambda { |compound_form_id| {
    :joins      => :label,
    :conditions => ["(compound_form_contents.compound_form_id = #{compound_form_id} 
                     AND labels.published_at IS NOT NULL) 
                     OR (compound_form_contents.compound_form_id = #{compound_form_id} 
                     AND labels.rev = 1 AND labels.published_at IS NULL)"] }
  }

  scope :published_without_initial_versions, lambda { |compound_form_id| {
    :joins      => :label,
    :conditions => ["(compound_form_contents.compound_form_id = #{compound_form_id} 
                    AND labels.published_at IS NOT NULL)"] }
  }

  scope :target_in_edit_mode, lambda {|domain_id| { 
    :joins      => [:compound_form, :label],
    :include    => :label,
    :conditions => "(compound_forms.domain_id = #{domain_id}) AND (labels.locked_by IS NOT NULL)" }
  }
  
end