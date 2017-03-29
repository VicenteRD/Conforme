class RiskMeasurement
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book = Log::Book.new unless self.log_book
  end

  around_save :calculate_magnitude

  validates_presence_of :measured_at

  field :m_at, as: :measured_at, type: DateTime

  field :sig, as: :significant, type: Integer, default: -1

  field :thr, as: :threshold, type: Float

  field :mag, as: :magnitude, type: Float

  def self.permitted_fields
    [:measured_at, :comments]
  end

  def update_and_log(user_id, fields, log_entry_body)
    update!(fields)

    log_book.new_entry(user_id, 'Editado', log_entry_body)
  end

  def calculate_magnitude
    if !(defined?(self.magnitude)) || self.magnitude.nil?
      self.magnitude = 0
    end

    settings = Settings::RiskSettings.first

    if settings&.operational_threshold && settings.margin

      self.threshold = settings.operational_threshold

      if self.magnitude >= (self.threshold * (1.0 + settings.margin))
        self.significant = 2
      elsif self.magnitude >= self.threshold
        self.significant = 1
      else
        self.significant = 0
      end
    end

    yield

  end

end
