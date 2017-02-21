class Indicator::Measurement
  include Mongoid::Document

  before_create :init

  embedded_in :indicator, class_name: 'Indicator'
  embeds_one :log_book, class_name: 'Log::Book'

  field :m_on, as: :measured_on, type: Date

  field :val, as: :value, type: Float
  field :thr, as: :threshold, type: Float

  def init
    log_book = Log::Book.new
  end
end
