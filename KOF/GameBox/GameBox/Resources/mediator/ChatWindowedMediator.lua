require "mediator/mediator"
require "controller/ChatCommand"
require "controller/FriendDataCommand"
require "common/MessageProtocol"

CChatWindowedMediator = class(mediator, function(self, _view)
	self.name = "CChatWindowedMediator"
	self.view = _view
end)

function CChatWindowedMediator.processCommand(self, _command)
	if _command:getType() == CNetworkCommand.TYPE then

	end

	if _command:getType() == CChatWindowedCommand.TYPE then
		if _command:getData() == CChatWindowedCommand.SHOW then
			--显示
			self:getView():show()
			return true
		elseif _command:getData() == CChatWindowedCommand.OPEN then
			--打开
			self:getView():open()
			return true
		else
			--隐藏
			self:getView():hide()
			return true
		end
	end

	if _command:getType() == CChatReceivedCommand.TYPE then
        print("33ReceivedCommReceivedComm", debug.traceback() )
		self:getView():autoArchiveMessage( _command:getData() )
	end
                    
    if _command:getType() == CFriendOpenChatCommand.TYPE then
         --显示
          if _G.pChatView == nil then  --防止在聊天界面时重复打开界面
          	self:getView():open()
          end
          if _G.pChatView then
            _G.pChatView:setFriendName( _command :getData())
          end
    elseif _command:getType() == CShowGoodOpenChatCommand.TYPE then
         --显示
          self:getView():open()
          if _G.pChatView then
            _G.pChatView:setShowGoodName( _command :getData())
          end
    end
	return false
end

