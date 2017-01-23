module Associable

  def self.included(receiver)
    receiver.class_eval do

      field :people, type: Array

      field :audits, type: Array
      field :concerned_parties, type: Array
      field :definitions, type: Array
      field :documents, type: Array
      field :objectives, type: Array
      field :minutes, type: Array


    end
  end
end
