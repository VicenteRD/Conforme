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

  field :p_id, as: :parent_id, type: BSON::ObjectId # => Position
  field :c_ids, as: :children_ids, type: Array, default: [] # BSON::ObjectId => Position

  field :name, type: String

  field :area, type: Boolean

  # The functions this role performs.
  field :functions, type: String

  field :comp, as: :competencies, type: Array
  field :perf, as: :expected_performance, type: Array

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
end
