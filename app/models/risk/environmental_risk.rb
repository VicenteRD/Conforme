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

  field :reg_id, as: :regulation_id, type: BSON::ObjectId # => LawRisk

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

        :regulation_id,
        :occurrence_time,
        :operational_situation,
        :positive,
        :direct
    ]
  end

  def new_measurement(values)
    measurement = self.measurements.create!(values)

    super(measurement.significant)

    measurement
  end

  def get_compliance
    if self.regulation_id.nil?
      return nil
    end

    regulation = Risk::LawRisk.find(self.regulation_id)

    regulation.nil? ? nil : regulation.get_compliance
  end

end
