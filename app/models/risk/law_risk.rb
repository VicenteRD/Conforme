class Risk::LawRisk < Risk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'RiskMeasurement::LawMeasurement'

  validates_presence_of :law_id

  field :law_id, type: BSON::ObjectId
  field :art_id, as: :article_id, type: BSON::ObjectId

  def permitted_fields
    super + [:law_id, :article_id]
  end

  def new_measurement(values)
    measurement = self.measurements.create(values)
    super(measurement.significant)

    measurement
  end

  def get_law_name
    law = Law.find(self.law_id)

    law.name + ': ' + law.articles.find(self.article_id).name
  end

  def get_compliance
    if self.measurements != nil && self.measurements
      self.measurements.last.compliance
    else
      0
    end
  end
end
