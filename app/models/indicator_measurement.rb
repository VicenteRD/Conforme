class IndicatorMeasurement
  include Mongoid::Document

  include Describable
  include Referable

  validates_presence_of :measured_at, :value, :threshold

  before_create do
    self.log_book ||= Log::Book.new
  end

  embedded_in :indicator, class_name: 'Indicator'
  embeds_one :log_book, class_name: 'Log::Book'

  field :sig, as: :significant, type: Integer, default: -1

  field :m_at, as: :measured_at, type: DateTime

  field :val, as: :value, type: Float
  field :thr, as: :threshold, type: Float

  def self.display_name
    'Mediciones de Indicadores'
  end

  def display_name
    "Medición para \"#{indicator.display_name}\""
  end

  def self.base_info
    { klass: Indicator, embeds_list: 'measurements' }
  end
end
