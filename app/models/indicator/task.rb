class Indicator::Task < Task
  include Mongoid::Document

  belongs_to :indicator, class_name: 'Indicator'
end
