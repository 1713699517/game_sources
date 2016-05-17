require "view/view"

CPayCheckProxy = class( view , function( self)
    self.m_nPayState = nil
end)

_G.g_CPayCheckProxy = CPayCheckProxy()

function CPayCheckProxy.getSystemPayState( self )
    return self.m_nPayState
end

function CPayCheckProxy.setSystemPayState( self, _state )
    self.m_nPayState = _state
end


function CPayCheckProxy.pushRechargeTips( self )
    local _rechargeScene = CRechargeScene :create()
    if _rechargeScene ~= nil then
        local agentCode = LUA_AGENT()
        --if agentCode == 5 then      --pp
            --CCDirector :sharedDirector() :getRunningScene() :addChild( _rechargeScene, 10000, 10005 )
        --else
            CCDirector :sharedDirector() :pushScene( _rechargeScene )
        --end
    end
    
end
