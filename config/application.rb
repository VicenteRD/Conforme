require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Conforme
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]

    config.autoload_paths += %W(#{config.root}/lib)

    def sys_timezone
      # Taken from: https://gist.github.com/numist/f34cb150e337a8b948d9 . All credit to his author
      # Yes, this is actually a shell script…
      olsontz = `if [ -f /etc/timezone ]; then
    cat /etc/timezone
  elif [ -h /etc/localtime ]; then
    readlink /etc/localtime | sed "s/\\/usr\\/share\\/zoneinfo\\///"
  else
    checksum=\`md5sum /etc/localtime | cut -d' ' -f1\`
    find /usr/share/zoneinfo/ -type f -exec md5sum {} \\; | grep "^$checksum" | sed "s/.*\\/usr\\/share\\/zoneinfo\\///" | head -n 1
  fi`.chomp

      # …and it almost certainly won't work with Windows or weird *nixes
      throw "Olson time zone could not be determined" if olsontz.nil? || olsontz.empty?

      olsontz
    end

    config.time_zone = sys_timezone
  end




end
