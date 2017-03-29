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

  def new_measurement(user_id, values, log_body)
    measurement = self.measurements.create!(values)

    super(measurement.significant)

    measurement.log_book.new_entry(user_id, 'Creado', log_body)
  end
end
