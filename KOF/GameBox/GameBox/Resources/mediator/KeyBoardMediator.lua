require "mediator/mediator"
require "controller/KeyBoardCommand"

CKeyBoardMediator = class(mediator, function(self, _view)
    self.name = "KeyBoardMediator"
    self.view = _view
end)

function CKeyBoardMediator.processCommand(self, _command)
    if _command:getType() == CKeyBoardSkillCDCommand.TYPE then
    	--查找对应的Index, 设置CD
    	local _nSkillId = _command:getData():getSkillId()
    	local _fCooldown = _command:getData():getCooldown()

    	local _skillIndex = 0
        --- 注释掉
        --local uid = _G.g_LoginInfoProxy : getUid()
        --local skillInfo = _G.g_SkillDataProxy : getCharacterSkillByUid( uid )
        ----0831 change
        local uid = _G.g_LoginInfoProxy : getUid()
        local roleProperty  = _G.g_characterProperty : getMainPlay()
        if roleProperty == nil then
            CCMessageBox("roleProperty==", roleProperty)
            CCLOG("roleProperty=="..roleProperty)
        end
        local skillInfo     = roleProperty :getSkillData()
        -------- end


        if skillInfo ~= nil then
        	if _nSkillId == skillInfo:getSkillIdByIndex(5) then
        		_skillIndex = 1
        	elseif _nSkillId == skillInfo:getSkillIdByIndex(6) then
        		_skillIndex = 2
        	elseif _nSkillId == skillInfo:getSkillIdByIndex(7) then
        		_skillIndex = 3
        	else
        		_skillIndex = 0
        	end

        	if _skillIndex > 0 then
        		self:getView():setSkillCD( _skillIndex, _fCooldown )
        	end
        end
    	return true
    end
    return false
end