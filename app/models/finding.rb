class Finding
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  include EnumerableDocument
  include Describable
  include Referable

  embeds_one :origin, class_name: 'FindingOrigin'

  field :task_ids, as: :immediate_action_task_ids, type: Array

  field :corr_act_id, as: :corrective_action_id, type: Array

  field :finding_type, type: Integer

  field :rejected, type: Bool

  field :f_id, as: :finder_id, type: BSON::ObjectId
  field :a_id, as: :area_id, type: BSON::ObjectId

  field :f_at, as: :found_at, type: DateTime
  field :loc, as: :location, type: String

  def step_status

  end

  def self.all_types(include_ok = false)
    types = {}

    types[-1] = 'OK' if include_ok

    types
  end
end
