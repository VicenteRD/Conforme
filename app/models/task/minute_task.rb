class Task::MinuteTask < Task
  include Mongoid::Document

  belongs_to :minute
end
