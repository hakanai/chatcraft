require File.join(File.dirname(__FILE__), '../spec_helper')
require 'chatcraft/event'
require 'chatcraft/message'
require 'chatcraft/plugins/base'
require 'chatcraft/plugins/wrapper'
require 'chatcraft/util/config'

describe Chatcraft::Plugins::Wrapper, '#configure' do
  it "passes configuration to the plugin" do
    class TestPlugin < Chatcraft::Plugins::Base
      attr_reader :called
      def configure(config)
        config.value.should == 3
        @called = true
      end
    end
    wrapper = Chatcraft::Plugins::Wrapper.new(TestPlugin)
    wrapper.configure(Chatcraft::Util::Config.new('name' => 'test', 'value' => 3))
    wrapper.plugin.called.should == true
  end
end

describe Chatcraft::Plugins::Wrapper, '#handle_group_message' do

  null_user = Object.new
  null_group = Object.new

  it "does not call the plugin if the event is not registered" do
    class TestPlugin < Chatcraft::Plugins::Base
    end
    wrapper = Chatcraft::Plugins::Wrapper.new(TestPlugin)
    wrapper.handle_group_message(Chatcraft::Event.new(:user => null_user,
                                                      :group => null_group,
                                                      :message => Chatcraft::Message.new('hi')
                                                      )).should == false
  end

  it "does not call the plugin if the message does not match" do
    class TestPlugin < Chatcraft::Plugins::Base
      on :group_message, ['yo'], :call => :never_called
      def never_called(event)
        fail
      end
    end
    wrapper = Chatcraft::Plugins::Wrapper.new(TestPlugin)
    wrapper.handle_group_message(Chatcraft::Event.new(:user => null_user,
                                                      :group => null_group,
                                                      :message => Chatcraft::Message.new('hi')
                                                      )).should == false
  end

  context "using a symbol to indicate a callback method" do
    it "calls the plugin if the message matches" do
      class TestPlugin < Chatcraft::Plugins::Base
        attr_reader :called
        on :group_message, ['hi'], :call => :hi
        def hi(event)
          @called = true
        end
      end
      wrapper = Chatcraft::Plugins::Wrapper.new(TestPlugin)
      wrapper.handle_group_message(Chatcraft::Event.new(:user => null_user,
                                                        :group => null_group,
                                                        :message => Chatcraft::Message.new('hi')
                                                        )).should == true
      wrapper.plugin.called.should == true
    end

    it "calls the plugin and passes parameters if the message matches" do
      class TestPlugin < Chatcraft::Plugins::Base
        attr_reader :called
        on :group_message, ['hi', :second], :call => :hi
        def hi(event)
          event.message_params[:second].should == 'there'
          @called = true
        end
      end
      wrapper = Chatcraft::Plugins::Wrapper.new(TestPlugin)
      wrapper.handle_group_message(Chatcraft::Event.new(:user => null_user,
                                                        :group => null_group,
                                                        :message => Chatcraft::Message.new('hi there')
                                                        )).should == true
      wrapper.plugin.called.should == true
    end
  end

#TODO: Considering allowing blocks as well, which would work something like this:
#  context "using a callback block" do
#    it "calls the plugin if the message matches" do
#      class TestPlugin < Chatcraft::Plugins::Base
#        attr_reader :called
#        on :group_message, ['hi'] do |event|
#          @called = true
#        end
#      end
#      wrapper = Chatcraft::Plugins::Wrapper.new(TestPlugin)
#      wrapper.handle_group_message(Chatcraft::Event.new(:user => null_user,
#                                                        :group => null_group,
#                                                        :message => Chatcraft::Message.new('hi')
#                                                        )).should == true
#      wrapper.plugin.called.should == true
#    end
#
#    it "calls the plugin and passes parameters if the message matches" do
#      class TestPlugin < Chatcraft::Plugins::Base
#        attr_reader :called
#        on :group_message, ['hi', :second] do |event|
#          @called = true
#        end
#      end
#      wrapper = Chatcraft::Plugins::Wrapper.new(TestPlugin)
#      wrapper.handle_group_message(Chatcraft::Event.new(:user => null_user,
#                                                        :group => null_group,
#                                                        :message => Chatcraft::Message.new('hi there')
#                                                        )).should == true
#      wrapper.plugin.called.should == true
#    end
#  end

  after do
    Object.send(:remove_const, :TestPlugin)
  end
end
