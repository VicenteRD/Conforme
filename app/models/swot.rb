class Swot
  include Mongoid::Document

  embeds_many :fields, class_name: 'Swot::Field'
end
