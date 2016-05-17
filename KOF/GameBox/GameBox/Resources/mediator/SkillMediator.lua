require "mediator/mediator"
require "controller/SkillCommand"

require "common/MessageProtocol"
require "common/protocol/ACK_SKILL_PARENTINFO"


CSkillMediator = class( mediator, function( self, _view )
    self.m_name = "SkillMediator"
    self.m_view = _view
    print(self.m_name," 的view为 ", self.m_view)
end)


function CSkillMediator.getView( self )
	return self.m_view;
end


function CSkillMediator.getName( self )
	return self.m_name;
end


function CSkillMediator.processCommand( self, _command )

    if _command: getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()


    end

    if _command:getType() == CSkillDataUpdateCommand.TYPE then
        --CCMessageBox("更新技能界面", _command :getData())
        local curScenesType = _G.g_Stage :getScenesType()
        if curScenesType== _G.Constant.CONST_MAP_TYPE_CITY then
            
            if _command :getData() == CSkillDataUpdateCommand.TYPE_UPDATE then
                self :getView() :initData()
                self :getView() :setRightInfoView( nil)
                self :getView() :playEffectSound()
                
            end
            
            if _command :getData() == CSkillDataUpdateCommand.TYPE_EQUIP then
                self :getView() :cleanClickEquipIcon()
                self :getView() :initEquipBtnIcon()
                self :getView() :setEquipView()
            end
            
            if _command :getData() == CSkillDataUpdateCommand.TYPE_PARTNER then
                self :getView() :setPartnerView()
            end
            print("skill getData()", _command :getData())
        end
        
    end

    --[[
    if _command :getType() == CMoneyChangedCommand.TYPE then
        if _command :getData() ~= CMoneyChangedCommand.MONEY then
            
        end
        
        local curScenesType = _G.g_Stage :getScenesType()
        if curScenesType== _G.Constant.CONST_MAP_TYPE_CITY then
            --self :getView() :setMoneyView()
        end
        
        
    end
     --]]

    --if _command: getType() == CSkillMediator
    --处理技能的command，从proxy拿取数据。格式化，调用view里的方法，改变显示的东西

    return false

end
