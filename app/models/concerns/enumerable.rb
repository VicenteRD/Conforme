module Enumerable
  extend ActiveSupport::Concern

  included do
    field :n, as: :number, type: Integer

    include Mongoid::Autoinc


    increments :number

    def get_number
      self.number
    end
  end
end
