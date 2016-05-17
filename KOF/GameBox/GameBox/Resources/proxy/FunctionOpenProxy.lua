--功能开放proxy
require "view/view"
require "controller/command"
--require "mediator/FunctionOpenMediator"

CFunctionOpenProxy = class( view, function( self)
	self.isInited = false
    
    self.count = nil
    self.sys_id = {}
                           
    self.m_nCount = 0

    self.m_subIdList = {} --促销活动
                           
    self.m_lpBuffList = nil     -- 1370

    self.m_isOpenInTime = false
end)

function CFunctionOpenProxy.setIsVisible( self, _nCount)
    self.m_nCount = self.m_nCount + _nCount
end

function CFunctionOpenProxy.getIsVisible( self)
    return self.m_nCount
end

function CFunctionOpenProxy.setInited( self, valueForKey)
    self.isInited   = valueForKey
end

function CFunctionOpenProxy.getInited( self)
    return self.isInited
end

function CFunctionOpenProxy.setCount( self, valueForKey)
    self.count = tonumber( valueForKey)
end

-- {数量}
function CFunctionOpenProxy.getCount( self)
	return self.count
end

-- {系统ID}
function CFunctionOpenProxy.getSysId( self)
	return self.sys_id
end
function CFunctionOpenProxy.setSysId( self, valueForKey)
	self.sys_id = valueForKey
end

-- {打开界面}
function CFunctionOpenProxy.pushEffectScene( self, _scene, _time )
    if _scene ~= nil and _time ~= nil then
        print("self.m_isOpenInTime:",self.m_isOpenInTime)
        if self.m_isOpenInTime == false then
            self.m_isOpenInTime = true
            _G.Scheduler :performWithDelay( 0.9, function( dt )
                self.m_isOpenInTime = false
                local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
                if isdis == false then
                    print("!@#$%亲，锁屏结束可以使用啦")
                    CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true )
                else
                    print("!@#$%Why？为神马锁屏是没有成功的啊")
                end
            end)
            print("!@#$%亲，你马上就可以打开刚创建的界面了,我要锁屏了哦")
            CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false )
            CCDirector : sharedDirector () : pushScene( _scene )
        elseif self.m_isOpenInTime == true then
            print("!@#$%嚓你，在规定的时间内多次打开界面")            
        else
            print("!@#$%晕死，点击界面时，时间控制出现错误")
        end
    end
end


------------------------------------------------------------
------------------------------------------------------------
--新添的缓存信息都在这儿--

--æææææææææææææææææææææææ
--促销活动  已领取的subId  集合
--æææææææææææææææææææææææ
function CFunctionOpenProxy.resetSubIdList( self, _list )
    if _list == nil then
        return
    end
    self.m_subIdList = {}
    self.m_subIdList = _list

    print("---------resetSubIdList---------")
    for i,v in ipairs(self.m_subIdList) do
        print("    已领取的subId-->"..v.idstep)
    end
end

function CFunctionOpenProxy.getSubIdList( self )
    return self.m_subIdList
end

function CFunctionOpenProxy.isSubIdHere( self, _subId )

    print("isSubIdHere--->".._subId)
    for i,v in ipairs(self.m_subIdList) do
        print("isSubIdHere--22->".._subId.."   "..v.idstep)
        if v.idstep == tonumber(_subId) then
            return true
        end
    end
    print("isSubIdHere--33->")
    return false

end


------------------------------------------------------------
--1370 role buff
function CFunctionOpenProxy.setRoleBuff( self, _value )
    self.m_lpBuffList = _value
end

function CFunctionOpenProxy.getRoleBuff( self)
    return self.m_lpBuffList
end

------------------------------------------------------------

_G.pCFunctionOpenProxy = CFunctionOpenProxy()
--[[
if _G.pCFunctionOpenMediator~= nil then
    controller :unregisterMediator( _G.pCFunctionOpenMediator)
    _G.pCFunctionOpenMediator = nil
end

_G.pCFunctionOpenMediator = CFunctionOpenMediator( _G.pCFunctionOpenProxy)
controller :registerMediator( _G.pCFunctionOpenMediator)
--]]



