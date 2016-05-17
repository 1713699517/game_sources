--
require "common/protocol/REQ_SYSTEM_HEART"
require "common/Network"

CLoginScene = class()

function CLoginScene:open()
    CCLOG("openopen")
end

function CLoginScene:close()
    
end

function CLoginScene.connectCallBack(eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
    --print(obj.view)
    --obj.view:open()
    --CNetwork:connect("192.168.1.131", 8443 )
    CCLOG("connect")
--    tcpConnBtn:removeFromParentAndCleanup(true)
    end
end

function CLoginScene.sendCallBack()
    local req = REQ_SYSTEM_HEART()
    CCLOG("send cb")
    CNetwork:send(req)
end

function CLoginScene.processMessage510(ackMsg)
    CCLOG("srvt="..ackMsg:getSrvt())
    CCLOG("arg1="..ackMsg:getArg1())
    CCLOG("arg2="..ackMsg:getArg2())
    CCLOG("arg3="..ackMsg:getArg3())
    CCLOG("arg4="..ackMsg:getArg4())
end

function CLoginScene.processNetworkMessage(eventType, ackMessage)
    CCLOG("processNetworkMessage")
    local ackMsg = CNetwork:parse(eventType, ackMessage)
    if ackMessage:getMsgID() == Protocol.ACK_SYSTEM_TIME then
        CLoginScene.processMessage510(ackMsg)
    elseif ackMessage:getMsgID() == 520 then

    end
end

function CLoginScene.init(self, winSize, layer)


    --background
    tcpConnBtn = CButton:create("bbutton.png","bbutton.png")
    tcpConnBtn : setControlName( "this CLoginScene tcpConnBtn 55 ")
--CCLOG("setView");
--print(self)
    --tcpConnBtn.view = self
    tcpConnBtn:registerControlScriptHandler(self.connectCallBack, "this CLoginScene tcpConnBtn 59")
    tcpConnBtn:setPosition(50,50)
    layer:addChild(tcpConnBtn)

    tcpSendBtn = CButton:create("bbutton.png","bbutton.png")
    tcpSendBtn : setControlName( "this CLoginScene tcpSendBtn 64 ")
    tcpSendBtn:registerControlScriptHandler(self.sendCallBack, "this CLoginScene tcpSendBtn 65")
    tcpSendBtn:setPosition(200,60)

    --CCLOG(tostring(self.processNetworkMessage))

    tcpSendBtn:registerNetworkMessageScriptHandler(self.processNetworkMessage)      ----adfasdf
    layer:addChild(tcpSendBtn)
    --

    
end


function CLoginScene.scene(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    local scene = CCScene:create()
    local layer = CCLayer:create()
    self:init(winSize, layer)
    scene:addChild(layer)
    return scene
end