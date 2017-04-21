class Risk::OperationalRisk < Risk
  include Mongoid::Document

  validates_presence_of :area_id, :process_id, :activity, :name

  embeds_many :measurements, class_name: 'RiskMeasurement::OperationalMeasurement'

  field :a_id, as: :area_id, type: BSON::ObjectId    # => Position
  field :proc_id, as: :process_id, type: BSON::ObjectId # => BusinessProcess
  field :act, as: :activity, type: String

  field :name, type: String

  def self.permitted_fields
    super + [:area_id, :process_id, :activity, :name]
  end

  def new_measurement(values)
    measurement = measurements.create!(values)

    super(measurement.significant)

    measurement
  end

  def display_name
    name
  end

  def self.display_name
    'Riesgos Operacionales'
  end
end
