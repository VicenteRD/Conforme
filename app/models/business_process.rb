class BusinessProcess
  include Mongoid::Document

  field :name, type: String
  field :desc, as: :description, type: String

  index({name: 1}, {unique: true, name: 'name_index'})
end
