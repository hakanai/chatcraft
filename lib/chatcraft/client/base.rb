require 'chatcraft/util/event_system'

module Chatcraft; module Client

  # Base class fir client abstractions. The goal here is that the caller shouldn't
  # really need to know how to use each protocol.
  #
  # Supported event types:
  #
  #   :connecting
  #   :connected
  #   :disconnecting
  #   :disconnected
  #
  #   :bot_joined
  #     - group
  #
  #   :joined
  #     - user
  #     - group
  #
  #   :private_message
  #     - user
  #     - message text
  #
  #   :group_message
  #     - user
  #     - group
  #     - message text
  #
  class Base
    include Chatcraft::Util::EventSystem
  end

end; end
