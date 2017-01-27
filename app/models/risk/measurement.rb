class Risk::Measurement
  include Mongoid::Document

  before_save :calculate_magnitude

  embedded_in :risk

  field :m_at, as: :measured_at, type: DateTime

  field :cmts, as: :comments, type: String

  field :pbb, as: :probability, type: Integer
  field :idx, as: :index, type: Integer
  field :mag, as: :magnitude, type: Integer

  def calculate_magnitude
    self.magnitude = self.index * self.probability
  end
end
