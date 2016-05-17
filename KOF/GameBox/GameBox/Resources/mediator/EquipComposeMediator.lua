require "mediator/mediator"
require "common/protocol/auto/REQ_GOODS_REQUEST"
require "common/protocol/auto/ACK_MAKE_COMPOSE_OK"

require "controller/EquipComposeCommand"


EquipComposeMediator = class(mediator, function(self, _view)
                         self.name = "EquipComposeMediator"
                         self.view = _view
                         self.m_EquipmentListData={}
                         end)

function EquipComposeMediator.getView(self)
    return self.view
end

function EquipComposeMediator.getName(self)
    return self.name
end

function EquipComposeMediator.getUserName(self)
    return self.user_name
end

function EquipComposeMediator.processCommand(self,_command)
    print("_command==============",_command)
    print("getView()=============",self:getView())
    print("getType===============",_command:getType())
    print("getData1==============",_command:getData())
    --接受服务端发回镶嵌结果
    if _command:getType() == CNetworkCommand.TYPE then
        print("服务器发回数据给合成页面<<<<<<<<<<<<<<<<<<<<<<")
        local msgID = _command :getProtocolID()
        print("ackMessage:getMsgID===",msgID)        
        local ackMsg = _command:getAckMessage()

        if msgID == _G.Protocol["ACK_GOODS_CHANGE"] then --接收物品属性变化 2050
            print("物品属性变化，ackMessage:getMsgID===",msgID)
            self : ACK_GOODS_CHANGE( ackMsg )
        end
        if msgID == _G.Protocol["ACK_MAKE_COMPOSE_OK"] then -- [2552]灵珠合成成功 -- 物品/打造/强化
            print("妈的我居然合成成功了",msgID)
            self : ACK_MAKE_COMPOSE_OK( ackMsg )
        end 
        if msgID == _G.Protocol["ACK_SHOP_REQUEST_OK"] then --接受店铺面板成功协议返回 [34511]
            self : ACK_SHOP_REQUEST_OK( ackMsg )
        end   
        if msgID == _G.Protocol["ACK_SHOP_BUY_SUCC"] then  -- [34516]购买成功 -- 商城
            print("EquipComposeMediator 收到请求店铺面板成功协议,ackMessage:getMsgID===",msgID)
            self : ACK_SHOP_BUY_SUCC( ackMsg )
        end            
    end
    
    if _command:getType() == CEquipComposeCommand.TYPE then
        print("_command :getModel() :getEquipinitnum()")
        print("555d",self :getView())
        self :getView() :setEquipinitnum( _command :getModel() :getEquipinitnum())
        
    end
    
    if _command:getType() == CProxyUpdataCommand.TYPE then  --更新界面显示
        print(">>>>>>>>背包数据改变，更新宝石合成界面<<<<<<<<<<")
        self : RENEW_ACK_GOODS_CHANGE( ackMsg )
    end
    return false
end

function EquipComposeMediator.ACK_GOODS_CHANGE(self, ackMessage)  --接收物品属性变化 2050
    require "common/protocol/ACK_GOODS_CHANGE"
    print("原来是这样做 ，哈哈哈哈哈")
    self:getView() : update()
    print("提示宝石合成成功～～～")
end
--更新界面
function EquipComposeMediator.RENEW_ACK_GOODS_CHANGE(self, ackMessage)   --接收物品属性变化 2050
    print("EquipComposeMediator.RENEW_ACK_GOODS_CHANGE",self)
    m_EquipmentListData     = _G.g_GameDataProxy:getEquipmentList() --更新后的道具表
    m_GemListData           = _G.g_GameDataProxy:getGemstoneList() --更新后的宝石表
    m_GoldData              = _G.g_GameDataProxy:getGold() --更新后的背包金币
    m_MaterialListData      =  _G.g_GameDataProxy : getMaterialList()  --材料列表
    print("更新的时候～～",m_EquipmentListData,m_GemListData,m_GoldData)
    self:getView() : setReNewData_MaterialList(m_MaterialListData)
    self:getView() : setReNewData_GemList(m_GemListData)
   
    self:getView() : update()
    print("提示拿到更新数据～～～")
end

function EquipComposeMediator.ACK_MAKE_COMPOSE_OK(self, ackMessage)  --接收物品属性变化 2050
    self:getView() : NetWorkReturn_MAKE_COMPOSE_OK()
end

function EquipComposeMediator.ACK_SHOP_REQUEST_OK(self, ackMsg)   --接受到招财面板返回 32020

    print("CShopLayerMediator进入到商店面板协议处理方法")
    --self:getView() : setReNewData_EquipmentList(m_EquipmentListData)
    local Type    = ackMsg : getType()
    local TypeBb  = ackMsg : getTypeBb()
    local Count   = ackMsg : getCount()
    local Msg     = ackMsg : getMsg()
    local EndTime = ackMsg : getEndTime()

    self:getView() : NetWorkReturn_SHOP_REQUEST_OK(Msg,Count,TypeBb,Type)
    print("CShopLayerMediator商店面板协议处理方法处理完毕～～")
end

function EquipComposeMediator.ACK_SHOP_BUY_SUCC(self, ackMsg)   --接受到招财面板返回 32020
    self:getView() : NetWorkReturn_SHOP_BUY_SUCC()
end









