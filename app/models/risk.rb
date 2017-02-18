require 'concerns/enumerable_document'

class Risk
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short

  include EnumerableDocument

  include Associable

  validates_presence_of :responsible_id, :measurement_frequency

  before_create :init

  embeds_one :log_book, class_name: 'Log::Book'

  field :fq, as: :measurement_frequency, type: Integer

  field :sig, as: :significant, type: Integer

  field :res_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  field :cmts, as: :comments, type: String


  def init
    self.significant = -1
    self.log_book = Log::Book.new
  end

  def log_creation(author_id, body = '')
    self.log_book.new_entry(author_id, 'Creado', body)

    self
  end

  def new_measurement(significant)
    update_significant(significant)
  end

  def update_significant(significant)
    self.significant = significant
    self.save!
  end

  def self.permitted_fields
    [:measurement_frequency, :responsible_id, :comments]
  end

  def self.get_risk_types
    TYPES_MAP
  end

  TYPES_MAP = {
      :ambiente => {
          en: 'environmental',
          klass: Risk::EnvironmentalRisk,
          measurement_klass: RiskMeasurement::EnvironmentalMeasurement
      },
      :operacional => {
          en: 'operational',
          klass: Risk::OperationalRisk,
          measurement_klass: RiskMeasurement::OperationalMeasurement
      },
      :seguridad   => {
          en: 'safety',
          klass: Risk::SafetyRisk,
          measurement_klass: RiskMeasurement::SafetyMeasurement
      },
      :ley         => {
          en: 'laws',
          klass: Risk::LawRisk,
          measurement_klass: RiskMeasurement::LawMeasurement
      },
      :norma       => {
          en: 'standards',
          klass: Risk::StandardRisk,
          measurement_klass: RiskMeasurement::StandardMeasurement
      }
  }
end
