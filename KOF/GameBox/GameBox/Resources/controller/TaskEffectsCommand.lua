require "controller/command"

CTaskEffectsCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CTaskEffectsCommand"
	self.data = VO_data
end)

CTaskEffectsCommand.TYPE = "TYPE_CTaskEffectsCommand"

function CTaskEffectsCommand.getdata(self)
    return self.data
end

function CTaskEffectsCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CTaskEffectsCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CTaskEffectsCommand.getOtheData(self)
	return self.otherData
end
