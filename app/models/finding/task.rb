class Finding::Task < Task
  include Mongoid::Document

  belongs_to :finding

  field :f_type, type: String
end
