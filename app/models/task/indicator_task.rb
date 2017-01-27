class Task::IndicatorTask < Task
  include Mongoid::Document

  belongs_to :indicator, class_name: 'Indicator'
end
