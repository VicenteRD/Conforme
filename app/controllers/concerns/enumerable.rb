module Enumerable
  extend ActiveSupport::Concern

  included do
    include Mongoid::Autoinc

    field :n, as: :number, type: Integer

    increments :number
   end
end
