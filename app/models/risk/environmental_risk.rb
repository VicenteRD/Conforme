class Risk::EnvironmentalRisk < Risk
  include Mongoid::Document

  validates_presence_of :area_id, :process_id, :activity,
                        :aspect, :name,
                        :occurrence_time, :operational_situation,
                        :positive, :direct

  embeds_many :measurements, class_name: 'RiskMeasurement::EnvironmentalMeasurement'

  field :a_id, as: :area_id, type: BSON::ObjectId    # => Position
  field :proc_id, as: :process_id, type: BSON::ObjectId # => BusinessProcess
  field :act, as: :activity, type: String

  field :asp, as: :aspect, type: String
  field :name, type: String

  field :occ_t, as: :occurrence_time, type: Integer # -1, 0 or 1 (Past, present, future)
  field :op_s , as: :operational_situation, type: Integer # In settings, store possible values as keys of a hash with its literal names as values

  field :pos, as: :positive, type: Boolean
  field :dir, as: :direct, type: Boolean

  def self.permitted_fields
    super + [
        :area_id,
        :process_id,
        :activity,

        :aspect,
        :name,

        :occurrence_time,
        :operational_situation,
        :positive,
        :direct
    ]
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
    'Riesgos Ambientales'
  end
end
