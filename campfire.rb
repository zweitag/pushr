require 'rubygems'
require 'tinder'

# = Jabber notifications for Pushr (http://github.com/karmi/pushr/)
# Buy http://peepcode.com/products/xmpp from Topfunky!
class Pushr::Notifier::Campfire < Pushr::Notifier::Base

  def deliver!(notification)
    return unless configured?
    @campfire ||= Tinder::Campfire.new config['user'], :ssl => true, :token => config['apikey']
    @room ||= campfire.find_room_by_name config['room']
    @room.speak "[pushr] #{message(notification)}"
  end

  private
  
  def message(notification)
    if(notification.success)
      "Deployed #{notification.application} with revision #{notification.repository.info.revision} - #{notification.repository.info.message.slice(0, 100)}"
    else
      "FAIL! Deploying #{notification.application} failed. Check deploy.log for details."
    end
  end

  def configured?
    !config['apikey'].nil? && !config['user'].nil? && !config['room'].nil?
  end

end