class Minute::Task < Task
  include Mongoid::Document

  belongs_to :minute
end
