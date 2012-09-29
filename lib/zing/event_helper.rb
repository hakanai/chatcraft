module Zing
  module EventHelper

    def on(event, &block)
      listeners_for(event) << block
    end

    def fire(event, *payload)
      listeners_for(event).each { |l| l.call(*payload) }
    end

    private

    def listeners_for(event)
      @listeners ||= {}
      @listeners[event] ||= []
    end
  end
end