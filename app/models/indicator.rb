class Indicator
  include Mongoid::Document

  include Enumerable

  #has_many :tasks, class_name: 'Indicator::Task'

  embeds_many :measurements, class_name: 'Indicator::Measurement'

  belongs_to :objective

  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  field :name, type: String
  field :desc, as: :description, type: String
  field :method, type: String

  field :thr, as: :threshold, type: Float
  field :mrg, as: :margin, type: Float
  field :crt, as: :criterion, type: String
  field :unit, type: String

  field :freq, as: :measurement_frequency, type: String
end
