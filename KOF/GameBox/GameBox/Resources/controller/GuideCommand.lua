require "controller/command"


----------------------
--触发指引 命令
----------------------
CGuideTouchCammand = class(command, function(self, VO_data, typeId)
	self.type = "TYPE_CGuideTouchCammand"
	self.data = VO_data
	self.typeId = typeId --触发类型ID
end)

CGuideTouchCammand.TYPE   = "TYPE_CGuideTouchCammand"
CGuideTouchCammand.TASK_RECEIVE  = "GUIDE_TASK_RECEIVE" --接受任务
CGuideTouchCammand.TASK_FINISH   = "GUIDE_TASK_FINISH"  --提交任务
CGuideTouchCammand.GUIDE_FINISH  = "GUIDE_FINISH"
CGuideTouchCammand.LV_UP         = "GUIDE_LV_UP"
CGuideTouchCammand.LOGIN         = "GUIDE_LOGIN"


function CGuideTouchCammand.getData(self)
    return self.data
end

function CGuideTouchCammand.getTypeId(self)
    return self.typeId
end

function CGuideTouchCammand.setType(self,CommandType)
    self.type = CommandType
end

function CGuideTouchCammand.setOtherData(self,_data)
	self.otherData = _data
end

function CGuideTouchCammand.getOtheData(self)
	return self.otherData
end






----------------------
--指引点击 命令
----------------------
CGuideStepCammand = class(command, function(self, VO_data, step)
	self.type = "TYPE_CGuideStepCammand"
	self.data = VO_data
	self.step = step or 0 --点击的ID
end)

CGuideStepCammand.TYPE      = "TYPE_CGuideStepCammand"
CGuideStepCammand.STEP_END  = "GUIDE_STEP_END" --步骤完成
CGuideStepCammand.STEP_COPY_FULFILL  = "STEP_COPY_FULFILL" --任务完成

-- CGuideStepCammand.   = "GUIDE_TASK_FINISH"  --

function CGuideStepCammand.getData(self)
    return self.data
end

function CGuideStepCammand.getStepId(self)
    return self.step
end

function CGuideStepCammand.setType(self,CommandType)
    self.type = CommandType
end

function CGuideStepCammand.setOtherData(self,_data)
	self.otherData = _data
end

function CGuideStepCammand.getOtheData(self)
	return self.otherData
end





----------------------
--场景转换 命令
----------------------
CGuideSceneCammand = class(command, function(self, VO_data)
	self.type = "TYPE_CGuideSceneCammand"
	self.data = VO_data
	self.step = _step or 0 
end)


CGuideSceneCammand.TYPE          = "TYPE_CGuideSceneCammand"
CGuideSceneCammand.SCENE_CHUANGE = "GUIDE_SCENE_CHUANGE" --步骤完成
-- CGuideSceneCammand.   = "GUIDE_TASK_FINISH"  --

function CGuideSceneCammand.getData(self)
    return self.data
end

function CGuideSceneCammand.setType(self,CommandType)
    self.type = CommandType
end

function CGuideSceneCammand.setOtherData(self,_data)
	self.otherData = _data
end

function CGuideSceneCammand.getOtheData(self)
	return self.otherData
end


CGuideNoticCammand = class(command, function(self, VO_data,_noticId)
	self.type = "TYPE_CGuideNoticCammand"
	self.data = VO_data
	self.noticId = _noticId or 0 --点击的ID
end)

CGuideNoticCammand.TYPE = "TYPE_CGuideNoticCammand"
CGuideNoticCammand.ADD  = "GUIDE_NOTIC_ADD"


function CGuideNoticCammand.getData(self)
    return self.data
end

function CGuideNoticCammand.getNoticId( self )
	return self.noticId
end

function CGuideNoticCammand.setType(self,CommandType)
    self.type = CommandType
end

function CGuideNoticCammand.setOtherData(self,_data)
	self.otherData = _data
end

function CGuideNoticCammand.getOtheData(self)
	return self.otherData
end

-- local _guideCommand = CGuideNoticCammand( CGuideNoticCammand.ADD, noticId )
-- controller:sendCommand(_guideCommand)

--[[
----------------------
--删除 命令
----------------------
CGuideDeleteCammand = class(command, function(self, VO_data,_typeID)
	self.type = "TYPE_CGuideDeleteCammand"
	self.data = VO_data
	self.typeID = _typeID or 0 --点击的ID
end)


CGuideDeleteCammand.TYPE          = "TYPE_CGuideDeleteCammand"
CGuideDeleteCammand.TASK_END      = "TASK_END" --任务已提交
-- CGuideDeleteCammand.   = "GUIDE_TASK_FINISH"  --

function CGuideDeleteCammand.getData(self)
    return self.data
end

function CGuideDeleteCammand.getTypeId( self )
	return self.typeID
end

function CGuideDeleteCammand.setType(self,CommandType)
    self.type = CommandType
end

function CGuideDeleteCammand.setOtherData(self,_data)
	self.otherData = _data
end

function CGuideDeleteCammand.getOtheData(self)
	return self.otherData
end
]]