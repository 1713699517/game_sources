require "view/view"


CLoginInfoProxy = class( view , function( self)
                       self.m_bInitialized = false
                        self.m_serverId = -1
                        self.m_uid = 0
                        self.m_isFirstLogin = false  --是否第一次登陆
                       end)

_G.g_LoginInfoProxy = CLoginInfoProxy()

--缓存存放
function CLoginInfoProxy.setInitialized(self, bValue)
    self.m_bInitialized = bValue
end

function CLoginInfoProxy.getInitialized(self)
    return self.m_bInitialized 
end

function CLoginInfoProxy.setUid(self, _uid)
    self.m_uid = _uid
    CUserCache:sharedUserCache():setObject("uid", tostring(_uid))
end

function CLoginInfoProxy.getUid(self)
    return self.m_uid
end

function CLoginInfoProxy.setServerId(self, _sid)
    self.m_serverId = _sid
    CUserCache:sharedUserCache():setObject("sid", tostring(_sid))
end

function CLoginInfoProxy.getServerId(self)
    return self.m_serverId
end

--是否第一次登陆   默认否
function CLoginInfoProxy.setFirstLogin( self, _bool )
    self.m_isFirstLogin = _bool
end

function CLoginInfoProxy.getFirstLogin( self )
    return self.m_isFirstLogin
end
