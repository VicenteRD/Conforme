class Risk::OperationalRisk < Risk
  include Mongoid::Document

  embeds_many :measurements, class_name: 'RiskMeasurement::OperationalMeasurement'

  field :name, type: String

  def new_measurement(values)
    measurement = self.measurements.create(values)
    super(measurement.significant)

    measurement
  end
end
