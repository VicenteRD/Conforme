class Task::PlanningTask < Task
  include Mongoid::Document

  belongs_to :planning
end
