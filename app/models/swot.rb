class Swot
  include Mongoid::Document

  before_create do
    self.log_book ||= Log::Book.new
  end

  # embeds_many :swot_fields, class_name: 'Swot::Field'

  embeds_one :log_book, class_name: 'Log::Book'

  field :swot_type, type: Integer
  field :name, type: String
  field :strategy, type: String

  field :term, type: DateTime

  field :cmts, as: :comments, type: String

  def self.get_all_types
    { 0 => 'Fortaleza', 1 => 'Oportunidad', 2 => 'Debilidad', 3 => 'Amenaza' }
  end

end
