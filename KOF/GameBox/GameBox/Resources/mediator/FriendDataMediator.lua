
require "mediator/mediator"
require "controller/command"
require "controller/FriendDataCommand"
require "common/MessageProtocol"
require "model/VO_RecommendModel"

CFriendDataMediator = class( mediator, function( self, _view )
  self.m_name = "CFriendDataMediator"
  self.m_view = _view
  
  print("CFriendDataMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CFriendDataMediator.getView( self )
	-- body
	return self.m_view
end


function CFriendDataMediator.getName( self )
	return self.m_name
end


function CFriendDataMediator.processCommand( self, _command )
    
	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()
        
        if msgID == _G.Protocol["ACK_FRIEND_INFO"] then     -- (手动) -- [4020]返回好友信息 -- 好友
            self :ACK_FRIEND_INFO( ackMsg)
            
        end
        
        if msgID == _G.Protocol.ACK_FRIEND_SYS_FRIEND then
            self :ACK_FRIEND_SYS_FRIEND( ackMsg)            -- (手动) -- [4200]系统推荐好友 -- 好友
        end
        
        
    end

end

function CFriendDataMediator.ACK_FRIEND_INFO( self, _ackMsg)
    CCLOG("CFriendDataMediator.ACK_FRIEND_INFO ", _ackMsg :getType())
    print(_ackMsg :getCount(), _ackMsg :getType())
    local nCount = _ackMsg :getCount()
    
    self :getView() :setInitialized( true)
    self :getView() :setFriendType( _ackMsg :getType())
    
    if _ackMsg :getType() == 1 then
        self :getView() :setFriendCount( _ackMsg :getCount())
        if nCount >= 0 then
            self :getView() :setFriendData( _ackMsg :getData())
            
            local command = CFriendUpdataCommand( CFriendUpdataCommand.TYPE_FRIEND)
            controller :sendCommand( command)
            return false
        end
    elseif _ackMsg :getType() == 2 then
        self :getView() :setRecentlyCount( _ackMsg :getCount())
        if nCount >= 0 then
            self :getView() :setRecentlyData( _ackMsg :getData())
            
            local command = CFriendUpdataCommand( CFriendUpdataCommand.TYPE_RECENTLY)
            controller :sendCommand( command)
            return false
        end
    elseif _ackMsg :getType() == 3 then
        
    end
    
   
end


-- (手动) -- [4200]系统推荐好友 -- 好友
function CFriendDataMediator.ACK_FRIEND_SYS_FRIEND( self, _ackMsg)
    print("CMainUIMediator ACK_FRIEND_SYS_FRIEND", _ackMsg :getCount())
    
    if _ackMsg :getCount() then
        if _ackMsg :getCount()>0 then
            self :getView() :setInitialized( true)
            
            self :getView() :setRecomCount( _ackMsg :getCount())
            self :getView() :setRecomData( _ackMsg :getData())
            
            local isonline = true
            local currentScene = true
        end
    end
end


