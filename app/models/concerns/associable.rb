module Associable
  extend ActiveSupport::Concern

  included do

    field :assoc, as: :associations, type: Hash # {class: [BSON::ObjectId]}

    def get_all_associated(class_type) # TODO - test this monster
      unless is_document? class_type
        return
      end

      ret_array = []

      class_sym = class_as_key class_type

      if self.assoc[class_sym]
        self.assoc[class_sym].each { |key|
          ret_array.push(class_type.find(key)) # might need to use send()
        }
      end

      ret_array
    end

    def add_associated(key, *values)
      case key
        when Class
          hash_key = class_as_key key
        when Symbol
          hash_key = key
        else
          hash_key = key.to_sym
      end

      unless assoc[hash_key]
        assoc[hash_key] = []
      end

      values.each { |val|
        case val
          when Array
            assoc[hash_key].push(*val)
          else
            assoc[hash_key].push(val)
        end
      }
    end

  end # included

  ## Helper methods

  def is_document?(class_type)
    class_type < Mongoid::Document
  end

end
