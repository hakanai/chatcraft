require 'zing/version'
require 'zing/client/irc'
require 'zing/client/xmpp'

module Zing
  def self.startup
    begin
      config = YAML.load_file('zing.config')
    rescue Errno::ENOENT
      raise 'Config file not found (looking for zing.config in the current directory)'
    end

    connections = config['connections'] || raise('Missing parameter: connections')
    clients = []
    connections.each do |conn|
      protocol = conn['protocol'] || raise('Missing parameter: protocol')
      client = case protocol
      when 'xmpp'
        Zing::Client::XMPP::new(conn)
      when 'irc'
        Zing::Client::IRC::new(conn)
      else
        raise("Unknown protocol: #{protocol}")
      end
      clients << client
    end

    puts "Connecting each client..."
    clients.each do |client|
      client.on(:connecting) do
        puts "Connecting to #{client.name}"
      end
      client.on(:connected) do
        puts "Connected to #{client.name}"
      end
      client.on(:joined) do |group|
        puts "Joined #{group} on #{client.name}"
      end
      client.on(:private_message) do |who, message|
        puts "Private message on #{client.name} from #{who}: #{message}"
      end
      client.on(:group_message) do |who, group, message|
        puts "Group message on #{client.name} #{group} from #{who}: #{message}"
      end
      client.connect
    end

    # TODO: Shutdown would be nice, I guess I'll have Zing::ConnectionManager or something for that.
  end
end
