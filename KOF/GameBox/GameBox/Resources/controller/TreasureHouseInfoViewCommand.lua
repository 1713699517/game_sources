require "controller/command"
require "model/VO_LuckyModel"

CTreasureHouseInfoViewCommand = class(command, function(self,page,VO_data)
	self.type = "TYPE_CTreasureHouseInfoViewCommand"
	self.page = page 
	self.data = VO_data
end)

CTreasureHouseInfoViewCommand.TYPE = "TYPE_CTreasureHouseInfoViewCommand"

function CTreasureHouseInfoViewCommand.getModel(self)
    return self.data
end

function CTreasureHouseInfoViewCommand.getPage(self)
    return self.page
end

function CTreasureHouseInfoViewCommand.setType(self,CommandType)
    self.type = CommandType
end

function  CTreasureHouseInfoViewCommand.setOtherData(self,_data)
	self.setOtherData = _data
end

function CTreasureHouseInfoViewCommand.getOtheData(self)
	return self.otherData
end
