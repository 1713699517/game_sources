require "mediator/mediator"
require "common/protocol/auto/REQ_GOODS_REQUEST"
require "common/protocol/auto/ACK_MAKE_COMPOSE_OK"


GemInlayMediator = class(mediator, function(self, _view)
                         self.name = "GemInlayMediator"
                         self.view = _view
                         self.m_EquipmentListData={}
                         end)
function GemInlayMediator.getView(self)
    return self.view
end

function GemInlayMediator.getName(self)
    return self.name
end

function GemInlayMediator.getUserName(self)
    return self.user_name
end

function GemInlayMediator.processCommand(self,_command)
    print("_command==============",_command)
    print("getView()=============",self:getView())
    print("getType===============",_command:getType())
    print("getData1==============",_command:getData())
    --接受服务端发回镶嵌结果
    if _command:getType() == CNetworkCommand.TYPE then
        print("服务器发回数据给镶嵌页面<<<<<<<<<<<<<<<<<<<<<<")
        local msgID = _command :getProtocolID()
        print("ackMessage:getMsgID===",msgID)        
        local ackMsg = _command:getAckMessage()
        -- if msgID == _G.Protocol["ACK_GOODS_CHANGE"] then --接收物品属性变化 2050
        --     print("物品属性变化，ackMessage:getMsgID===",msgID)
        --     self : ACK_GOODS_CHANGE( ackMsg )
        -- end
        if msgID == _G.Protocol["ACK_MAKE_PEARL_INSET_OK"] then -- [2561]镶嵌宝石成功 -- 物品/打造/强化
            self : ACK_MAKE_PEARL_INSET_OK( ackMsg )
        end

    end

    if _command:getType() == CProxyUpdataCommand.TYPE then  --更新界面显示
        print(">>>>>>>>背包数据改变，更新界面<<<<<<<<<<")
        self : RENEW_ACK_GOODS_CHANGE( ackMsg )
    end
    return false
end

function GemInlayMediator.ACK_MAKE_PEARL_INSET_OK(self, ackMessage)  --接收物品属性变化 2050
    print("GemInlayMediator原来是这样做 ，哈哈哈哈哈")
     self:getView() : CommandChange_MAKE_PEARL_INSET()
    --self.isOKToChange = 1
    print("提示镶嵌宝石成功～～～")
end
--更新界面
function GemInlayMediator.RENEW_ACK_GOODS_CHANGE(self, ackMessage)             --接收物品属性变化 2050
   local m_uid          = _G.g_LoginInfoProxy :getUid()
    m_roleProperty      = _G.g_characterProperty :getOneByUid( tonumber(m_uid), _G.Constant.CONST_PLAYER)
    m_EquipmentListData = m_roleProperty : getEquipList()


    --m_EquipmentListData   =  _G.g_GameDataProxy :getRoleEquipListByPartner( 0) --更新后的角色身上装备list
    m_GemListData         =  _G.g_GameDataProxy:getGemstoneList()              --更新后的宝石表
    print("镶嵌更新的时候～～",m_EquipmentListData,m_GemListData)

    self:getView() : setReNewData_EquipmentList(m_EquipmentListData)

    self:getView() : setReNewData_GemList(m_GemListData)

    self:getView() : update(m_EquipmentListData)

    -- --self:getView() : CommandChange_MAKE_PEARL_INSET()
    -- if self.isOKToChange == 1 then
    --     self:getView() : CommandChange_MAKE_PEARL_INSET()
    --     self.isOKToChange = nil 
    -- end
    print("镶嵌提示拿到更新数据～～～")
end














