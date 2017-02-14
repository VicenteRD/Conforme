class Standard
  include Mongoid::Document

  embeds_many :articles, class_name: 'Standard::Article'

  field :name, type: String
end
