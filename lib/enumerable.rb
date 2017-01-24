module EnumerableDocument

  def self.included(receiver)
    receiver.class_eval do
      include Mongoid::Autoinc

      field :n, as: :number, type: Integer

      increments :number
      end
  end
end
