require "mediator/mediator"
require "model/VO_TreasureHouseModel"


CTreasureHouseInfoViewMediator = class(mediator, function(self, _view)
	self.name = "TreasureHouseInfoViewMediator"
	self.view = _view
end)


function CTreasureHouseInfoViewMediator.getView(self)
	return self.view
end

function CTreasureHouseInfoViewMediator.getName(self)
	return self.name
end

function CTreasureHouseInfoViewMediator.getUserName(self)
	return self.user_name
end

function CTreasureHouseInfoViewMediator.processCommand(self,_command)
	print("_command==============",_command)
	print("getView()=============",self:getView())
	print("getType===============",_command:getType())
	print("getData1==============",_command:getData())
	--接受服务端发回结果
	if _command:getType() == CNetworkCommand.TYPE then

	end
	if _command:getType() == CTreasureHouseInfoViewCommand.TYPE then
        print("_command :getModel() :getEquipinitnum()")
        print("55695d",self : getView())
        local page = _command : getPage()
        if page == 1 then
        	print("删除释放所有资源11212")
			self :getView()   : releaseAllResources()    
        -- elseif page == 2 then
        -- 	self :getView()   : OpenEquipmentManufacturePage( _command : getModel())    
        elseif page == 3 then
        	self :getView()   : OpenMysteriousShopPage()
        end
    end
	return false
end






















