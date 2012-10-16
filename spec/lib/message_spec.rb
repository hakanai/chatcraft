require File.join(File.dirname(__FILE__), '../spec_helper')
require 'chatcraft/message'

describe Chatcraft::Message, '#parts' do

  it "converts an empty message into an empty message" do
    message = Chatcraft::Message.new('')
    message.parts.should == []
  end

  it "converts a blank message into an empty message" do
    message = Chatcraft::Message.new('  ')
    message.parts.should == []
  end

  it "converts a one word message into a one element message" do
    message = Chatcraft::Message.new('test')
    message.parts.should == ['test']
  end

  it "converts a one word message with surrounding spaces into a one element message" do
    message = Chatcraft::Message.new('  test ')
    message.parts.should == ['test']
  end

  it "converts a two word message into a two element message" do
    message = Chatcraft::Message.new('test this')
    message.parts.should == ['test', 'this']
  end

  it "converts a two word quoted message into a one element message" do
    message = Chatcraft::Message.new('"test this"')
    message.parts.should == ['test this']
  end
end

describe Chatcraft::Message, '#[]' do
  it "returns the respective element of the message" do
    message = Chatcraft::Message.new("give \"John Smith\" a bacon roll")
    message[1].should == 'John Smith'
  end
end

describe Chatcraft::Message, '#rest' do
  it "returns the message itself if passed 0" do
    message = Chatcraft::Message.new("give \"John Smith\" a bacon roll")
    message.rest(0).should == message.message
  end

  it "returns the rest of the message in the original format" do
    message = Chatcraft::Message.new("give \"John Smith\" a bacon  roll")
    message.rest(2).should == 'a bacon  roll'
  end
end

describe Chatcraft::Message, '#match' do
  it "matches an empty pattern" do
    message = Chatcraft::Message.new('test this')
    message.match([]).should == {}
  end

  it "matches a pattern which matches the whole message" do
    message = Chatcraft::Message.new('hi there')
    message.match(['hi', 'there']).should == {}
  end

  it "matches a pattern which matches the start of the message" do
    message = Chatcraft::Message.new('hi there')
    message.match(['hi']).should == {}
  end

  it "does not match a pattern which mismatches at the first element" do
    message = Chatcraft::Message.new('yo')
    message.match(['hi']).should == nil
  end

  it "does not match a pattern which mismatches at a later element" do
    message = Chatcraft::Message.new('are you ready')
    message.match(['are you there']).should == nil
  end

  it "returns parameters in the hash" do
    message = Chatcraft::Message.new('hi Bob')
    message.match(['hi', :name]).should == {:name => 'Bob'}
  end
end


