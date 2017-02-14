class Risk::StandardRisk < Risk
  include Mongoid::Document

  validates_presence_of :standard_id

  embeds_many :measurements, class_name: 'RiskMeasurement::StandardMeasurement'

  field :std_id, as: :standard_id, type: BSON::ObjectId
  field :art_id, as: :article_id, type: BSON::ObjectId

  def new_measurement(values)
    measurement = self.measurements.create(values)
    super(measurement.significant)

    measurement
  end
end
