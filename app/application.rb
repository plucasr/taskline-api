require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"

module Taskline
  class Application < Rails::Application
    config.api_only = true
    config.load_defaults 7.2
  end
end
