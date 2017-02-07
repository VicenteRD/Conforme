class Risk::LawRisk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'RiskMeasurement::LawMeasurement'

  validates_presence_of :law_id

  field :law_id, type: BSON::ObjectId
  field :art, as: :article, type: String

  field :req, as: :requirement, type: String
end
