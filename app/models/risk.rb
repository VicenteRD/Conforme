class Risk
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include EnumerableDocument
  include Describable
  include Referable

  validates_presence_of :responsible_id, :measurement_frequency

  before_create do
    self.log_book = Log::Book.new unless self.log_book
  end

  embeds_one :log_book, class_name: 'Log::Book'

  field :fq, as: :measurement_frequency, type: Integer

  field :sig, as: :significant, type: Integer, default: -1

  field :res_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  def log_creation(author_id, body = '')
    log_book.new_entry(author_id, 'Creado', body)

    self
  end

  def new_measurement(significant)
    update_significant(significant)
  end

  def update_significant(significant)
    self.significant = significant
    save!
  end

  def get_measurement(id)
    measurements.find(id)
  end

  # -- Class methods

  def self.permitted_fields
    [:measurement_frequency, :responsible_id, :comments]
  end

  def self.settings
    Settings::RiskSettings.first
  end

  def self.risk_types
    TYPES_MAP
  end

  def self.measurement_class_for(klass)
    risk_types.dig(klass.to_sym, :measurement_klass)
  end

  TYPES_MAP = {
    ambiente: {
      en: 'environmental',
      klass: Risk::EnvironmentalRisk,
      measurement_klass: RiskMeasurement::EnvironmentalMeasurement
    },
    operacional: {
      en: 'operational',
      klass: Risk::OperationalRisk,
      measurement_klass: RiskMeasurement::OperationalMeasurement
    },
    seguridad: {
      en: 'safety',
      klass: Risk::SafetyRisk,
      measurement_klass: RiskMeasurement::SafetyMeasurement
    },
    ley: {
      en: 'laws',
      klass: Risk::RuleRisk,
      measurement_klass: RiskMeasurement::RuleMeasurement
    },
    norma: {
      en: 'standards',
      klass: Risk::RuleRisk,
      measurement_klass: RiskMeasurement::RuleMeasurement
    }
  }.freeze
end
