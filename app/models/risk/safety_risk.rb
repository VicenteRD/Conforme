class Risk::SafetyRisk < Risk
  include Mongoid::Document

  validates_presence_of :position_id

  embeds_many :measurements, class_name: 'RiskMeasurement::SafetyMeasurement'

  field :a_id, as: :area_id, type: BSON::ObjectId    # => Position
  field :proc_id, as: :process_id, type: BSON::ObjectId # => BusinessProcess
  field :act, as: :activity, type: String

  field :pos_id, as: :position_id, type: BSON::ObjectId # => Position
  field :cond, as: :condition, type: Integer
  field :ag, as: :agent, type: String
  field :cons, as: :consequence, type: String

  field :name, type: String

  def permitted_fields
    super + [
        :area_id,
        :process_id,
        :activity,
        :name,
        :position_id,
        :condition,
        :agent,
        :consequence
    ]
  end

  def new_measurement(values)
    measurement = self.measurements.create(values)
    super(measurement.significant)

    measurement
  end
end
