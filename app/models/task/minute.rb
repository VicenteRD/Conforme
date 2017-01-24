class Task::Minute < Task
  include Mongoid::Document

  belongs_to :minute
end
