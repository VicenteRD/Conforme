class Law
  include Mongoid::Document

  embeds_many :articles

  field :name, type: String
end
