class Objective
  include Mongoid::Document

  ## Relations
  belongs_to :creator, class_name: 'User', foreign_key: 'c_id'
  belongs_to :responsible, class_name: 'User', foreign_key: 'r_id'

  has_many :indicators

  ## Other fields
  field :name, type: String
  field :phrase, type: String
end
