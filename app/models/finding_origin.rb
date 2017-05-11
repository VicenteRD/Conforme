class FindingOrigin
  include Mongoid::Document

  embedded_in :finding

  field :name, type: String
end
