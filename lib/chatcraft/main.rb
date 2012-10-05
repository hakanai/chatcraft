require 'chatcraft/version'
require 'chatcraft/client_manager'

module Chatcraft

  class Main

    # Starts up EventMachine and then Chatcraft.
    def startup
      begin
        EventMachine.run do
          inner_startup
        end
      rescue Interrupt
        puts "Interrupted... exiting."
      end
    end

    # Starts up Chatcraft (assumes that EventMachine is already running.)
    def inner_startup
      begin
        config = YAML.load_file('chatcraft.config')
      rescue Errno::ENOENT
        raise 'Config file not found (looking for chatcraft.config in the current directory)'
      end

      connections = config['connections'] || raise('Missing parameter: connections')
      @manager = ClientManager.new
      @manager.add_clients(connections)
      @manager.connect_all
    end

    # Shuts down Chatcraft.
    def shutdown
      @manager.disconnect_all
    end

  end

end
