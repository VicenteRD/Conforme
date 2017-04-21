class Indicator
  include Mongoid::Document

  include EnumerableDocument

  include Referable
  include Describable

  validates_presence_of :objective_id, :responsible_id,
                        :name, :description,
                        :method, :threshold, :margin, :criterion, :unit,
                        :measurement_frequency

  embeds_one :log_book, class_name: 'Log::Book'

  before_create do
    self.log_book ||= Log::Book.new
  end

  embeds_many :measurements, class_name: 'IndicatorMeasurement'

  belongs_to :objective

  field :sig, as: :significant, type: Integer, default: -1

  field :r_id, as: :responsible_id, type: BSON::ObjectId # => Person::User

  field :name, type: String
  field :desc, as: :description, type: String
  field :method, type: String # TODO Rename due conflict

  field :thr, as: :threshold, type: Float
  field :mrg, as: :margin, type: Float
  field :crt, as: :criterion, type: String
  field :unit, type: String

  field :freq, as: :measurement_frequency, type: Integer

  def new_measurement(data)
    measurement = measurements.create!(data)

    significant = calculate_significance(
      measurement.value,
      measurement.threshold,
      margin
    )

    measurement.significant = significant
    self.significant = significant
    save!

    measurement
  end

  def get_measurement(id)
    measurements.find(id)
  end

  def self.get_all_criteria
    %w(≤ < = > ≥)
  end

  def self.expand_criterion(criterion)
    return criterion unless criterion.in? %w(≤ = ≥)

    { '≤' => '<=', '=' => '==', '≥' => '>=' }[criterion]
  end

  def calculate_significance(value, threshold, margin)
    criterion = Indicator.expand_criterion(self.criterion)

    delta = if criterion.in?(%w(< >)) && value == threshold
              nil
            else
              value.send(criterion.to_sym, threshold) ? 0 : (value - threshold).abs.round(2)
            end


    return 1 if delta.nil?
    return 0 if delta.zero?

    delta > (threshold * margin).round(2) ? 2 : 1
  end

  def self.display_name
    'Indicadores'
  end

  def display_name
    name
  end

end
