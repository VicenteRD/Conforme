class Position
  include Mongoid::Document

  ## Relations
  has_and_belongs_to_many :users, class_name: 'Person::User'
  # Creates a 'parent_position' and an array of 'child_positions'
  # to recreate the tree-like nature of business positions.
  recursively_embeds_many

  has_many :risks

  ## Other fields

  field :name, type: String

  field :area, type: Boolean

  # The functions this role performs.
  field :functions, type: String
  field :competencies, type: String

  def is_area?
    p_position = self.parent_position
    until p_position.is_area?
      p_position = p_position.parent_position
    end
  end
end
