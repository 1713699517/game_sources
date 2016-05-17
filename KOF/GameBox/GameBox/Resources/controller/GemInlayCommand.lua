require "controller/command"
require "model/VO_GemInlayModel"

CGemInlayCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CGemInlayCommand"
	self.data = VO_data
    print("VO_data==",VO_data)
end)

CGemInlayCommand.TYPE = "TYPE_CGemInlayCommand"

function CGemInlayCommand.getModel(self)
    return self.data
end

function CGemInlayCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CGemInlayCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CGemInlayCommand.getOtheData(self)
	return self.otherData
end
