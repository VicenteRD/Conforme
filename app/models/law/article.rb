class Law::Article
  include Mongoid::Document

  embedded_in :law, class_name: 'Law'

  field :name, type: String
  field :req, as: :requirement, type: String
end
