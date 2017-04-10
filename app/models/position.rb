class Position
  include Mongoid::Document

  include EnumerableDocument
  include Describable
  include Referable

  embeds_one :log_book, class_name: 'Log::Book'
  before_create do
    self.log_book ||= Log::Book.new
  end

  has_and_belongs_to_many :users, class_name: 'Person::User'

  field :comp, as: :competency_ids, type: Array # BSON::ObjectId => Competency
  field :perf, as: :performance_ids, type: Array # BSON::ObjectId => Performance

  field :p_id, as: :parent_id, type: BSON::ObjectId # => Position
  field :c_ids, as: :children_ids, type: Array, default: [] # BSON::ObjectId => Position

  field :name, type: String

  field :area, type: Boolean

  # The functions this role performs.
  field :functions, type: String


  def get_area
    return self if area

    p_position = Position.find(self.parent_id)
    until p_position.area
      return p_position if p_position.parent_id.nil?

      p_position = Position.find(p_position.parent_id)
    end

    p_position
  end

  def add_child(id)
    children_ids << id if id
    save!
  end

  def qualifications(qualifications_type)
    if qualifications_type == 1
      competency_ids
    elsif qualifications_type == 2
      performance_ids
    end
  end

  def self.display_name
    'Posiciones'
  end

  def display_name
    name
  end
end
