class Planning::Task < Task
  include Mongoid::Document

  belongs_to :planning
end
