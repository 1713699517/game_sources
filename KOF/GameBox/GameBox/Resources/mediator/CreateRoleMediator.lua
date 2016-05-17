require "mediator/mediator"
require "controller/CreateRoleCommand"
require "view/MainUILayer/MainUIScene"

CCreateRoleMediator = class(mediator, function(self, _view)
    self.name = "CCreateRoleMediator"
    self.view = _view
end)

function CCreateRoleMediator.processCommand(self, _command)
    print("CCreateRoleMediator")
    
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID  = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        print ("_command:getProtocolID()",_command :getProtocolID())

        if (msgID== _G.Protocol.ACK_ROLE_NAME)then-- (手动) -- [1024]请求随机名字 -- 角色
            print("_G.Protocol.ACK_ROLE_NAME")
            print("_command:getProtocolName ",ackMsg :getName())

            if _G.pSelectServerView ~= nil then
                _G.pSelectServerView:removeJuHua()
            end
            self:getView():setEditBoxString( ackMsg :getName() )

        elseif msgID== _G.Protocol["ACK_ROLE_LOGIN_OK_NO_ROLE"] then
            self :ACK_ROLE_LOGIN_OK_NO_ROLE()
        elseif msgID== _G.Protocol["ACK_ROLE_LOGIN_OK_HAVE"] then-- (手动) -- [1021]创建/登录(有角色)成功 -- 角色
            self :ACK_ROLE_LOGIN_OK_HAVE(ackMsg)
            return true
        end
    end
    
    -- if _command:getType() == CCreateRole_AskRandomNameCommand.TYPE then
    --     print("_command:getType")
    --     require "common/protocol/auto/REQ_ROLE_RAND_NAME"
    --     local msg = REQ_ROLE_RAND_NAME()
    --     msg :setArguments(1)
        
    --     CNetwork :send(msg)
    -- end
end

function CCreateRoleMediator.ACK_ROLE_LOGIN_OK_NO_ROLE(self,_ackMsg)
    self:getView()    :loadResources()
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    --self    :requestRole()
    self:getView()    :initView(winSize)
    self:getView()    :layout(winSize)
end
function CCreateRoleMediator.ACK_ROLE_LOGIN_OK_HAVE(self,_ackMsg)

    print("-------------CCreateRoleMediator------------")
    
    if _G.pSelectServerView ~= nil then
        _G.pSelectServerView:removeJuHua()
    end
    
    self:getView():removeCCBI()
    _G.pSelectRoleView:removeRoleContainer()

    if _G.pCreateRoleSceneMediator ~= nil then
        controller :unregisterMediator(_G.pCreateRoleSceneMediator)
        _G.pCreateRoleSceneMediator = nil
    end

    if _G.pSelectRoleMediator ~= nil then
        controller :unregisterMediator(_G.pSelectRoleMediator)
        _G.pSelectRoleMediator = nil
    end

    if _G.pSelectServerView ~= nil then
        _G.pSelectServerView:unloadResources()
        _G.pSelectServerView=nil
    end

    --初始
    _G.pmainView = CMainUIScene()
    _G.g_Stage : addStageMediator()

    local mainProperty = _G.g_characterProperty : getMainPlay()
    if mainProperty == nil then
        CCLOG("没有找到主角1")
        _G.g_characterProperty : initMainPlay(tonumber( _ackMsg : getUid()))
        mainProperty = _G.g_characterProperty : getMainPlay()
    end
    mainProperty : setPro( _ackMsg:getPro() )
    mainProperty : setSex( _ackMsg:getSex() )
    mainProperty : setIsRedName( _ackMsg:getIsRedName() )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_NAME, _ackMsg:getUname() )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_ARMOR, _ackMsg:getSkinArmor() )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_COUNTRY, _ackMsg:getCountry() )
    mainProperty : updateProperty( _G.Constant.CONST_ATTR_LV, _ackMsg:getLv() )
    print("登录成功1111")
end