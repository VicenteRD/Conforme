class Risk::Task < Task
  include Mongoid::Document

  belongs_to :risk, class_name: 'Risk'
end
