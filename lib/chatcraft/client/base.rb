module Chatcraft; module Client

  # Base class fir client abstractions. The goal here is that the caller shouldn't
  # really need to know how to use each protocol.
  class Base

    # Registers to receive callbacks for an event.
    #
    # Supported event types:
    #
    #   :connected
    #
    #   :joined
    #     - group
    #
    #   :private_message
    #     - user
    #     - message text
    #
    #   :group_message
    #     - user
    #     - group
    #     - message text
    #
    def on(event, &block)
      listeners_for(event) << block
    end

    # Fires an event.
    def fire(event, *payload)
      listeners_for(event).each { |l| l.call(*payload) }
    end

    private

    # Gets the listeners for an event.
    def listeners_for(event)
      @listeners ||= {}
      @listeners[event] ||= []
    end
  end

end; end
