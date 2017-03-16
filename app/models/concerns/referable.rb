module Referable
  extend ActiveSupport::Concern

  included do

    field :ref, as: :references, type: Hash # {class_name: [BSON::ObjectId]}

    def get_all_referred(class_type) # TODO - test this monster
      unless is_document? class_type
        return
      end

      ret_array = []

      class_sym = class_as_key class_type

      if self.references[class_sym]
        self.references[class_sym].each { |object_id|
          ret_array.push(class_type.find(object_id)) # might need to use send()
        }
      end

      ret_array
    end

    def add_references(key, *values)
      puts 'Adding reference of ' + key.to_s + ' with ID(s) ' + values.to_s + ' for ' + self.to_s

      case key
        when Class
          hash_key = key.name
        when Symbol
          hash_key = key
        else # Assuming the key is a string
          hash_key = key.to_sym
      end

      if self.references.nil?
        self.references = {}
      end

      if self.references[hash_key].nil?
        self.references[hash_key] = []
      end

      values.each { |val|
        case val
          when Array
            self.references[hash_key].push(*val)
          else
            self.references[hash_key].push(val)
        end
      }
    end

    # Loads all the associations from an already set hash,
    # without overriding already-set values.
    def add_references_from_hash(hashed_values)
      hashed_values.each { |k, v|
        klass = k.constantize
        v.each { |id|
          obj = klass.find(id)
          obj.add_references(self.class.name, self.id.to_s)
          obj.save!
        }

        self.add_references(k, v)
      }

      self.save!
    end

    def set_references_from_hash(hashed_values)
      self.references = {}
      add_references_from_hash(hashed_values)
    end

  end # included

  ## Helper methods
  private
  def is_document?(class_type)
    class_type < Mongoid::Document
  end

end
