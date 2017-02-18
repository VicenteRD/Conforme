class RiskMeasurement
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  embeds_one :log_book, class_name: 'Log::Book'

  before_create :init

  around_save :calculate_magnitude

  validates_presence_of :measured_at

  field :m_at, as: :measured_at, type: Date # Fecha / TODO: need to change to 'on'

  field :sig, as: :significant, type: Integer # Significativo

  field :thr, as: :threshold, type: Float # Threshold / TODO - improve current system (ThrMeasurements)

  field :cmts, as: :comments, type: String # Comments

  field :mag, as: :magnitude, type: Float # Magnitud

  def self.permitted_fields
    [:measured_at, :comments]
  end

  def init
    self.significant = -1
    self.log_book = Log::Book.new
  end

  def calculate_magnitude
    if !(defined?(self.magnitude)) || self.magnitude.nil?
      self.magnitude = 0
    end

    settings = Settings::RiskSettings.first

    if settings && settings[:operational_threshold] && settings[:margin]

      self.threshold = settings[:operational_threshold]

      if self.magnitude >= (self.threshold * (1.0 + settings[:margin]))
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
