class Minute::Topic
  include Mongoid::Document

  embedded_in :minute

  field :name, type: String
  field :treated, type: Boolean
end
