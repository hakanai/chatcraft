require 'chatcraft/event'

module Chatcraft; module Util

  # Generic event system.
  module EventSystem

    # Registers to receive callbacks for an event.
    def on(event, &block)
      listeners_for(event) << block
    end

    def on_any(&block)
      listeners_for(:*) << block
    end

    # Fires an event.
    def fire(event, payload=nil)
      if payload.nil?
        payload = Event.new
      elsif payload.is_a?(Hash)
        payload = Event.new(payload)
      end
      listeners_for(event).each { |l| l.call(payload) }
      listeners_for(:*).each { |l| l.call(event, payload) }
    end

    private

    # Gets the listeners for an event.
    def listeners_for(event)
      @listeners ||= {}
      @listeners[event] ||= []
    end
  end

end; end
