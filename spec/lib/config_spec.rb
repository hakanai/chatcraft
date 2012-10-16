require File.join(File.dirname(__FILE__), '../spec_helper')
require 'chatcraft/util/config'

describe Chatcraft::Util::Config, '#required' do

  it "returns a value which is present" do
    config = Chatcraft::Util::Config.new({'key' => 3})
    config.key.should == 3
  end

  it "returns a config for a nested hash" do
    config = Chatcraft::Util::Config.new({'key' => {'nested' => 3}})
    config.key.should be_an_instance_of Chatcraft::Util::Config
    config.key.nested.should == 3
  end

  it "returns a config for a nested hash in an array" do
    config = Chatcraft::Util::Config.new({'key' => [{'nested' => 3}]})
    config.key[0].should be_an_instance_of Chatcraft::Util::Config
    config.key[0].nested.should == 3
  end

end
