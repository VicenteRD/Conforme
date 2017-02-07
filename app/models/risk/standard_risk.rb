class Risk::StandardRisk
  include Mongoid::Document

  validates_presence_of :standard_id

  embeds_many :measurements, class_name: 'RiskMeasurement::StandardMeasurement'

  field :std_id, as: :standard_id, type: BSON::ObjectId
  field :art, as: :article, type: String

  field :req, as: :requirement, type: String
end
