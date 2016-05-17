require "mediator/mediator"

require "view/view"
require "view/ErrorBox/ErrorBox"


require "controller/ErrorBoxCommand"

CErrorBoxShopMediator = class(mediator, function(self)
	-- self      = {}
	self.name = "ErrorBoxShopMediator"
	-- self.view = _view

	-- _G.g_CErrorBoxShopMediator = CErrorBoxShopMediator (self)
end)

function CErrorBoxShopMediator.processCommand(self,_command)
	print("_command==============",_command)
	--接受服务端发回结果
	if _command:getType() == CNetworkCommand.TYPE then
		print("服务器发回数据给ErrorBox页面<<<<<<<<<<<<<<<<<<<<<<",_command :getProtocolID())
		local msgID  = _command :getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == 700 then  -- [700]错误代码 -- 系统 
			print("CErrorBoxShopMediator收到错误代码协议,MsgID===",_command :getProtocolID())
			self : ACK_SYSTEM_ERROR( ackMsg )
		end
	end

	if _command:getType() == CErrorBoxCommand.TYPE then
		print("命令发回数据给ErrorBox页面<<<<<<<<<<<<<<<<<<<<<<",_command :getProtocolID())
		local msgID  = _command :getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == 700 then  -- [700]错误代码 -- 系统 
			print("CErrorBoxShopMediator收到错误代码协议,MsgID===",_command :getProtocolID())
			self : ACK_SYSTEM_ERROR( ackMsg )
		end
	end

	return false
end

function CErrorBoxShopMediator.ACK_SYSTEM_ERROR(self, ackMsg)   -- [700]错误代码 -- 系统 

	local StringMsg     = nil 
	local ErrorCode     = ackMsg : getErrorCode()
	-- local ArgCount      = ackMsg : getArgCount()	
	-- local ArgTypeSelect = ackMsg : getArgTypeSelect()
	-- local ArgData       = ackMsg : getArgData()
	-- local ArgData2      = ackMsg : getArgData2()

    _G.Config:load("config/errorcode.xml")
    
	local node =  _G.Config.errorcode : selectSingleNode("e[@id="..tostring(ErrorCode).."]")
	if node : isEmpty() == false then
		StringMsg = node: getAttribute("m")
	else
		StringMsg = ErrorCode  
    end

 	local ErrorBox = CErrorBox()   
 	local BoxLayer = ErrorBox   : create(StringMsg) -- (string,fun1,fun2)
 	local nowScene = CCDirector : sharedDirector() : getRunningScene()
 	nowScene : addChild(BoxLayer,1000)

	print("CErrorBoxShopMediator错误代码协议方法处理完毕～～")
end

    --[[
_G.g_CErrorBoxShopMediator = CErrorBoxShopMediator ()
controller : registerMediator(  _G.g_CErrorBoxShopMediator )
     --]]














