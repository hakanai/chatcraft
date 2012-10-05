require 'zing/client/base'
require 'em-irc'

module Zing; module Client

  # Client abstraction implementation for IRC.
  class IRC < Base

    attr_reader :name

    def initialize(config)
      @name = config['name'] || raise('Missing parameter: name')
      host = config['host'] || raise('Missing parameter: host')
      nick = config['nick'] || raise('Missing parameter: nick')
      channels = config['channels'] || raise('Missing parameter: channels')
      outer = self

      @handlers = {}

      @client = EventMachine::IRC::Client.new do
        host(host)
        port('6667')

        on :connect do
          nick(nick)
          channels.each { |ch| join(ch) }
          outer.fire(:connected)
        end

        on :join do |who, channel, names|
          if who == nick
            channel.gsub!(/^:/, '')
            outer.fire(:joined, Group.new(channel))
          else
            # it was someone else
          end
        end

        on :message do |source, target, message|
          if channel?(target)
            outer.fire(:group_message, User.new(source), Group.new(target), message)
          elsif target == nick
            outer.fire(:private_message, User.new(source), message)
          else
            puts "*** Not sure who this is to. target = #{target}"
          end
        end
      end
    end

    def connect
      fire(:connecting)
      @client.connect
    end

    def disconnect
      #TODO: I can't figure out how to disconnect this client.
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

