require 'chatcraft/client/irc'
require 'chatcraft/client/xmpp'
require 'chatcraft/util/event_system'

module Chatcraft

  class ClientManager
    include Chatcraft::Util::EventSystem

    def initialize
      @clients = []
    end

    # Adds multiple clients. The config is an array of config hashes for add_client.
    def add_clients(config)
      config.each do |subconfig|
        add_client(subconfig)
      end
    end

    # Adds a client. The config is a hash with a 'protocol' key indicating the protocol and
    # protocol-specific options for the respective client.
    def add_client(config)
      protocol = config.protocol || raise('Missing parameter: protocol')
      # TODO: Remove this hard-coded list of supported protocols. Detect subclasses of Client::Base?
      client = case protocol
      when 'xmpp'
        Chatcraft::Client::XMPP::new(config)
      when 'irc'
        Chatcraft::Client::IRC::new(config)
      else
        raise("Unknown protocol: #{protocol}")
      end
      client.on_any do |type, event|
        event = event.clone
        event.client = client
        fire(type, event)
      end
      @clients << client
    end

    # Connects all clients.
    def connect_all
      puts "Connecting each client..."
      @clients.each do |client|
        client.on(:connecting) do
          puts "Connecting to #{client.name}"
        end
        client.on(:connected) do
          puts "Connected to #{client.name}"
        end
        client.on(:disconnecting) do
          puts "Disconnecting from #{client.name}"
        end
        client.on(:disconnected) do
          puts "Disconnected from #{client.name}"
        end
        client.on(:bot_joined) do |event|
          puts "Joined #{event.group} on #{client.name}"
        end
        client.on(:joined) do |event|
          puts "#{event.user} joined #{event.group} on #{client.name}"
        end
        client.on(:private_message) do |event|
          puts "Private message on #{event.group} from #{event.user}: #{event.message}"
        end
        client.on(:group_message) do |event|
          puts "Group message on #{client.name} #{event.group} from #{event.user}: #{event.message}"
        end
        client.connect
      end
    end

    # Disconnects all clients.
    def disconnect_all
      @clients.each do |client|
        client.disconnect
      end
    end

  end

end
