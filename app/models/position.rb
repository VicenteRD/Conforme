class Position
  include Mongoid::Document

  has_and_belongs_to_many :users, class_name: 'Person::User'

  field :p_id, as: :parent_id, type: BSON::ObjectId # => Position
  field :c_ids, as: :children_ids, type: Array # BSON::ObjectId => Position

  field :name, type: String

  field :area, type: Boolean

  # The functions this role performs.
  field :functions, type: String
  field :competencies, type: String

  def is_area?
    if self.area
      return self
    end

    p_position = Position.find(self.parent_id)
    until p_position.is_area?
      if p_position.parent_id != nil
        p_position = Position.find(p_position.parent_id)
      else
        return p_position
      end
    end

    p_position
  end
end
