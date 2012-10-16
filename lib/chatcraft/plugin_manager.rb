require 'chatcraft/plugins/base'
require 'chatcraft/plugins/wrapper'

module Chatcraft

  class PluginManager
    def initialize
      @wrappers = []
    end

    def add_plugins(plugin_names)
      plugin_names.each do |name|
        require name
        plugin_class = Chatcraft::Plugins::Base._known_plugins.find { |p| p.metadata[:name] == name }
        wrapper = Chatcraft::Plugins::Wrapper.new(plugin_class)
        @wrappers << wrapper
      end
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