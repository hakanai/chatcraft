require 'zing/client/base'
require 'blather/client/client'
require 'blather/stanza/message'

module Zing; module Client

  # Client abstraction implementation for XMPP.
  class XMPP < Base

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
        fire(:private_message, User.new(m.from), m.body)
      end
  	end

    def connect
      fire(:connecting)
      @client.run
    end

  	def close
  	  @client.close
  	end

    class User
      attr_reader :client
      attr_reader :name

      def initialize(client, name)
        @client = client
        @name = name
      end

      def to_s
        name
      end

      def say(message)
        @client.write(Blather::Stanza::Message.new(name, message))
      end
    end
  end

end; end
