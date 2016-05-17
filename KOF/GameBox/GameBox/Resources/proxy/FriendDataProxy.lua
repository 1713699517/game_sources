
require "view/view"
require "mediator/mediator"


CFriendDataProxy = class( view, function(self)
    CCLOG("CFriendDataProxy 构造")
    self.m_bInitialized = true     --默认未初始化

    self.m_friendType   = nil       --4020
    self.m_friendCount  = nil
    self.m_friendData   = {}

    self.m_recentlyData = {}
    self.m_recentlyCount = nil

    --推荐好友数据
    self.m_recomCount= nil
    self.m_recomData = {}
    --[[--------------模拟数据
    for i=1, 6 do
        self.m_friendData[i] = {}
        
        self.m_friendData[i].fid    = i+1000
        self.m_friendData[i].fname  = "玩家"..i
        self.m_friendData[i].fclan  = "社团"..i
        self.m_friendData[i].flv    = i+10
        self.m_friendData[i].isonline = 0
    end
    ---------------]]

end)

------
function CFriendDataProxy.setInitialized( self, valueForKey)
    self.m_bInitialized = valueForKey
end
function CFriendDataProxy.getInitialized( self)
    return self.m_bInitialized
end
----------------
--最近联系人列表
function CFriendDataProxy.setRecentlyData( self, valueForKey)
    self.m_recentlyData = valueForKey
end
function CFriendDataProxy.getRecentlyData( self)
    return self.m_recentlyData
end

function CFriendDataProxy.setRecentlyCount( self, valueForKey)
    self.m_recentlyCount = valueForKey
end
function CFriendDataProxy.getRecentlyCount( self)
    return self.m_recentlyCount
end



-----------------
-- {返回好友类型（1：好友列表；2：最近联系人列表；3：黑名单列表）}
function CFriendDataProxy.setFriendType( self, value)
    self.m_friendType = value
end
function CFriendDataProxy.getFriendType( self)
    return self.m_friendType
end

-- {好友数量}
function CFriendDataProxy.setFriendCount( self, value)
    self.m_friendCount = value
end
function CFriendDataProxy.getFriendCount(self)
	return self.m_friendCount
end

-- {好友信息块}
function CFriendDataProxy.setFriendData(self, value)
	self.m_friendData = value
end
function CFriendDataProxy.getFriendData(self)
	return self.m_friendData
end



function CFriendDataProxy.getRecomCount( self)
    return self.m_recomCount
end
function CFriendDataProxy.setRecomCount( self, value)
    self.m_recomCount = value
end

function CFriendDataProxy.setRecomData( self, value)
    self.m_recomData = value
end
function CFriendDataProxy.getRecomData( self)
    return self.m_recomData
end
-----------------

if _G.pCFriendDataProxy == nil then
    
    _G.pCFriendDataProxy = CFriendDataProxy()
    --[[
    require "mediator/FriendDataMediator"
    if _G.pCFriendDataMediator ~= nil then
        controller :unregisterMediator( _G.pCFriendDataMediator)
        _G.pCFriendDataMediator = nil
    end
    _G.pCFriendDataMediator = CFriendDataMediator( _G.pCFriendDataProxy )
    controller :registerMediator( _G.pCFriendDataMediator )
    
    print("_G.pCFriendDataProxy, _G.pCFriendDataMediator注册", _G.pCFriendDataMediator)
    --]]
end








