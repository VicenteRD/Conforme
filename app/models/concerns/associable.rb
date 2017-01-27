module Associable
  extend ActiveSupport::Concern

  included do
    field :assoc, as: :associations, type: Hash # {class: [BSON::ObjectId]}

    def get_all_associated(class_type) # TODO - test this monster
      unless class_type.method_defined? :find
        return
      end

      ret_array = []

      class_string = class_type.name.downcase.pluralize.replace('::', '_')
      if self.assoc[class_string]
        self.assoc[class_string].each { |key|
          ret_array.push(class_type.find(key))
        }
      end

      ret_array
    end
  end
end

