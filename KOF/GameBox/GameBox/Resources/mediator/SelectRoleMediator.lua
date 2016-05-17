require "mediator/mediator"
require "controller/SelectRoleCommand"
require "proxy/LoginInfoProxy"
require "view/Stage/Stage"
require "view/Character/Player"
require "proxy/CharacterPropertyProxy"

CSelectRoleMediator = class(mediator, function(self, _view)
    self.name = "SelectRoleMediator"
    self.view = _view
end)

function CSelectRoleMediator.processCommand(self, _command)
    
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        --print ("_command:getProtocolID()",_command :getProtocolID())
        if msgID== _G.Protocol["ACK_ROLE_LOGIN_OK_HAVE"] then-- (手动) -- [1021]创建/登录(有角色)成功 -- 角色
            
            self :ACK_ROLE_LOGIN_OK_HAVE(ackMsg)
            return true
        end
    end
    
    -- if _command:getType() == CSelectRole_ChangeSelectedSeverCommand.TYPE then
    --     --print("CSelectRole_ChangeSelectedSeverCommand.TYPE",_command :getModel())
        
    --     if(_G.g_LoginInfoProxy:getServerId() ~=  _command :getModel() :getSelectedServerID())then
    --         print("CSelectRole_ChangeSelectedSeverCommand.TYPEchange",_command :getModel(): getSelectedServerName())

    --         self.view.m_pServerBtn[1] :setTag  (_command :getModel(): getSelectedServerID())
    --         _G.g_LoginInfoProxy :setServerId( _command :getModel() :getSelectedServerID() )
    --         self.view.m_pServerBtn[1] :setText (_command :getModel(): getSelectedServerName())
            
    --         self.view.m_pContainer :setVisible(false)
    --     else
    --         self.view.m_pContainer :setVisible(true)
    --     end
    -- end
    
    
    -- if _command:getType() == CSelectRoleInitCommand.TYPE then
    -- 	local vo_data1 = _command:getData()
    -- 	local vo_data_historyServer = vo_data1:getHistoryList()
    -- 	local vo_data_recommendServer = vo_data1:getRecommendServerList()
    -- 	local vo_data_roleList = vo_data1:getRoleList()

    -- 	local tab = {}
    -- 	if table.maxn(vo_data_historyServer) > 0 then
    -- 		table.insert(tab, vo_data_historyServer[1])
    -- 	end
    -- 	if table.maxn(vo_data_recommendServer) > 0 then
    -- 		table.insert(tab, vo_data_recommendServer[1])
    -- 	end

    -- 	self:getView():setServerList( tab )
    -- 	self:getView():setRoleList( vo_data_roleList )
    -- end
    return false
end

-- ACK_ROLE_LOGIN_OK_HAVE --成功登录
function CSelectRoleMediator.ACK_ROLE_LOGIN_OK_HAVE(self,_ackMsg)

    print("-------------CSelectRoleMediator------------")

    self:getView():removeRoleContainer()

    if _G.pSelectServerView ~= nil then
        _G.pSelectServerView:removeJuHua()
    end

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
    --记录人物数据

    local mainProperty = _G.g_characterProperty : getMainPlay()
    if mainProperty == nil then
        print("没有找到主角2")
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
    print("登录成功")
end