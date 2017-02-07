class Risk::EnvironmentalRisk < Risk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'RiskMeasurement::EnvironmentalMeasurement'

  field :asp, as: :aspect, type: String
  field :name, type: String

  field :reg_id, as: :regulation_id, type: BSON::ObjectId # => LawRisk

  field :occ_t, as: :occurrence_time, type: Integer # -1, 0 or 1 (Past, present, future)
  field :op_s , as: :operational_situation, type: Integer # In settings, store possible values as keys of a hash with its literal names as values

  field :pos, as: :positive, type: Boolean
  field :dir, as: :direct, type: Boolean
end
