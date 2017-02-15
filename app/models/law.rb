class Law
  include Mongoid::Document

  embeds_many :articles, class_name: 'Law::Article'

  field :name, type: String
end
