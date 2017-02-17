class Risk::StandardRisk < Risk
  include Mongoid::Document

  validates_presence_of :standard_id

  embeds_many :measurements, class_name: 'RiskMeasurement::StandardMeasurement'

  field :a_id, as: :area_id, type: BSON::ObjectId    # => Position
  field :proc_id, as: :process_id, type: BSON::ObjectId # => BusinessProcess
  field :act, as: :activity, type: String

  field :std_id, as: :standard_id, type: BSON::ObjectId
  field :art_id, as: :article_id, type: BSON::ObjectId

  def permitted_fields
    super + [:law_id, :article_id]
  end

  def get_standard_name
    standard = ::Standard.find(self.standard_id)

    standard.name + ': ' + standard.articles.find(self.article_id).name
  end

  def new_measurement(values)
    measurement = self.measurements.create(values)
    super(measurement.significant)

    measurement
  end
end
