module EnumerableDocument
  extend ActiveSupport::Concern

  included do
    include Mongoid::Autoinc

    field :n, as: :number, type: Integer

    increments :number, model_name: name
  end
end
