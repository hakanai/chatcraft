require 'chatcraft/client/base'
require 'em-irc'

module Chatcraft; module Client

  # Client abstraction implementation for IRC.
  class IRC < Base

    attr_reader :name
    attr_reader :bot_name

    def initialize(config)
      @name = config['name'] || raise('Missing parameter: name')
      host = config['host'] || raise('Missing parameter: host')
      @bot_name = config['nick'] || raise('Missing parameter: nick')
      channels = config['channels'] || raise('Missing parameter: channels')

      @handlers = {}

      @client = EventMachine::IRC::Client.new do
        host(host)
        port('6667')
      end

      @client.on :connect do
        @client.nick(@bot_name)
        channels.each { |ch| @client.join(ch) }
        fire(:connected)
      end

      @client.on :disconnect do
        fire(:disconnected)
      end

      @client.on :join do |who, channel, names|
        channel = channel.gsub(/^:/, '')
        if who == @client.bot_name
          fire(:bot_joined, Group.new(self, channel))
        else
          fire(:joined, User.new(self, who), Group.new(self, channel))
        end
      end

      @client.on :message do |source, target, message|
        if @client.channel?(target)
          fire(:group_message, User.new(self, source), Group.new(self, target), Messages::Message.new(message))
        elsif target == @client.bot_name
          fire(:private_message, User.new(self, source), Messages::Message.new(message))
        else
          puts "*** Not sure who this is to. target = #{target}"
        end
      end
    end

    def connect
      fire(:connecting)
      @client.connect
    end

    def disconnect
      fire(:disconnecting)
      @client.quit
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
        @client.message(name, message)
      end
    end

    class Group
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
        @client.message(name, message)
      end
    end
  end

end; end

