require File.join(File.dirname(__FILE__), '../spec_helper')
require 'chatcraft/commands/command'

describe Chatcraft::Commands::Command, '#parts' do

  it "converts an empty message into an empty command" do
    command = Chatcraft::Commands::Command.new('')
    command.parts.should == []
  end

  it "converts a blank message into an empty command" do
    command = Chatcraft::Commands::Command.new('  ')
    command.parts.should == []
  end

  it "converts a one word message into a one element command" do
    command = Chatcraft::Commands::Command.new('test')
    command.parts.should == ['test']
  end

  it "converts a one word message with surrounding spaces into a one element command" do
    command = Chatcraft::Commands::Command.new('  test ')
    command.parts.should == ['test']
  end

  it "converts a two word message into a two element command" do
    command = Chatcraft::Commands::Command.new('test this')
    command.parts.should == ['test', 'this']
  end

  it "converts a two word quoted message into a one element command" do
    command = Chatcraft::Commands::Command.new('"test this"')
    command.parts.should == ['test this']
  end
end

describe Chatcraft::Commands::Command, '#[]' do
  it "returns the respective element of the command" do
    command = Chatcraft::Commands::Command.new("give \"John Smith\" a bacon roll")
    command[1].should == 'John Smith'
  end
end

describe Chatcraft::Commands::Command, '#rest' do
  it "returns the command itself if passed 0" do
    command = Chatcraft::Commands::Command.new("give \"John Smith\" a bacon roll")
    command.rest(0).should == command.message
  end

  it "returns the rest of the command in the original format" do
    command = Chatcraft::Commands::Command.new("give \"John Smith\" a bacon  roll")
    command.rest(2).should == 'a bacon  roll'
  end
end
