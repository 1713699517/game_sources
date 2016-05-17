require "mediator/mediator"
require "controller/BackpackCommand"
require "model/GameDataProxy"

require "common/MessageProtocol"

CGameDataMediator = class(mediator, function(self, _view)
    self.name = "CGameDataMediator"
    self.view = _view
    print("XXXXXXXXXXMediator:",self.name)
end)

function   CGameDataMediator.getView(self)
    return self.view
end

function CGameDataMediator.getName(self)
    return self.name
end

function CGameDataMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        --print("CGameDataMediator.processCommand\nACK.ACK.ACK.ACK.ACK.ACK:",_command :getProtocolID())
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        if msgID == _G.Protocol.ACK_GOODS_REMOVE                then  -- [2040]消失物品/装备 -- 物品/背包
            print("_G.Protocol.ACK_GOODS_REMOVE-->>>>>",_G.Protocol.ACK_GOODS_REMOVE)
            self :ACK_GOODS_REMOVE( ackMsg)
            local command = CProxyUpdataCommand( msgID)
            controller :sendCommand( command)
        elseif msgID == _G.Protocol.ACK_GOODS_REVERSE           then  -- [2020]请求返回数据 -- 物品/背包
            print("_G.Protocol.ACK_GOODS_REVERSE-->>>>>",_G.Protocol.ACK_GOODS_REVERSE)
            self :ACK_GOODS_REVERSE( ackMsg)
            local command = CProxyUpdataCommand( msgID)
            controller :sendCommand( command)
        elseif msgID == _G.Protocol.ACK_GOODS_EQUIP_BACK        then  -- (手动) -- [2240]请求角色装备信息 -- 物品/背包
            print("_G.Protocol.ACK_GOODS_EQUIP_BACK-->>>>>",_G.Protocol.ACK_GOODS_EQUIP_BACK)
            self :ACK_GOODS_EQUIP_BACK( ackMsg)
            local command = CProxyUpdataCommand( msgID)
            controller :sendCommand( command)
        elseif msgID == _G.Protocol.ACK_GOODS_ENLARGE_COST      then  -- (手动) -- [2227]扩充需要的道具数量 -- 物品/背包
            print("_G.Protocol.ACK_GOODS_ENLARGE_COST-->>>>>",_G.Protocol.ACK_GOODS_ENLARGE_COST)
            self :ACK_GOODS_ENLARGE_COST( ackMsg)
            local command = CProxyUpdataCommand( msgID)
            controller :sendCommand( command)
        elseif msgID == _G.Protocol.ACK_GOODS_ENLARGE           then  -- (手动) -- [2230]容器扩充成功 -- 物品/背包
            print("_G.Protocol.ACK_GOODS_ENLARGE-->>>>>",_G.Protocol.ACK_GOODS_ENLARGE)
            self :ACK_GOODS_ENLARGE( ackMsg)
            local command = CProxyUpdataCommand( msgID)
            controller :sendCommand( command)
        elseif msgID == _G.Protocol.ACK_GOODS_CHANGE            then  -- [2050]物品/装备属性变化 -- 物品/背包
            print("_G.Protocol.ACK_GOODS_CHANGE-->>>>>",_G.Protocol.ACK_GOODS_CHANGE)
            self :ACK_GOODS_CHANGE( ackMsg)
            local command = CProxyUpdataCommand( msgID)
            controller :sendCommand( command)
        elseif msgID == _G.Protocol.ACK_GOODS_SHOP_BACK         then  -- [2310]商店数据返回 -- 物品/背包
            print("_G.Protocol.ACK_GOODS_SHOP_BACK-->>>>>",_G.Protocol.ACK_GOODS_SHOP_BACK)
            self :ACK_GOODS_SHOP_BACK( ackMsg)
            local command = CProxyUpdataCommand( msgID)
            controller :sendCommand( command)
        elseif msgID == _G.Protocol.ACK_ROLE_CURRENCY           then  -- ［1022］各种货币
            -- print( "_G.Protocol.ACK_ROLE_CURRENCY-->>>>>",_G.Protocol.ACK_ROLE_CURRENCY)
            -- self :ACK_ROLE_CURRENCY( ackMsg)
            -- local command = CProxyUpdataCommand( msgID)
            -- controller :sendCommand( command)
        end
        --接收服务器消息更新ProxyData后发送更新界面的command
        ------------------------------------------------------
        --local command = CProxyUpdataCommand( msgID)
        --controller :sendCommand( command)
        
        if msgID == _G.Protocol["ACK_FRIEND_SYS_FRIEND"] then -- (手动) -- [4200]系统推荐好友 -- 好友
            print("系统好友推荐协议 msgID=",msgID)
            _G.g_GameDataProxy : setIsFriendRecommend( 0 )
            self : ACK_FRIEND_SYS_FRIEND( ackMsg )
            print("open 好友推荐面板")
        end
        
        --jun 2013.10.10
        if msgID == _G.Protocol["ACK_TEAM_INVITE_NOTICE"] then -- (手动) -- [3700]邀请好友返回 -- 组队系统

            print("邀请好友返回协议 msgID=",msgID)
            --_G.g_GameDataProxy : setIsInviteFriends( 0 )
            self : ACK_TEAM_INVITE_NOTICE( ackMsg )
            print("open 邀请好友小图标")
        end
    end

    return false
end
--[[
            R......E......Q
--]]
----------------------------------------------------------------------
--[[
            A......C......K
--]]
--好友推荐界面打开
function CGameDataMediator.ACK_FRIEND_SYS_FRIEND( self, _ackMsg )
    print("在主界面的CMainUIMediator 收到了好友推荐协议")
    local Count = _ackMsg : getCount()
    local data  = _ackMsg : getData()
    print("------>>>>>>>",Count,data,#data)
    
    for key, value in pairs( data) do
        print("datata",  key, value.fname)
    end
    if  Count ~= nil and Count > 0 then
        _G.g_GameDataProxy : setFriendRecommendData(data)
    end
    
    require "controller/RecommendFriendCommand"
    local command = CRecommendDataCommand( CRecommendDataCommand.OPEN )
    controller :sendCommand( command )
end

--jun 2013.10.10 推荐好友小图标打开打开
function CGameDataMediator.ACK_TEAM_INVITE_NOTICE( self, _ackMsg )

    print("在主界面的CMainUIMediator 收到了好友邀请协议")
    local data     = {}
    data.Type      = _ackMsg : getType()
    data.Uname     = _ackMsg : getUname()
    data.NameColor = _ackMsg : getNameColor()
    data.CopyId    = _ackMsg : getCopyId()
    data.TeamId    = _ackMsg : getTeamId()
    data.State     = 0    
    print("------>>>>>>>",data.Type,data.Uname,data.NameColor,data.CopyId,data.TeamId)

    --计算组队图标个数
    local alldata = {}
    alldata       =  _G.g_GameDataProxy : getInviteFriendsData()

    local no = tonumber(_G.g_GameDataProxy : getInviteFriendsIconCount()) 
    print("no拿到的值",no)
    local  isSameTeam = 0
    if no > 0 then
        for i=1,no do
            if alldata~= nil then
                if tonumber(alldata[i].TeamId) == tonumber(data.TeamId) then
                    isSameTeam =  1
                end
            end
        end
        if  isSameTeam == 1 then
            print("你妹居然有相同的")
        elseif isSameTeam == 0 then --没有相同的
            no = no + 1
            if no > 3 then 
                no = no%3
                _G.g_GameDataProxy : setInviteFriendsIconCount(3)
            else
                _G.g_GameDataProxy : setInviteFriendsIconCount(no)
            end
            alldata[no] = {}
            alldata[no] = data
            _G.g_GameDataProxy : setInviteFriendsData(alldata)
        end
    else
        no = no + 1
        _G.g_GameDataProxy : setInviteFriendsIconCount(no)
        alldata[no] = {}
        if data ~= nil then
            alldata[no] = data
             _G.g_GameDataProxy : setInviteFriendsData(alldata)
        end
    end

    require "controller/RecommendFriendCommand"
    local command = CRecommendDataCommand( CRecommendDataCommand.INVITE )
    controller :sendCommand( command )  
end


-- [2040]消失物品/装备 -- 物品/背包
function CGameDataMediator.ACK_GOODS_REMOVE( self, _ackMsg)
    local backpackType = _ackMsg :getType()
    local characterId  = _ackMsg :getId()
    local goodsCount   = _ackMsg :getCount()
    local goodsIndex   = _ackMsg :getIndex()
    print("######@ REMOVE: type:",backpackType,"id:",characterId,"count:",goodsCount," index:",goodsIndex)
    if _ackMsg :getType() == 1 then
        for i=1, _ackMsg :getCount() do
            local _index = _ackMsg :getIndex()[i]
            local i = 1
            --print( "CGameDataMediator.removeGoodByIndex", _index, table.maxn( _G.g_GameDataProxy :getBackpackList()))
            for i=1, table.maxn( _G.g_GameDataProxy :getBackpackList()) do
                print( i,_G.g_GameDataProxy :getBackpackList()[i].index)
                if _G.g_GameDataProxy :getBackpackList()[i] ~= nil then                    
                    if _G.g_GameDataProxy :getBackpackList()[i].index == _index then
                        table.remove( _G.g_GameDataProxy :getBackpackList(), i)
                        --print("DEL self.m_backpackgoodslist[*]", i)
                        local num = _G.g_GameDataProxy :getGoodsCount()
                        _G.g_GameDataProxy :setGoodsCount( num-1)
                        break
                    end
                end
            end
        end
        --
        self :splitBackpack()
    elseif _ackMsg :getType() == 2 then
        --add:
        local roleequiplist = _G.g_GameDataProxy :getRoleEquipListByPartner( _ackMsg :getId())
        for i=1, _ackMsg :getCount() do            
            local _index = _ackMsg :getIndex()[i]
            local i = 1
            --print( "CGameDataMediator.removeGoodByIndex", _index, table.maxn( _G.g_GameDataProxy :getBackpackList()))
            for i=1, table.maxn( roleequiplist) do
                print( i,roleequiplist[i].index)
                if roleequiplist[i] ~= nil then
                    if roleequiplist[i].index == _index then
                        table.remove( roleequiplist, i)
                        break
                    end
                end
            end
        end
        _G.g_GameDataProxy :setRoleEquipListByPartner( roleequiplist, _ackMsg :getId())
        --local command = CCharacterEquipInfoUpdataCommand( msgID)
        --controller :sendCommand( command)
    elseif _ackMsg :getType() == 3 then
        --add:
        for i=1, _ackMsg :getCount() do
            local _index = _ackMsg :getIndex()[i]
            print( "CGameDataMediator.removeGoodByIndex", index)
            for i=1, table.maxn( _G.g_GameDataProxy :getTemporaryBackpackList()) do
                if _G.g_GameDataProxy :getTemporaryBackpackList()[i] ~= nil then
                    if _G.g_GameDataProxy :getTemporaryBackpackList()[i].index == index then
                        table.remove( _G.g_GameDataProxy :getTemporaryBackpackList(), i)
                        --print("DEL self.m_backpackgoodslist[*]", i)
                        break
                    end
                end
            end

        end
    end                                                                    
    
end

-- [2020]请求返回数据 -- 物品/背包
function CGameDataMediator.ACK_GOODS_REVERSE( self, _ackMsg)
    if _ackMsg :getType() == 1 then --背包
        _G.g_GameDataProxy :setMaxCapacity( _ackMsg :getMaximum())
        _G.g_GameDataProxy :setGoodsCount( _ackMsg :getGoodsCount())
        _G.g_GameDataProxy :setBackpackList( _ackMsg :getGoodsMsgNo())
        --拆分
        self :splitBackpack()

    elseif _ackMsg :getType() == 2 then 
        --add:
    elseif _ackMsg :getType() == 3 then  --临时背包
        _G.g_GameDataProxy :setTemporaryBackpackList( _ackMsg :getGoodsMsgNo())
        --拆分
    end
end

-- (手动) -- [2227]扩充需要的道具数量 -- 物品/背包 
function CGameDataMediator.ACK_GOODS_ENLARGE_COST( self, _ackMsg)
    print("CGameDataMediator.ACK_GOODS_ENLARGE_COST")
    local goods_id  = _ackMsg :getGoodsId()
    local count     = _ackMsg :getCount()
    local enlargh_c = _ackMsg :getEnlarghC()    -- 已扩充次数
    print("goods_id:",goods_id,"count:",count,"enlargh_c",enlargh_c)
end

-- (手动) -- [2230]容器扩充成功 -- 物品/背包 
function CGameDataMediator.ACK_GOODS_ENLARGE( self, _ackMsg)
    print("CGameDataMediator.ACK_GOODS_ENLARGE")
    _G.g_GameDataProxy :setMaxCapacity( _ackMsg :getMax())
    print("max:",max)
end

-- [2242]角色装备信息返回 -- 物品/背包 
function CGameDataMediator.ACK_GOODS_EQUIP_BACK( self, _ackMsg)
    print("CGameDataMediator.ACK_GOODS_EQUIP_BACK")
    local uid      = _ackMsg :getUid()
    local partner  = _ackMsg :getPartner()
    local count    = _ackMsg :getCount()
    print("uid:",uid,"partner:",partner,"count",count)
    local msggroup = _ackMsg :getMsgGroup()
    _G.g_GameDataProxy :setRoleEquipListByPartner( _ackMsg :getMsgGroup(), _ackMsg :getPartner())
    --self :printGoods( msggroup)
end

-- [2050]物品/装备属性变化 -- 物品/背包 
function CGameDataMediator.ACK_GOODS_CHANGE( self, _ackMsg)
    local type     = _ackMsg :getType()
    local id       = _ackMsg :getId()
    local count    = _ackMsg :getCount()
    print("######@ CHANGE: type:",type,"id:",id,"count:",count)
    local goods_msg_no  = _ackMsg :getGoodsMsgNo()
    if _ackMsg :getType() == 1 then
        local backpacklist = _G.g_GameDataProxy :getBackpackList()
        for i=1, count do
            local temp = _G.g_GameDataProxy :getGoodsCount()  --背包物品数量
            print( i,"_G.g_GameDataProxy :getGoodsCount()",temp,goods_msg_no[i].is_data)
            if goods_msg_no[i].is_data then
                if temp == 0 then
                    table.insert( backpacklist, goods_msg_no[i])
                    _G.g_GameDataProxy :setGoodsCount( temp+1)
                end                    
                for j=1, temp do
                    print( j, temp, backpacklist[j].index, goods_msg_no[i].index)
                    if backpacklist[j].index == goods_msg_no[i].index then
                        backpacklist[j] = goods_msg_no[i]
                        break
                    end
                    if j == temp then
                        print("++++++++++++++++++++++++++++")
                        table.insert( backpacklist, goods_msg_no[i])
                        _G.g_GameDataProxy :setGoodsCount( temp+1)
                    end
                end

            end
        end 
        _G.g_GameDataProxy :setBackpackList( backpacklist)
        --拆分add: 
        self :splitBackpack()                                                            

    elseif _ackMsg :getType() == 2 then
        local roleequiplist = _G.g_GameDataProxy :getRoleEquipListByPartner( _ackMsg :getId())
        for i=1, _ackMsg :getCount() do
            local temp = #roleequiplist  --角色身上装备数量
            if goods_msg_no[i].is_data then
                if temp == 0 then
                    table.insert( roleequiplist, goods_msg_no[i])
                end
                for j=1, temp do
                    print( j, temp, roleequiplist[j].index, goods_msg_no[i].index)
                    if roleequiplist[j].index == goods_msg_no[i].index then
                        roleequiplist[j] = goods_msg_no[i]
                        break
                    end
                    if j == temp then
                        print("++++++++++++++++++++++++++++")
                        table.insert( roleequiplist, goods_msg_no[i])
                    end
                end
            end
        end
        _G.g_GameDataProxy :setRoleEquipListByPartner( roleequiplist, _ackMsg :getId())
        --local command = CCharacterEquipInfoUpdataCommand( msgID)
        --controller :sendCommand( command)
    elseif _ackMsg :getType() == 3 then
        local temporarybackpacklist = _G.g_GameDataProxy :getTemporaryBackpackList()
        for i=1, _ackMsg :getCount() do
            local temp =  table.maxn( temporarybackpacklist)
            if goods_msg_no[i].is_data then
                if temp == 0 then
                    table.insert( backpacklist, goods_msg_no[i])
                    _G.g_GameDataProxy :setGoodsCount( temp+1)
                end
                for j=1, temp do
                    if temporarybackpacklist[j].index == goods_msg_no[i].index then
                        temporarybackpacklist[j] = goods_msg_no[i]
                        break
                    end
                end
                if j == temp+1 then
                    table.insert( temporarybackpacklist, goods_msg_no[i])
                end
            end
        end 
        _G.g_GameDataProxy :setTemporaryBackpackList( temporarybackpacklist)
        --拆分add: 

    end
end

-- [2310]商店数据返回 -- 物品/背包 
function CGameDataMediator.ACK_GOODS_SHOP_BACK( self, _ackMsg)
    local price_type    = _ackMsg :getPrinceType()
    local count         = _ackMsg :getCount()
    local msggroup      = _ackMsg :getMsgxxx()

end

-- [1022]获得所有货币
function CGameDataMediator.ACK_ROLE_CURRENCY( self, _ackMsg)  
    local allcurrency = {}
    allcurrency.gold     = _ackMsg :getGold()
    allcurrency.rmb      = _ackMsg :getRmb()
    allcurrency.bind_rmb = _ackMsg :getBindRmb()
    print("gold:"..allcurrency.gold.."rmb:"..allcurrency.rmb.."bind_rmb:"..allcurrency.bind_rmb)
    _G.g_GameDataProxy :setAllCurrency( allcurrency)
end

--[[
        辅助function
--]]
--顺序
function CGameDataMediator.lessmark( good1, good2)
    if good1.goods_id == good2.goods_id then
        return good1.goods_num > good2.goods_num
    else
        return good1.goods_id > good2.goods_id
    end
end
--倒序
function CGameDataMediator.greatermark( good1, good2)
    if good1.goods_id == good2.goods_id then
        return good1.goods_num < good2.goods_num
    else 
        return good1.goods_id < good2.goods_id
    end
 end 
--先获得物品在前
function CGameDataMediator.lessmarktime( good1, good2)
    return  good1.time < good2.time
end

--后获得物品在前
function CGameDataMediator.greatermartime( good1, good2)
    return  good1.time > good2.time
end

function CGameDataMediator.sortBackpackList( self, _list)
    table.sort( _list, self.lessmark)
end

function CGameDataMediator.splitBackpack( self)
    local backpacklist = _G.g_GameDataProxy :getBackpackList()
    --------------------------------------------
-----------------------------------------------
    self :sortBackpackList( backpacklist)
    local equipmentlist = {}
    local equipandexplist = {}
    local gemstonelist = {}
    local materiallist = {}
    local propslist = {}
    local artifactlist = {}
    for k,v in pairs( backpacklist) do
        --_G.g_GameDataProxy :getGoodById( v.goods_id)
        if v.goods_type == 1 or v.goods_type == 2 then
            print("--装备更新")
            --装备更新
            table.insert( equipandexplist, v)
            table.insert( equipmentlist, v)
            table.insert( propslist, v)
        elseif v.goods_type == 3 then
            print("--宝石更新")
            --宝石更新
            table.insert( gemstonelist, v)
        elseif v.goods_type == 4 then
            print("--材料更新")
            --材料更新
            table.insert( materiallist, v)
        elseif v.goods_type == 5 then
            print("--神器")
            table.insert( artifactlist, v)
            table.insert( propslist, v)
        else
            print("--道具更新")
            --道具更新
            print("XXXXXXXXXX:",self :getGoodSubType(v.goods_id))
            if self :getGoodSubType(v.goods_id) == (_G.Constant.CONST_GOODS_COMMON_EXP) or self :getGoodSubType(v.goods_id)==_G.Constant.CONST_GOODS_COMMON_PAR_EXP then  --经验丹
                table.insert( equipandexplist, v)
            end
            table.insert( propslist, v)
        end
    end  
    _G.g_GameDataProxy :setEquipmentList( equipmentlist)
    _G.g_GameDataProxy :setEquipAndExpList( equipandexplist)
    _G.g_GameDataProxy :setGemstoneList( gemstonelist)
    _G.g_GameDataProxy :setMaterialList( materiallist)
    _G.g_GameDataProxy :setPropsList( propslist)
    _G.g_GameDataProxy :setArtifactList( artifactlist)
end

function CGameDataMediator.getGoodSubType( self, _goodsid)
    local goodnode = _G.g_GameDataProxy :getGoodById( tostring(_goodsid))
    if goodnode ~= nil then
        return tonumber(goodnode : getAttribute("type_sub"))
    end
    return nil    
end
