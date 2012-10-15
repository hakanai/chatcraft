module Chatcraft; module Plugins

  # Wraps plugin instances. The main purpose is to keep methods off the plugin instances so that
  # we can add and remove methods without potentially affecting plugins.
  class Wrapper
    # The wrapped plugin instance.
    attr_reader :plugin

    # Creates a new wrapper for the given plugin class.
    def initialize(plugin_class)
      @plugin = plugin_class.new
    end

    # Matches a group message. If the message matches any of the group message rules for the plugin,
    # the plugin is called and we return true. Otherwise, we return false.
    def handle_group_message(user, group, message)
      @plugin.class._group_message_rules.each do |rule, params|
        if message_params = message.match(rule)
          call_plugin(params[:call], user, group, message, message_params)
          return true
        end
      end

      false
    end

    # Calls the plugin using the appropriate method for the call parameter value.
    def call_plugin(call, *params)
      if call.is_a?(Proc)
        call.call(*params)
      elsif call.is_a?(Symbol)
        @plugin.send(call, *params)
      else
        raise "Don't know how to call: #{call} of type #{call.class}"
      end
    end
  end

end; end