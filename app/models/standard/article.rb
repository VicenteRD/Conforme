class Standard::Article
  include Mongoid::Document

  embedded_in :standard, class_name: 'Standard'

  field :name, type: String
  field :req, as: :requirement, type: String
end
