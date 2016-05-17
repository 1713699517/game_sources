-----------------------
--系统设置 缓存
-----------------------
require "view/view"
require "controller/command"
require "mediator/SystemSettingMediator"

CSystemSettingProxy = class( view, function( self)
	self.isInited = false
    
    self.count = 0
    self.settingList = {}
end)

function CSystemSettingProxy.setInited( self, valueForKey)
    self.isInited   = valueForKey
end

function CSystemSettingProxy.getInited( self)
    return self.isInited
end

function CSystemSettingProxy.setCount( self, valueForKey)
    self.count = tonumber( valueForKey)
end

-- {数量}
function CSystemSettingProxy.getCount( self)
	return self.count
end

-- {系统设置列表}
function CSystemSettingProxy.getSysSettingList( self)
	return self.settingList
end

function CSystemSettingProxy.setSysSettingList( self, valueForKey)
	self.settingList = valueForKey
end

-- {根据类型获得对应的状态}
function CSystemSettingProxy.getStateByType( self, valueForKey )
    for i,v in ipairs(self.settingList) do
        if v.type == tonumber(valueForKey) then
            return v.state
        end
    end
    return -1
end

function CSystemSettingProxy.getSettingNameByType( self, valueForKey )

    local settingType = tonumber( valueForKey )

    if settingType == _G.Constant.CONST_SYS_SET_MUSIC_BG then
        return "背景音乐"
    elseif settingType == _G.Constant.CONST_SYS_SET_MUSIC then
        return "游戏音效"
    elseif settingType == _G.Constant.CONST_SYS_SET_PK then
        return "允许切磋"
    elseif settingType == _G.Constant.CONST_SYS_SET_SHOW_ROLE then
        return "屏蔽其他玩家"
    elseif settingType == _G.Constant.CONST_SYS_SET_ROLE_DATA then
        return "屏蔽查看他人信息"
    elseif settingType == _G.Constant.CONST_SYS_SET_ENERGY then
        return "满体力提示"
    elseif settingType == _G.Constant.CONST_SYS_SET_MOBILE then
        return "活动提示"
    elseif settingType == _G.Constant.CONST_SYS_SET_TEAM then
        return "允许接收组队"
    else
        return "无"
    end
    
end

_G.pCSystemSettingProxy = CSystemSettingProxy()

if _G.pCSystemSettingMediator ~= nil then
    controller :unregisterMediator( _G.pCSystemSettingMediator)
    _G.pCSystemSettingMediator = nil
end

_G.pCSystemSettingMediator = CSystemSettingMediator( _G.pCSystemSettingProxy)
controller :registerMediator( _G.pCSystemSettingMediator)

