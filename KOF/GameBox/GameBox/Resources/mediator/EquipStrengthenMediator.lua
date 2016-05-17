require "mediator/mediator"

require "controller/GuideCommand"

CEquipStrengthenMediator = class(mediator, function(self, _view)
    self.name = "EquipStrengthenMediator"
    self.view = _view
    self.m_EquipmentListData = {}
end)

function CEquipStrengthenMediator.getView(self)
    return self.view
end

function CEquipStrengthenMediator.getName(self)
    return self.name
end

function CEquipStrengthenMediator.getUserName(self)
    return self.user_name
end

function CEquipStrengthenMediator.processCommand(self,_command)

    --接受服务端发回强化结果
    if _command:getType() == CNetworkCommand.TYPE then
        print("服务器发回数据给强化页面<<<<<<<<<<<<<<<<<<<<<<")
        local msgID = _command :getProtocolID()
        print("ackMessage:getMsgID===",msgID)        
        local ackMsg = _command:getAckMessage()
        if msgID == _G.Protocol["ACK_GOODS_CHANGE"] then --接收物品属性变化 2050
            print("物品属性变化，ackMessage:getMsgIDaa===",msgID,i)
            --self : ACK_GOODS_CHANGE( ackMsg )
        end

        if msgID == _G.Protocol["ACK_MAKE_STRENGTHEN_OK"] then --接收强化成功信息 2520
            print("物品属性变化，ackMessage:getMsgID===",msgID,"falg==",ackMsg : getFalg())
            local ackMsg = _command :getAckMessage()

            self : ACK_MAKE_STRENGTHEN_OK( ackMsg )
            print("服务器发来贺电，强化成功")
        end

        if msgID == _G.Protocol["ACK_MAKE_STREN_MAX"] then --不可强化或已达最高级 2519
            --print("不可强化或已达最高级:getMsgID===",msgID,"falg==",ackMsg : getFalg())
            self : ACK_MAKE_STREN_MAX( ackMsg )
            print("不可强化或已达最高级")
        end  

        if msgID == _G.Protocol["ACK_MAKE_STREN_DATA_BACK"] then -- [2517]下一级装备强化数据返回 -- 物品/打造/强化
            self : ACK_MAKE_STREN_DATA_BACK( ackMsg )
        end  
        
    end  
    if _command:getType() == CCharacterEquipInfoUpdataCommand.TYPE then  --更新界面显示
        print(">>>>>>>>背包数据改变，更新强化界面1211111<<<<<<<<<<",self)
        self : RENEW_ACK_GOODS_CHANGE( ackMsg )
    end
    return false
end

-- function CEquipStrengthenMediator.ACK_GOODS_CHANGE(self, ackMessage)  --接收物品属性变化 2050
--     require "common/protocol/ACK_GOODS_CHANGE"
--     print("提示强化成功～～～")
-- end

function CEquipStrengthenMediator.ACK_MAKE_STREN_MAX(self, ackMessage)  --接收物品属性变化 2519
    self:getView() : NetWorkReturn_MAKE_STREN_MAX()
end

function CEquipStrengthenMediator.ACK_MAKE_STRENGTHEN_OK(self, ackMessage)  ---接收强化成功信息 2520
    local id       = ackMessage : getId() -- {主将0|武将ID}
    self.partnerId =tonumber(id)
    local falg = ackMessage : getFalg() --1成功，0失败
    print("falg1=",falg)
    print("提示强化成功111111111～～～",id)
    self:getView():NetWorkReturn_MAKE_STRENGTHEN_OK()
    print("提示拿到附魔更新数据～～～")
end

--更新界面
function CEquipStrengthenMediator.RENEW_ACK_GOODS_CHANGE(self, ackMessage)   --接收物品属性变化 2050
    print("xxxxxxx提示")
    self:getView():pushData()
    print("xxxxxxx提示拿到更新数据～～～")
   
end

function CEquipStrengthenMediator.ACK_MAKE_STREN_DATA_BACK(self, ackMessage)  ---接收强化成功信息 2520
    local Ref       = ackMessage : getRef()      -- {标识}
    local GoodsId   = ackMessage : getGoodsId()  -- {物品ID}
    local Lv        = ackMessage : getLv()       -- {物品等级}
    local Color     = ackMessage : getColor()    -- {物品颜色}
    local CostCoin  = ackMessage : getCostCoin() -- {消耗银元}
    local Count     = tonumber(ackMessage : getCount())     -- {属性数量}
    local Msg       = ackMessage : getMsg()      -- {信息块2518}
    Msg = self : exchangeDataTable(Msg,Count)

    self:getView():NetWorkReturn_MAKE_STREN_DATA_BACK(Ref,GoodsId,Lv,Color,CostCoin,Count,Msg)
    print("提示拿到强化下一级的更新数据～～～")
end


function CEquipStrengthenMediator.exchangeDataTable(self,_listdata,_Count)
    print("交互一下",_listdata,_Count)
    local temp = {}
    if _listdata ~= nil then
        for i=1,_Count do
            for j=1,_Count-i do
                if tonumber(_listdata[j+1].type)  < tonumber(_listdata[j].type) then
                    temp = _listdata[j+1]
                    _listdata[j+1] =  _listdata[j]
                    _listdata[j]   = temp
                    print("交互完毕")
                end
            end
        end
    end
    return _listdata
end
