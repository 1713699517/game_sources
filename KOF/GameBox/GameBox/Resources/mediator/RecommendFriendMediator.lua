--推荐好友

require "mediator/mediator"
require "controller/command"
require "controller/FriendDataCommand"
require "model/VO_RecommendModel"

require "common/MessageProtocol"


RecommendFriendMediator = class( mediator, function( self, _view )
  self.m_name = "RecommendFriendMediator"
  self.m_view = _view
  
  print("RecommendFriendMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function RecommendFriendMediator.getView( self )
	return self.m_view
end


function RecommendFriendMediator.getName( self )
	return self.m_name
end


function RecommendFriendMediator.processCommand( self, _command )
    if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()
        
    end
    
    if _command :getType() == CFriendUpdataCommand.TYPE then
       print("-=-=-=-=-=-=-=-=-")
        if _G.pCFriendDataProxy :getFriendCount() > 0 then
            self :getView() :pushData()
        end
    end
    
end






