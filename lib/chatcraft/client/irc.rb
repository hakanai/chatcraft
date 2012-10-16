require 'chatcraft/client/base'
require 'chatcraft/message'
require 'em-irc'

module Chatcraft; module Client

  # Client abstraction implementation for IRC.
  class IRC < Base

    attr_reader :name
    attr_reader :bot_name

    attr_reader :client
    
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
        fire(:connected, Event.new)
      end

      @client.on :disconnect do
        fire(:disconnected, Event.new)
      end

      @client.on :join do |who, channel, names|
        channel = channel.gsub(/^:/, '')
        if who == @bot_name
          fire(:bot_joined, Event.new(:group => Group.new(self, channel)))
        else
          fire(:joined, Event.new(:user => User.new(self, who), :group => Group.new(self, channel)))
        end
      end

      @client.on :message do |source, target, message|
        # channel? is useful but protected.
        if @client.send(:channel?, target)
          fire(:group_message, Event.new(:user => User.new(self, source),
                                         :group => Group.new(self, target),
                                         :message => Message.new(message)))
        elsif target == @bot_name
          fire(:private_message, Event.new(:user => User.new(self, source), :group => Message.new(message)))
        else
          puts "*** Not sure who this is to. target = #{target}"
        end
      end
    end

    def connect
      fire(:connecting, Event.new)
      @client.connect
    end

    def disconnect
      fire(:disconnecting, Event.new)
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
        @client.client.privmsg(name, message)
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
        @client.client.privmsg(name, message)
      end
    end
  end

end; end

