class Task::Planning < Task
  include Mongoid::Document

  belongs_to :planning
end
