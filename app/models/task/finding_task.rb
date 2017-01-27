class Task::FindingTask < Task
  include Mongoid::Document

  field :finding_id, type: BSON::ObjectId # => Finding

  field :f_type, type: String
end
