class Example < Chatcraft::Plugins::Base
  on :group_message, ['hi', :target], :call => :hi

  def hi(user, group, message, params)
    if params[:target] == group.client.bot_name
      group.say "hi, #{user}"
    end
  end
end