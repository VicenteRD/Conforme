class Minute::Folder
  include Mongoid::Document

  embeds_many :minutes

  field :name, type: String
  field :active, type: Boolean
end
