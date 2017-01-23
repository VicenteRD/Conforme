class Indicator
  include Mongoid::Document

  has_many :tasks, class_name: 'Indicator::Task'

  belongs_to :objective

  field :responsible_id

  field :name, type: String
  field :description, type: String
  field :method, type: String

  field :ideal_value, type: Float
  field :acc_delta, type: Float
  field :criterion, type: String

  field :measurement, type: Float
  field :unit, type: String

  field :frequency, type: String

  field :lm_at, as: :last_measured_at, type: DateTime
  field :nm_at, as: :next_measurement_at, type: DateTime
end
