require 'chatcraft/plugins/base'
require 'chatcraft/plugins/wrapper'

module Chatcraft

  class PluginManager
    def initialize
      @wrappers = []
    end

    # Configures the plugin manager. The config is an array of config hashes for add_client.
    def configure(config)
      config.each do |plugin_config|
        add_plugin(plugin_config)
      end
    end

    # Adds a plugin. The config is a hash with a 'name' key indicating the plugin to load.
    # The rest of the values in the hash are for the plugin to configure itself.
    def add_plugin(config)
      name = config.name
      require name
      plugin_class = Chatcraft::Plugins::Base._known_plugins.find { |p| p.metadata[:name] == name }
      wrapper = Chatcraft::Plugins::Wrapper.new(plugin_class)
      wrapper.configure(config)
      @wrappers << wrapper
    end

    def handle(type, event)
      # TODO: Handle all types
      if type != :group_message
        return
      end

      @wrappers.each do |wrapper|
        break if wrapper.handle_group_message(event)
      end
    end
  end

end