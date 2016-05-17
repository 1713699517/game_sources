require "mediator/mediator"
require "controller/command"

require "model/VO_FriendModel"

require "common/MessageProtocol"


CFriendListMediator = class( mediator, function( self, _view )
  self.m_name = "CFriendListMediator"
  self.m_view = _view
  
  print("CFriendListMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CFriendListMediator.getView( self )
	return self.m_view
end


function CFriendListMediator.getName( self )
	return self.m_name
end


function CFriendListMediator.processCommand( self, _command )
    
	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()
    
        
        if msgID == _G.Protocol["ACK_FRIEND_SEARCH_REPLY"] then
            self :ACK_FRIEND_SEARCH_REPLY( ackMsg)
            
        elseif msgID == _G.Protocol["ACK_FRIEND_ADD_NOTICE"]  then      -- (手动) -- [4080]发送添加好友通知 -- 好友
            self :ACK_FRIEND_ADD_NOTICE( ackMsg)
            
        elseif msgID == _G.Protocol["ACK_FRIEND_DEL_OK"] then           -- (手动) -- [4040]好友删除成功 -- 好友 
            self :ACK_FRIEND_DEL_OK( ackMsg)                            
        end
    end
    
    if _command :getType() == CFriendUpdataCommand.TYPE then
        print("CFriendListMediator _command:getType()=", _command :getData())
        local curScenesType = _G.g_Stage :getScenesType()
        if curScenesType == _G.Constant.CONST_MAP_TYPE_CITY then
            if _command :getData() == CFriendUpdataCommand.TYPE_FRIEND then
                self :getView() :setFriendView()        --初始化好友面板信息
            elseif _command :getData() == CFriendUpdataCommand.TYPE_RECENTLY then
                self :getView() :setFriendView()      --初始化最近联系人面板
            end
            return false
        end
    end
    
    if _command :getType() == CFriendUpdataCommand.OPEN_CHAT_TYPE then
        print("近来聊天")
        --聊天(测试)
        if _G.pChatWindowedView == nil then
            _G.pChatWindowedView = CChatWindowedView()
        end
        if _G.pChatWindowedMediator ~= nil then
            controller :unregisterMediator(_G.pChatWindowedMediator)
            _G.pChatWindowedMediator = nil
        end
        _G.pChatWindowedMediator = CChatWindowedMediator(_G.pChatWindowedView)
        controller :registerMediator(_G.pChatWindowedMediator)
        
        _G.pChatWindowedView :open()
        
    end
    
        
    

end

function CFriendListMediator.ACK_FRIEND_SEARCH_REPLY( self, _ackMsg)
    print("CFriendListMediator.ACK_FRIEND_SEARCH_REPLY", _ackMsg :getCount())

    local vo_data = VO_FriendModel()
    
    vo_data :setSearchCount( _ackMsg :getCount())
    
    if _ackMsg :getCount() > 0 then
        vo_data :setSearchData( _ackMsg :getData())
    end
    
    self :getView() :setSearchView( vo_data)
end

function CFriendListMediator.ACK_FRIEND_ADD_NOTICE( self, _ackMsg)
    print("4080-----", _ackMsg :getFname())
    local vo_data = VO_FriendModel()
    
    vo_data :setFid( _ackMsg :getFid())
    vo_data :setFname( _ackMsg :getFname())
    
    --self :getView() :setSearchView( vo_data)
end

function CFriendListMediator.ACK_FRIEND_DEL_OK( self, _ackMsg)
    print("4040ACK_FRIEND_DEL_OK==", _ackMsg :getFid())
    
    if _ackMsg :getFid() then
        local vo_data = VO_FriendModel()
        vo_data :setDelFid( _ackMsg:getFid())
        
        self :getView() :setDelView( vo_data)
    end
end