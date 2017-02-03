class BusinessProcess
  include Mongoid::Document

  field :name, type: String
  field :desc, as: :description, type: String
end
