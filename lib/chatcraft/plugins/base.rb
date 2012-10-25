module Chatcraft; module Plugins

  # Base class for plugins. Just implements methods so that we know they'll exist even if the subclass doesn't define them.
  class Base

    # Hook to detect subclasses being loaded.
    def self.inherited(klass)
      _known_plugins << klass
      klass.instance_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end

    # TODO: Find a better way to prevent method clashes than using underscored method names.

    def self._known_plugins
      @known_plugins ||= []
    end

    module ClassMethods
      # Supported hash keys:
      # - name (the name of the plugin, a short string people will use to select the plugin.)
      # - version
      # - author
      def metadata(hash=nil)
        if hash
          @_metadata = hash
        end
        @_metadata
      end

      def on(event, *params)
        send("on_#{event.to_s}".to_sym, *params)
      end

      def on_group_message(message_rule, options)
        _group_message_rules << [message_rule, options]
      end

      def _group_message_rules
        (@_group_message_rules ||= [])
      end
    end

    module InstanceMethods
      def configure(config)
      end
    end
  end

end; end