class Example < Chatcraft::Plugins::Base
  metadata :name => 'example',
           :version => '0.0.1',
           :author => 'Trejkaz <trejkaz@trypticon.org>'

  on :group_message, ['hi', :target], :call => :hi

  def hi(event)
    if event.message_params[:target] == event.group.client.bot_name
      event.group.say "hi, #{event.user}!"
    end
  end
end