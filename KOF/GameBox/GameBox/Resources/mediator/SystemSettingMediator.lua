--------------------------
--系统设置 Mediator
--------------------------
require "mediator/mediator"
require "common/MessageProtocol"

CSystemSettingMediator = class(mediator, function(self, _view)
    self.name = "CSystemSettingMediator"
    self.view = _view
    print("Mediator:",self.name)
end)

function CSystemSettingMediator.getView(self)
    return self.view
end

function CSystemSettingMediator.getName(self)
    return self.name
end

function CSystemSettingMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_SYS_SET_TYPE_STATE   then -- 56820   各功能状态
            self :ACK_SYS_SET_TYPE_STATE( ackMsg)
        end
    end
    return false
end

function CSystemSettingMediator.ACK_SYS_SET_TYPE_STATE( self, _ackMsg )

    local sysSettingList = _ackMsg : getData()

    --排序
    local function sortfunc( setting1, setting2)
        if setting1.type < setting2.type then
            return true
        end
        return false
    end
    table.sort( sysSettingList, sortfunc)

    print("««««««««««系统设置««««««««««")
    for i,v in ipairs(sysSettingList) do
        print("类型->"..v.type.."     状态->"..v.state)
        if v.type == _G.Constant.CONST_SYS_SET_GUIDE then
            --新手指引
            print("--新手指引  1111")
            if v.state == 0 then
                print("--新手指引  222")
                if _G.pCGuideManager ~= nil then
                    _G.pCGuideManager :cancelGuide()
                end
            -- else
            --     _G.pCGuideManager :loadFirstLoginGuide()
            end
        end
    end
    print("«««««««««««««««««««««««««««")

    self : getView() : setSysSettingList( sysSettingList )
    self : getView() : setInited( true )

end