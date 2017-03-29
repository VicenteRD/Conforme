class StrategyRevision
  include Mongoid::Document

  include Describable

  field :rev_at, as: :revised_at, type: DateTime
end
