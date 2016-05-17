require "mediator/mediator"
require "controller/BackpackCommand"
require "controller/GameDataProxyCommand"
require "model/VO_BackpackModle"

require "common/MessageProtocol"

CBackpackMediator = class(mediator, function(self, _view)
    self.name = "BackpackMediator"
    self.view = _view
    CCLOG("Mediator:",self.name)
end)

function CBackpackMediator.getView(self)
    return self.view
end

function CBackpackMediator.getName(self)
    return self.name
end

function CBackpackMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        --print("CBackpackMediator.processCommand\nACK.ACK.ACK.ACK.ACK.ACK:",_command :getProtocolID())
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_GOODS_SELL_OK        then
            print( "出售成功")
        elseif(msgID == _G.Protocol["ACK_INN_LIST"] )   then             -- (手动) -- [31120]伙伴列表 -- 客栈 
            self :ACK_INN_LIST( ackMsg)
        elseif(msgID == _G.Protocol["ACK_INN_RES_PARTNER"] )   then  -- (手动) -- [31270]离队/归队结果 -- 客栈  -- {1:归队成功0:离队成功}
            print( "-- (手动) -- [31270]离队/归队结果 -- 客栈 ")
            self :ACK_INN_RES_PARTNER( ackMsg)
        end
    end
     
    --接收缓存Proxyupdata的更新command

    if _command:getType() == CProxyUpdataCommand.TYPE then
        print("CProxyUpdataCommand.TYPE",CProxyUpdataCommand.TYPE)
        --self :getView() :setBackpackInfo()
    end

    --接收自己客户端
    return false
end
-------------------------------------------------------------
--[[
            A......C......K
--]]
--------------------------------------------------------------------
--酒吧伙伴属性请求，因伙伴卡问题将酒吧相关代码转移至此
-- (手动) -- [31120]伙伴列表 -- 客栈 
function CBackpackMediator.ACK_INN_LIST( self, _ackMsg)
    local partnerstatecount  = _ackMsg :getCount()
    self.m_partnerstatelist   = _ackMsg :getData()
    --self.m_renown            = _ackMsg :getRenown()
    for k,v in pairs( self.m_partnerstatelist) do
        print("%%%%%%%%%1 ",k,v.stata,v.partner_id)
        print(k,v.stata,v.partner_id)
        if v.stata == 2 then
            self :requestPartnerInfo( v.partner_id)
        end
    end
end

-- (手动) -- [31270]离队/归队结果 -- 客栈  -- {1:归队成功0:离队成功}
function CBackpackMediator.ACK_INN_RES_PARTNER( self, _ackMsg)
    local _type      = _ackMsg :getType()
    local _partnerid =  _ackMsg :getPartnerId()
    local mainplay   = _G.g_characterProperty :getMainPlay()
    local rolelv     = mainplay :getLv()     --玩家等级
    local rolepartnercount = mainplay :getCount()  -- 伙伴数量
    local rolepartnerlist  = mainplay :getPartner()
    print("rolelv:"..rolelv)
    _G.Config:load("config/partner_lv.xml")
    local lvchild  = _G.Config.partner_lvs : selectSingleNode("partner_lv[@lv="..tostring(rolelv).."]")
    local allchild = lvchild : children()
    local tempnode = allchild :get(0,"a")
    local partnermaxcount = tonumber(tempnode : getAttribute("carry_count"))
    print("%%%%%%%%%2 ",_type,_partnerid)
    if _type == 4 and rolepartnercount < partnermaxcount then
        print("MMMM:0")
        --更新缓存伙伴数量，和数量列表，请求伙伴属性
        --更新缓存的伙伴数量和伙伴ID列表        
        table.insert( rolepartnerlist, _partnerid )
        mainplay : setPartner( rolepartnerlist)
        mainplay : setCount( mainplay :getCount()+1)
        self :requestPartnerInfo( _partnerid)
    end 
end

function CBackpackMediator.requestPartnerInfo( self, _partnerid)
    --请求伙伴属性
    local msg = REQ_ROLE_PROPERTY()
    msg: setSid( _G.g_LoginInfoProxy :getServerId() )
    msg: setUid( _G.g_LoginInfoProxy :getUid() )
    msg: setType( _partnerid)
    _G.CNetwork : send( msg)
    --请求伙伴身上装备 
    msg = REQ_GOODS_EQUIP_ASK()
    msg :setUid( _G.g_LoginInfoProxy :getUid())
    msg :setPartner( _partnerid)
    _G.CNetwork :send( msg)
end

--输出[2001]物品信息
--测试数据使用
------------------------------------------------------
