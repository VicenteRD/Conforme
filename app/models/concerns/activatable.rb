module Activatable
  extend ActiveSupport::Concern

  included do

    field :active, type: Boolean

    def active?
      self.active
    end

    def activate
      self.active = true

      return self
    end

    def deactivate
      self.active = false

      return self
    end

    def toggle_active
      self.active = !self.active

      return self
    end

  end
end