require "mediator/mediator"
--require "view/EquipEnchant/EquipEnchantView"

EquipEnchantMediator = class(mediator, function(self, _view)
                             self.name = "EquipEnchantMediator"
                             self.view = _view
                             end)

function EquipEnchantMediator.getView(self)
    return self.view
end

function EquipEnchantMediator.getName(self)
    return self.name
end

function EquipEnchantMediator.processCommand(self,_command)
    -- if _command:getType() == "TYPE_CEquipEnchantCommand" then
    --     print(">>>>>>>>>>>>>>>>>>>>>>>>>附魔页面发送消息给服务器1")
    --     if msgID == _G.Protocol["REQ_MAKE_PEARL_INSET"] then --发送装备附魔 XXXX
    --         print("发送装备附魔 XXXX")
    --         --self : REQ_MAKE_PEARL_INSET(otherData)
    --     end
    --     return true
    -- end

        --接受服务端发回附魔结果
    if _command:getType() == CNetworkCommand.TYPE then
        print("服务器发回数据给附魔页面<<<<<<<<<<<<<<<<<<<<<<")
        local msgID = _command:getProtocolID()
        print("ackMessage:getMsgID===",msgID)
        
        local ackMsg = _command:getAckMessage()
        -- if msgID == _G.Protocol["ACK_GOODS_CHANGE"] then --接收物品属性变化 2050
        --     print("物品属性变化，ackMessage:getMsgIDaa===",msgID)
        --     self : ACK_GOODS_CHANGE( ackMsg )
        -- end

        if msgID == _G.Protocol["ACK_MAKE_ENCHANT_OK"] then --- (手动) -- [2600]附魔成功 -- 物品/打造/强化 
            print("mdeiator 46 收到附魔成功协议")
            self : ACK_MAKE_ENCHANT_OK( ackMsg )
        end

        if msgID == _G.Protocol["ACK_MAKE_ENCHANT_PAY"] then -- (手动) -- [2620]附魔消耗 -- 物品/打造/强化 
            print("mdeiator  收到附魔消耗协议")
            self : ACK_MAKE_ENCHANT_PAY( ackMsg )
        end
    end
    
    if _command:getType() == CCharacterEquipInfoUpdataCommand.TYPE then  --更新界面显示
        print(">>>>>>>>背包数据改变，更新附魔界面<<<<<<<<<<")
        self : RENEW_ACK_GOODS_CHANGE( ackMsg )
    end

    return false
end


function EquipEnchantMediator.ACK_MAKE_ENCHANT_PAY( self, ackMessage )----[2620]附魔消耗 -- 物品/打造/强化 
    local Rmb = ackMessage : getRmb() --钻石消耗数量
    print("附魔消耗～～～",self,self:getView(),Rmb)
    self:getView():GetEnchantRmb(Rmb)
    print("提示拿到附魔消耗数据～～～")
end
--更新界面
function EquipEnchantMediator.ACK_MAKE_ENCHANT_OK(self, ackMessage)   -- (手动) -- [2600]附魔成功 -- 物品/打造/强化 
    local id   = ackMessage : getId() -- {主将0|武将ID}

    print("提示附魔成功111111111～～～",id)
    self:getView():NetWorkReturn_MAKE_ENCHANT_OK()
    print("提示拿到附魔更新数据～～～")
end

--更新界面
function EquipEnchantMediator.RENEW_ACK_GOODS_CHANGE(self, ackMessage)   --接收物品属性变化 2050
    print("xxxxxxx附魔提示")
    self:getView():pushData()
    print("xxxxxxx附魔提示拿到更新数据～～～") 
end


