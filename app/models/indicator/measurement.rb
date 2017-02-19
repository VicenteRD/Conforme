class Indicator::Measurement
  include Mongoid::Document

  embedded_in :indicator, class_name: 'Indicator'

  field :m_on, as: :measured_on, type: Date

  field :val, as: :value, type: Float
  field :thr, as: :threshold, type: Float
end
