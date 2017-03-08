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

      if self.associations[class_sym]
        self.associations[class_sym].each { |key|
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
        else # Assuming the key is a string
          hash_key = key.to_sym
      end

      if self.associations.nil?
        self.associations = {}
      end
      if self.associations[hash_key].nil?
        self.associations[hash_key] = []
      end

      values.each { |val|
        case val
          when Array
            self.associations[hash_key].push(*val)
          else
            self.associations[hash_key].push(val)
        end
      }
    end

    # Loads all the associations from an already set hash,
    # without overriding already-set values.
    def add_from_hash(hashed_values)
      hashed_values.each { |k, v| self.add_associated(k, v) }
      # TODO - Add the other way around
    end

    def set_from_hash(hashed_values)
      self.associations = {}
      add_from_hash(hashed_values)
    end

  end # included

  ## Helper methods
  private
  def is_document?(class_type)
    class_type < Mongoid::Document
  end

end
