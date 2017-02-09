class RiskMeasurement
  include Mongoid::Document

  embeds_one :log_book, class_name: 'Log::Book'

  before_save :calculate_magnitude

  validates_presence_of :measured_at

  field :m_at, as: :measured_at, type: DateTime

  field :sig, as: :significant, type: Integer

  field :thr, as: :threshold, type: Float

  field :cmts, as: :comments, type: String

  field :mag, as: :magnitude, type: Float

  def calculate_magnitude
    self.magnitude
  end
end
