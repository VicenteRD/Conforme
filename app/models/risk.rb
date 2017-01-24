class Risk
  include Mongoid::Document

  has_many :':tasks', class_name: 'Risk::Risk'

  field :name, type: String
  field :measurement, type: Float

  field :m_at, as: :measured_at, type: DateTime
end
