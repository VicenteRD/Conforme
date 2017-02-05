class Risk::Measurement
  include Mongoid::Document

  before_save :calculate_magnitude

  field :m_at, as: :measured_at, type: DateTime

  field :sig, as: :significant, type: Integer

  field :pbb, as: :probability, type: Float
  field :imp, as: :impact, type: Integer

  field :mag, as: :magnitude, type: Float

  field :thr, as: :threshold, type: Float

  field :cmts, as: :comments, type: String

  def calculate_magnitude
    self.magnitude = -1
  end
end
