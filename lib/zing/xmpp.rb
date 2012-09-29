require 'zing/event_helper'
require 'blather/client/client'

module Zing

  class XMPP
    include EventHelper

    attr_reader :name

  	def initialize(config)
      @name = config['name'] || raise('Missing parameter: name')
  	  jid = config['jid'] || raise('Missing parameter: jid')
  	  password = config['password'] || raise('Missing parameter: password')
  	  @client = Blather::Client.setup(jid, password)

      # TODO: Delegate this to our own handler
      @client.register_handler(:ready) do
        fire(:connected)
      end

      # Always approve subscription requests.
      @client.register_handler :subscription, :request? do |s|
        @client.write s.approve!
      end

      @client.register_handler :message, :chat?, :body do |m|
        fire(:private_message, m.from, m.body)
      end
  	end

    def connect
      fire(:connecting)
      @client.run
    end

  	def close
  	  @client.close
  	end
  end

end
