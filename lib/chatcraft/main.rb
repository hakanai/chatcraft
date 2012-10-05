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
        puts "Interrupted... exiting. For graceful shutdown, type 'quit' instead."
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

      EventMachine.open_keyboard(KeyboardInput, self)
    end

    # Shuts down Chatcraft.
    def shutdown
      @manager.disconnect_all
    end

    # Handles keyboard input.
    class KeyboardInput < EventMachine::Connection
      include EventMachine::Protocols::LineText2

      def initialize(main)
        @main = main
      end

      def receive_line(data)
        if data == 'quit'
          puts "Performing graceful shutdown..."
          # TODO: Confirm whether this is enough to shut down the machine. I can't tell because em-irc crashes with an exception on disconnect.
          @main.shutdown
        else
          puts "Unknown command: #{data}\nThe only supported command right now is quit."
        end
      end
    end


  end

end