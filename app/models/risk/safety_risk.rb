class Risk::SafetyRisk < Risk
  include Mongoid::Document

  validates_presence_of :area_id, :process_id, :activity,
                        :position_id, :condition, :agent,
                        :consequence, :name

  embeds_many :measurements, class_name: 'RiskMeasurement::SafetyMeasurement'

  field :a_id, as: :area_id, type: BSON::ObjectId
  field :proc_id, as: :process_id, type: BSON::ObjectId
  field :act, as: :activity, type: String

  field :pos_id, as: :position_id, type: BSON::ObjectId
  field :cond, as: :condition, type: Integer
  field :ag, as: :agent, type: String
  field :cons, as: :consequence, type: String

  field :name, type: String

  def self.permitted_fields
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

  def new_measurement(user_id, values, log_body)
    measurement = self.measurements.create!(values)
    super(measurement.significant)

    measurement.log_book.new_entry(user_id, 'Creado', log_body)
  end
end
