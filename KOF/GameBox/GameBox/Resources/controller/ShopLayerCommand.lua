require "controller/command"

CShopLayerCommand = class(command, function(self, VO_data)
	self.type = "TYPE_CShopLayerCommand"
	self.data = VO_data
end)

CShopLayerCommand.TYPE = "TYPE_CShopLayerCommand"

function CShopLayerCommand.getModel(self)
    return self.data
end

function CShopLayerCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CShopLayerCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CShopLayerCommand.getOtheData(self)
	return self.otherData
end

--------------------------------------------------------------
CShopWindowedCommand = class(command, function(self, way)
	self.type = "TYPE_CShopWindowedCommand"
	self.data = way
end)

CShopWindowedCommand.TYPE = "TYPE_CShopWindowedCommand"
CShopWindowedCommand.SHOW = "chat_show"
CShopWindowedCommand.HIDE = "chat_hide"
CShopWindowedCommand.OPEN = "chat_open"