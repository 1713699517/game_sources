require "mediator/mediator"
require "controller/StageREQCommand"
require "controller/CharacterUpadteCommand"
require "controller/CharacterPorpertyACKCommand"
require "mediator/GameDataMediator"

require "controller/MoneyCommand"
require "common/protocol/auto/REQ_ROLE_ENERGY"
require "common/protocol/auto/REQ_ROLE_VIP_MY"
require "common/protocol/auto/REQ_ROLE_PROPERTY"
require "common/protocol/auto/REQ_GOODS_EQUIP_ASK"
require "common/protocol/auto/REQ_GOODS_REQUEST"

require "common/protocol/auto/ACK_ROLE_BUFF_ENERGY"

------------------
require "common/protocol/auto/REQ_SKILL_REQUEST"
require "common/protocol/REQ_SKILL_PARTNER"
require "common/protocol/ACK_SKILL_PARENTINFO"
require "model/VO_SkillModel"


CCharacterPropertyMediator = class(mediator, function(self, _view)
    self.name = "CharacterPropertyMediator"
    self.view = _view
    self.readxml = nil
end)




function CCharacterPropertyMediator.processCommand(self, _command)
    print("CCharacterPropertyMediator.processCommand"  )
	if _command:getType() == CNetworkCommand.TYPE then
        local msgID = _command:getProtocolID()
        local ackMsg = _command:getAckMessage()

        print("Mediatordddd.processCommand",  msgID )

        if msgID == _G.Protocol["ACK_ROLE_CURRENCY"] then -- {[1022]货币 -- 角色 }
            self : ACK_ROLE_CURRENCY( ackMsg )
        elseif msgID == _G.Protocol["ACK_ROLE_ENERGY_OK"] then -- [1261]请求体力值成功 -- 角色
            print("[1261]请求体力值成功 -- 角色[1261]请求体力值成功 -- 角色", msgID)
        	self : ACK_ROLE_ENERGY_OK( ackMsg )
        elseif msgID == _G.Protocol["ACK_ROLE_LV_MY"] then -- [1311]请求vip回复 -- 角色
        	self : ACK_ROLE_LV_MY( ackMsg )
        elseif msgID == _G.Protocol["ACK_ROLE_PROPERTY_REVE"] then -- [1108]玩家属性 -- 角色
            self : ACK_ROLE_PROPERTY_REVE( ackMsg )
        elseif msgID == _G.Protocol["ACK_ROLE_PARTNER_DATA"] then -- [1109]伙伴属性 -- 角色
            self : ACK_ROLE_PARTNER_DATA( ackMsg )
        elseif msgID == _G.Protocol["ACK_ROLE_PROPERTY_UPDATE"] or msgID == _G.Protocol["ACK_ROLE_PROPERTY_UPDATE2"] then -- [1130]玩家单个属性更新 -- 角色 --1131
            self : ACK_ROLE_PROPERTY_UPDATE( ackMsg )
            local command = CCharacterInfoUpdataCommand( msgID)
            controller :sendCommand( command)
        elseif(msgID ==_G.Protocol["ACK_GOODS_EQUIP_BACK"] ) then    --  2242角色装备信息返回
            self :ACK_GOODS_EQUIP_BACK( ackMsg)
        elseif(msgID ==_G.Protocol["ACK_GOODS_REMOVE"] ) then    --- [2040]消失物品/装备 -- 物品/背包
            self :ACK_GOODS_REMOVE( ackMsg)
        elseif(msgID ==_G.Protocol["ACK_GOODS_CHANGE"] ) then    -- [2050]物品/装备属性变化 -- 物品/背包
            self :ACK_GOODS_CHANGE( ackMsg)
        elseif( msgID == _G.Protocol["ACK_SKILL_INFO"] ) then                 -- [6530]技能信息 -- 技能系统
            self :ACK_SKILL_INFO( ackMsg)
        elseif( msgID == _G.Protocol["ACK_SKILL_EQUIP_INFO"] ) then           -- [6545]返回装备技能信息 -- 技能系统
            self :ACK_SKILL_EQUIP_INFO( ackMsg)
        elseif( msgID == _G.Protocol["ACK_SKILL_PARENTINFO"] ) then           -- [6560]伙伴技能信息 -- 技能系统
            self :ACK_SKILL_PARENTINFO( ackMsg)

        elseif( msgID == _G.Protocol["ACK_ROLE_BUFF_ENERGY"] ) then
            self :ACK_ROLE_BUFF_ENERGY( ackMsg)
        end
	--elseif _command : getType() == CCharacterProperty.TYPE then

	end

	return false
end
--[[
                    A           C           K
]]
--  2242角色装备信息返回
function CCharacterPropertyMediator.ACK_GOODS_EQUIP_BACK( self, _ackMsg )
    -- body
    print( "得到玩家装备")
    local uid        = _ackMsg :getUid()     --玩家UID
    local partner_id = _ackMsg :getPartner() --伙伴ID
    local roleProperty = nil
    if partner_id == 0 then
        if _G.g_LoginInfoProxy :getUid() == uid then
            --玩家自己
            roleProperty = _G.g_characterProperty : getMainPlay()
        else
            --其他玩家
            roleProperty = _G.g_characterProperty : getOneByUid( uid, _G.Constant.CONST_PLAYER)
            if roleProperty == nil then
                roleProperty = CCharacterProperty()
                roleProperty : setUid( uid )
                _G.g_characterProperty : addOne( roleProperty, _G.Constant.CONST_PLAYER )
            end
        end
        print("««««««««««««««««««««««««««««««")
        local normalEquipList   = {}
        local artifactEquipList = {}
        for i,v in ipairs( _ackMsg : getMsgGroup() ) do
            print(i,v.goods_type,"inde="..v.index)
            if v.goods_type == 1 or v.goods_type == 2 then
                table.insert(normalEquipList,v)
            elseif v.goods_type == 5 then
                table.insert(artifactEquipList,v)
            end
        end
        print("««««««««««««««««««««««««««««««")
        print(#normalEquipList,#artifactEquipList)

        print("««««««««««««««««««««««««««««««")
        roleProperty : setEquipCount( #normalEquipList )
        roleProperty : setEquipList( normalEquipList )

        --print("errrror",  debug.traceback(), roleProperty)
        roleProperty : setArtifactEquipCount( #artifactEquipList )
        roleProperty : setArtifactEquipList( artifactEquipList )

    else
        --伙伴 索引为uid..id
        local index = tostring( uid)..tostring( partner_id)
        roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        if roleProperty == nil then
            roleProperty = CCharacterProperty()
            roleProperty : setUid( uid )
            roleProperty : setPartner( partner_id )
            local partnerinfo = self :getPartnerInfo( partner_id)
            roleProperty : updateProperty( _G.Constant.CONST_ATTR_NAME,  partnerinfo:getAttribute("partner_name"))
            roleProperty : updateProperty( _G.Constant.CONST_ATTR_NAME_COLOR,  partnerinfo:getAttribute("name_colour"))
            _G.g_characterProperty : addOne( roleProperty, _G.Constant.CONST_PARTNER )
        end

        print("æææææææææææææææææææææææææææ")

        local normalEquipList   = {}
        local artifactEquipList = {}
        for i,v in ipairs( _ackMsg : getMsgGroup() ) do
            if v.goods_type == 1 or v.goods_type == 2 then
                table.insert(normalEquipList,v)
            elseif v.goods_type == 5 then
                table.insert(artifactEquipList,v)
            end
        end

        print("æææææææææææææææææææææææææææ")
        print(#normalEquipList,#artifactEquipList)

        print("æææææææææææææææææææææææææææ")

        roleProperty : setEquipCount( #normalEquipList )
        roleProperty : setEquipList( normalEquipList )

        roleProperty : setArtifactEquipCount( #artifactEquipList )
        roleProperty : setArtifactEquipList( artifactEquipList )
    end
    print("$$$$$$$:",uid,partner_id,"装备数量:",roleProperty :getEquipCount())
    for k,v in pairs( roleProperty :getEquipList()) do
        print(k,v)
    end
end

-- [2040]消失物品/装备 -- 物品/背包
function CCharacterPropertyMediator.ACK_GOODS_REMOVE( self, _ackMsg)
    print( "人物装备消失")
    local backpackType = _ackMsg :getType()
    local characterId  = _ackMsg :getId()
    local goodsCount   = _ackMsg :getCount()
    local goodsIndex   = _ackMsg :getIndex()
    local roleequipcount = nil
    local roleequiplist  = nil
    local roleArtifactEquipCount = nil
    local roleArtifactEquipList  = nil
    local roleProperty   = nil
    if characterId == 0 then
        print("--玩家自己")--玩家自己
        roleProperty = _G.g_characterProperty : getMainPlay()
        roleequipcount = roleProperty : getEquipCount()
        roleequiplist  = roleProperty : getEquipList()

        roleArtifactEquipCount = roleProperty : getArtifactEquipCount()
        roleArtifactEquipList  = roleProperty : getArtifactEquipList()
    else
        --伙伴 索引为uid..id
        local index = tostring( _G.g_LoginInfoProxy :getUid())..tostring( characterId)
        print("--伙伴 索引为uid..id:"..index)
        roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        if roleProperty == nil then
            print( "没有对应伙伴")
            return
        end
        roleequipcount = roleProperty : getEquipCount()
        roleequiplist  = roleProperty : getEquipList()

        roleArtifactEquipCount = roleProperty : getArtifactEquipCount()
        roleArtifactEquipList  = roleProperty : getArtifactEquipList()
    end
    print("%%%%%%%%:",roleequipcount)
    for k,v in pairs( roleequiplist) do
        print(k,v)
    end
    if backpackType == 1 then
    elseif backpackType == 2 then  --角色身上
        --add:
        for i=1, goodsCount do
            local _index = goodsIndex[i]
            local i = 1
            local isGonOn = true
            for i=1, table.maxn( roleequiplist) do
                print( i,roleequiplist[i].index)
                if roleequiplist[i] ~= nil then
                    if roleequiplist[i].index == _index then
                        table.remove( roleequiplist, i)
                        roleequipcount = roleequipcount - 1
                        isGonOn = false
                        break
                    end
                end
            end

            if isGonOn then
                for i=1, table.maxn(roleArtifactEquipList) do
                    if roleArtifactEquipList[i] ~= nil then
                        if roleArtifactEquipList[i].index == _index then
                            table.remove( roleArtifactEquipList, i)
                            roleArtifactEquipCount = roleArtifactEquipCount - 1
                            isGonOn = false
                            break
                        end
                    end
                end
            end

        end
        roleProperty : setEquipCount( roleequipcount)
        roleProperty : setEquipList( roleequiplist)

        roleProperty : setArtifactEquipCount( roleArtifactEquipCount)
        roleProperty : setArtifactEquipList( roleArtifactEquipList)

        local command = CCharacterEquipInfoUpdataCommand( msgID)
        controller :sendCommand( command)
    elseif backpackType == 3 then
    end
end

-- [2050]物品/装备属性变化 -- 物品/背包
function CCharacterPropertyMediator.ACK_GOODS_CHANGE( self, _ackMsg)
    print( "人物装备改变")
    local backpackType     = _ackMsg :getType()
    local characterId      = _ackMsg :getId()
    local goodsCount       = _ackMsg :getCount()
    local goodsData        = _ackMsg :getGoodsMsgNo()
    local roleequipcount = nil
    local roleequiplist  = nil
    local roleArtifactEquipCount = nil
    local roleArtifactEquipList  = nil
    local roleProperty   = nil
    if characterId == 0 then
        --玩家自己
        roleProperty = _G.g_characterProperty : getMainPlay()
        if roleProperty == nil then
            local uid = tonumber(_G.g_LoginInfoProxy : getUid())

            _G.g_characterProperty : initMainPlay(uid)
            roleProperty = _G.g_characterProperty : getMainPlay()
        end
        roleequipcount = roleProperty : getEquipCount()
        roleequiplist  = roleProperty : getEquipList()

        roleArtifactEquipCount = roleProperty : getArtifactEquipCount()
        roleArtifactEquipList  = roleProperty : getArtifactEquipList()
    else
        --伙伴 索引为uid..id
        local index = tostring( _G.g_LoginInfoProxy :getUid())..tostring( characterId)
        roleProperty = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        if roleProperty == nil then
            print( "没有对应伙伴")
            return
        end
        roleequipcount = roleProperty : getEquipCount()
        roleequiplist  = roleProperty : getEquipList()

        roleArtifactEquipCount = roleProperty : getArtifactEquipCount()
        roleArtifactEquipList  = roleProperty : getArtifactEquipList()
    end

    if backpackType == 1 then
    elseif backpackType == 2 then
        for i=1, goodsCount do

            if goodsData[i].is_data then

                if goodsData[i].goods_type == 1 or goodsData[i].goods_type == 2 then
                    local temp = roleequipcount  --角色身上装备数量
                    if temp == 0 then  --角色身上无装备，直接插入
                        table.insert( roleequiplist, goodsData[i])
                        roleequipcount = roleequipcount + 1
                    end
                    for j=1, temp do
                        print( j, temp, roleequiplist[j].index, goodsData[i].index)
                        if roleequiplist[j].index == goodsData[i].index then --角色身上有装备，索引相等就替换
                            roleequiplist[j] = goodsData[i]
                            break
                        end
                        if j == temp then --角色身上有装备，没有索引相等，插入
                            table.insert( roleequiplist, goodsData[i])
                            roleequipcount = roleequipcount + 1
                        end
                    end
                elseif goodsData[i].goods_type == 5 then
                    local temp = roleArtifactEquipCount  --角色身上装备数量
                    if temp == 0 then  --角色身上无装备，直接插入
                        table.insert( roleArtifactEquipList, goodsData[i])
                        roleArtifactEquipCount = roleArtifactEquipCount + 1
                    end
                    for j=1, temp do
                        print( j, temp, roleArtifactEquipList[j].index, goodsData[i].index)
                        if roleArtifactEquipList[j].index == goodsData[i].index then --角色身上有装备，索引相等就替换
                            roleArtifactEquipList[j] = goodsData[i]
                            break
                        end
                        if j == temp then --角色身上有装备，没有索引相等，插入
                            table.insert( roleArtifactEquipList, goodsData[i])
                            roleArtifactEquipCount = roleArtifactEquipCount + 1
                        end
                    end
                end
            end
        end
        roleProperty : setEquipCount( roleequipcount)
        roleProperty : setEquipList( roleequiplist)

        roleProperty : setArtifactEquipCount( roleArtifactEquipCount)
        roleProperty : setArtifactEquipList( roleArtifactEquipList)

        local command = CCharacterEquipInfoUpdataCommand( msgID)
        controller :sendCommand( command)
    elseif backpackType == 3 then
    end
end


-- {[1022]货币 -- 角色 }
function CCharacterPropertyMediator.ACK_ROLE_CURRENCY( self, _ackMsg )
    CCLOG("得到货币")
	local mainProperty = _G.g_characterProperty : getMainPlay()
	mainProperty : setGold( _ackMsg : getGold() )
	mainProperty : setRmb( _ackMsg : getRmb() )
	mainProperty : setBindRmb( _ackMsg : getBindRmb())

    -- if _G.g_Stage : isInit() == false then
    -- 	CCLOG("请求体力开始")
    --     local msg = REQ_ROLE_ENERGY()
    --     _G.CNetwork : send( msg )
    --     CCLOG("请求体力结束")
    -- end
    CCLOG("请求修改货币开始")
    local comm = CMoneyChangedCommand( CMoneyChangedCommand.MONEY)
    controller :sendCommand( comm )
    CCLOG("请求修改货币结束")

end

-- [1261]请求体力值成功 -- 角色
function CCharacterPropertyMediator.ACK_ROLE_ENERGY_OK( self, _ackMsg )
    CCLOG("得到体力 : ".._ackMsg : getSum() .. "  ," .._ackMsg : getMax())
	local mainProperty = _G.g_characterProperty : getMainPlay()
    if mainProperty == nil then
        print("没有找到主角3")
        _G.g_characterProperty : initMainPlay( tonumber(_G.g_LoginInfoProxy : getUid()) )
        mainProperty = _G.g_characterProperty : getMainPlay()
    end
	mainProperty : setSum( _ackMsg : getSum() )
	mainProperty : setMax( _ackMsg : getMax() )

    if _G.g_Stage : isInit() == false then
        -- [1310]请求VIP(自己) -- 角色
        CCLOG("请求VIP开始")
        local msg = REQ_ROLE_VIP_MY()
        _G.CNetwork : send( msg )
        CCLOG("请求VIP结束")
    end
end

--08.23 add
-- [1262]额外赠送精力 -- 角色
function CCharacterPropertyMediator.ACK_ROLE_BUFF_ENERGY( self, _ackMsg)
    CCLOG("得到额外赠送精力 ".._ackMsg :getBuffValue())
    local mainProperty = _G.g_characterProperty : getMainPlay()
    if mainProperty == nil then
        _G.g_characterProperty : initMainPlay( tonumber(_G.g_LoginInfoProxy : getUid()) )
        mainProperty = _G.g_characterProperty : getMainPlay()
    end
    mainProperty :setBuffValue( _ackMsg : getBuffValue() )

    CCLOG("请求修改货币开始")
    local comm = CMoneyChangedCommand( CMoneyChangedCommand.ENERGY)
    controller :sendCommand( comm)
    CCLOG("请求修改货币结束")

end
--08.23 end

-- [1311]请求vip回复 -- 角色
function CCharacterPropertyMediator.ACK_ROLE_LV_MY( self, _ackMsg )
    CCLOG("得到VIP:".._ackMsg : getLv().."   ,".._ackMsg : getVipUp())
	local mainProperty = _G.g_characterProperty : getMainPlay()
	mainProperty : setVipLv( _ackMsg : getLv() )
	mainProperty : setVipUp( _ackMsg : getVipUp() )
    --告诉StageMediator进入场景
    if _G.g_Stage : isInit() == false then
        -- [1101]请求玩家属性 -- 角色 本玩家
        CCLOG("请求玩家属性开始")
        local msg_role = REQ_ROLE_PROPERTY()
        msg_role: setSid( _G.g_LoginInfoProxy :getServerId() )
        msg_role: setUid( _G.g_LoginInfoProxy :getUid() )
        msg_role: setType( 0 )
        _G.CNetwork : send( msg_role )
        CCLOG("请求玩家属性结束")

        if _G.g_LoginInfoProxy:getFirstLogin() == false then
            CCLOG("请求开启进入场景开始")
            local tempCommand = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER"])
            tempCommand : setOtherData({mapID = 0})
            controller: sendCommand(tempCommand)
            CCLOG("请求开启进入场景结束")
        end

        ----[[
        --请求玩家身上装备 --本玩家
        CCLOG("请求玩家身上装备开始")--有错
        local msg_goods = REQ_GOODS_EQUIP_ASK()
        msg_goods :setUid( _G.g_LoginInfoProxy :getUid())
        msg_goods :setPartner( 0)
        _G.CNetwork :send( msg_goods)
        CCLOG("请求玩家身上装备结束")--未到达

        --require "mediator/GameDataMediator"
        --注册背包缓存mediator
        --self.m_mediator = CGameDataMediator( self)
        --controller :registerMediator( self.m_mediator)

        --require "common/protocol/auto/REQ_GOODS_REQUEST"
        --请求背包信息
        CCLOG("请求背包信息开始")
        local msg_goods_request = REQ_GOODS_REQUEST()
        msg_goods_request :setType( 1)   --1:背包    2:装备    3:临时背包
        msg_goods_request :setSid( _G.g_LoginInfoProxy:getServerId())
        msg_goods_request :setUid( _G.g_LoginInfoProxy:getUid())
        CNetwork :send( msg_goods_request)
        CCLOG("请求背包信息结束")

        --require "
        --请求技能信息  --角色自己
        CCLOG("请求技能信息开始")
        local msg_skill = REQ_SKILL_REQUEST()
        CNetwork :send( msg_skill)
        CCLOG("请求技能信息结束")
        --]]
    end
    print("f321")
    if _G.g_Stage ~= nil and _G.g_Stage : getPlay() ~= nil then
        print("f456")
        local szName = _G.g_Stage : getPlay() : getName()
        _G.g_Stage : getPlay() : setName( szName )
    end
end


function CCharacterPropertyMediator.ACK_ROLE_PROPERTY_REVE( self, _ackMsg )
    print("得到玩家属性UID:",_ackMsg : getUid())
    local uid = _ackMsg : getUid()
    local property = _G.g_characterProperty : getOneByUid( uid, _G.Constant.CONST_PLAYER )
    if property == nil then
        property = CCharacterProperty()
        property : setUid( uid )
        _G.g_characterProperty : addOne( property, _G.Constant.CONST_PLAYER )
    end

    property : updateProperty( _G.Constant.CONST_ATTR_NAME,  _ackMsg : getName() )
    property : updateProperty( _G.Constant.CONST_ATTR_NAME_COLOR,  _ackMsg : getNameColor() )
    property : setRenown( _ackMsg : getRenown())
    property : setPro( _ackMsg : getPro() )
    property : setSex( _ackMsg : getSex() )
    property : updateProperty( _G.Constant.CONST_ATTR_LV,  _ackMsg : getLv() )
    property : updateProperty( _G.Constant.CONST_ATTR_RANK,  _ackMsg : getRank() )
    property : updateProperty( _G.Constant.CONST_ATTR_COUNTRY,  _ackMsg : getCountry() )
    property : updateProperty( _G.Constant.CONST_ATTR_CLAN, _ackMsg : getClan() )
    property : updateProperty( _G.Constant.CONST_ATTR_CLAN_NAME, _ackMsg : getClanName() )
    property : updateProperty( _G.Constant.CONST_ATTR_POWERFUL,  _ackMsg : getPowerful() )
    property : updateProperty( _G.Constant.CONST_ATTR_EXP,  _ackMsg : getExp() )
    property : updateProperty( _G.Constant.CONST_ATTR_EXPN,  _ackMsg : getExpn() )
    property : updateProperty( _G.Constant.CONST_ATTR_WEAPON,  _ackMsg : getSkinWeapon() )
    property : updateProperty( _G.Constant.CONST_ATTR_ARMOR,  _ackMsg : getSkinArmor() )
    property : setCount( _ackMsg : getCount() )
    property : setPartner( _ackMsg : getPartner() )
    property : setMagicId( _ackMsg : getMagicId() )
    property : setExt1( _ackMsg : getExt1() )
    property : setExt2( _ackMsg : getExt2() )
    property : setExt3( _ackMsg : getExt3() )
    property : setExt4( _ackMsg : getExt4() )
    property : setExt5( _ackMsg : getExt5() )

    --attr 角色基本属性块2002
    local attr = _ackMsg : getAttr()
    if attr.is_data == true then
        property.attr : setIsData( attr.is_data )
        property : updateProperty( _G.Constant.CONST_ATTR_SP ,attr.sp )
        property : updateProperty( _G.Constant.CONST_ATTR_SP_UP ,attr.sp_speed )
        property : updateProperty( _G.Constant.CONST_ATTR_ANIMA ,attr.anima )
        property : updateProperty( _G.Constant.CONST_ATTR_HP ,attr.hp )
        property : updateProperty( _G.Constant.CONST_ATTR_HP_GRO ,attr.hp_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG ,attr.strong )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_GRO ,attr.strong_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_MAGIC ,attr.magic )
        property : updateProperty( _G.Constant.CONST_ATTR_MAGIC_GRO ,attr.magic_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_ATT ,attr.strong_att )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_DEF ,attr.strong_def )
        property : updateProperty( _G.Constant.CONST_ATTR_SKILL_ATT ,attr.skill_att )
        property : updateProperty( _G.Constant.CONST_ATTR_SKILL_DEF ,attr.skill_def )
        property : updateProperty( _G.Constant.CONST_ATTR_CRIT ,attr.crit )
        property : updateProperty( _G.Constant.CONST_ATTR_RES_CRIT ,attr.crit_res )
        property : updateProperty( _G.Constant.CONST_ATTR_CRIT_HARM ,attr.crit_harm )
        property : updateProperty( _G.Constant.CONST_ATTR_DEFEND_DOWN ,attr.wreck )
        property : updateProperty( _G.Constant.CONST_ATTR_LIGHT ,attr.light )
        property : updateProperty( _G.Constant.CONST_ATTR_LIGHT_DEF ,attr.light_def )
        property : updateProperty( _G.Constant.CONST_ATTR_DARK ,attr.dark )
        property : updateProperty( _G.Constant.CONST_ATTR_DARK_DEF ,attr.dark_def )
        property : updateProperty( _G.Constant.CONST_ATTR_GOD ,attr.god )
        property : updateProperty( _G.Constant.CONST_ATTR_GOD_DEF ,attr.god_def )
        property : updateProperty( _G.Constant.CONST_ATTR_BONUS ,attr.bonus )
        property : updateProperty( _G.Constant.CONST_ATTR_REDUCTION ,attr.reduction )
        property : updateProperty( _G.Constant.CONST_ATTR_IMM_DIZZ ,attr.imm_dizz )
    end
    ----------------------------------------------------------------------
    print("--得到玩家属性时自动请求玩家所带伙伴属性")
    print( "Count:",_ackMsg :getCount())
    ----[[
    if _ackMsg :getCount() > 0 then
        for i=1,_ackMsg :getCount() do
            print("PartnerId:",_ackMsg :getPartner()[i])

            local msg = REQ_ROLE_PROPERTY()
            msg: setSid( _G.g_LoginInfoProxy :getServerId() )
            msg: setUid( _ackMsg : getUid() )
            msg: setType( _ackMsg :getPartner()[i])
            _G.CNetwork : send( msg )
            --请求伙伴身上装备
            msg = REQ_GOODS_EQUIP_ASK()
            msg :setUid( _ackMsg : getUid())
            msg :setPartner( _ackMsg :getPartner()[i])
            _G.CNetwork :send( msg)

            --请求伙伴技能信息
            msg = REQ_SKILL_PARTNER()
            msg :setUid( _ackMsg : getUid() )
            msg :setParentid( _ackMsg :getPartner()[i])
            _G.CNetwork :send( msg)
        end
    end

    local ChallengePanePlayInfo = _G.g_characterProperty : getChallengePanePlayInfo(  )
    if ChallengePanePlayInfo ~= nil then
        ChallengePanePlayInfo : setCount( _ackMsg : getCount() )
        ChallengePanePlayInfo : setPartner( _ackMsg : getPartner() )
        if _ackMsg :getCount() <= 0 then
            _G.pStageMediator : gotoScene( _G.Constant.CONST_ARENA_THE_ARENA_ID, _G.Constant.CONST_ARENA_SENCE_LEFT_X,_G.Constant.CONST_ARENA_SENCE_LEFT_Y )
        end
        return
    end

    --]]
    -------------------------------------------------------------------------
    --发出命令， 打开查看其他玩家的面板

    if tonumber(_ackMsg : getUid()) ~= tonumber(_G.g_LoginInfoProxy :getUid())
        and _G.g_Stage:getScenesType() ~= _G.Constant.CONST_MAP_TYPE_INVITE_PK then
        local command = CCharacterPropertyACKCommand( _ackMsg : getUid()) --uid 未使用
        controller :sendCommand( command)
    end
end

--更新伙伴的名字和颜色
function CCharacterPropertyMediator.getPartnerInfo( self, _partnerid)
    local _partnerid = tostring( _partnerid)
    _G.Config:load("config/partner_init.xml")
    local partner_inits_temp = _G.Config.partner_init_temp : selectSingleNode("partner_inits[0]")
    local node = partner_inits_temp : selectSingleNode("partner_init[@id=".._partnerid.."]")
    -- local str = "partner_init[@id="..tostring(_partnerid).."]"
    -- local partnerinfo = node : selectSingleNode( str )
    -- print("fff")
    return node
end

-- [1109]伙伴属性 -- 角色
function CCharacterPropertyMediator.ACK_ROLE_PARTNER_DATA( self, _ackMsg )
    print("得到伙伴属性UID:",_ackMsg : getUid())
    local uid        = _ackMsg :getUid()
    local partner_id = _ackMsg :getPartnerId()
    local index      = tostring( uid)..tostring( partner_id)
    local property = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
    local playProperty = _G.g_characterProperty : getOneByUid( uid, _G.Constant.CONST_PLAYER )
    if property == nil then
        property = CCharacterProperty()
        property : setUid( uid )
        property : setPartner( partner_id )
        local partnerinfo = self :getPartnerInfo( partner_id)
        property : updateProperty( _G.Constant.CONST_ATTR_NAME,  partnerinfo:getAttribute("partner_name"))
        property : updateProperty( _G.Constant.CONST_ATTR_NAME_COLOR,  partnerinfo:getAttribute("name_colour"))
        property : setSkinArmor( partnerinfo:getAttribute("skin"))
        property : setAI( partnerinfo:getAttribute("ai_id"))
        _G.g_characterProperty : addOne( property, _G.Constant.CONST_PARTNER )
    end
    property : setPro( _ackMsg : getPartnerPro() )
    property : updateProperty( _G.Constant.CONST_ATTR_LV,  _ackMsg : getPartnerLv() )
    property : updateProperty( _G.Constant.CONST_ATTR_POWERFUL,  _ackMsg : getPowerful() )
    property : updateProperty( _G.Constant.CONST_ATTR_EXP,  _ackMsg : getExp() )
    property : updateProperty( _G.Constant.CONST_ATTR_EXPN,  _ackMsg : getNextExp() )
    property : setPartner( _ackMsg : getPartnerId() )
    property : setStata( _ackMsg : getStata())
    property : setTeamID( playProperty : getTeamID() )

    --attr 角色基本属性块2002
    local attr = _ackMsg : getAttr()
    if attr.is_data == true then
        property.attr : setIsData( attr.is_data )
        property : updateProperty( _G.Constant.CONST_ATTR_SP ,attr.sp )
        property : updateProperty( _G.Constant.CONST_ATTR_SP_UP ,attr.sp_speed )
        property : updateProperty( _G.Constant.CONST_ATTR_ANIMA ,attr.anima )
        property : updateProperty( _G.Constant.CONST_ATTR_HP ,attr.hp )
        property : updateProperty( _G.Constant.CONST_ATTR_HP_GRO ,attr.hp_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG ,attr.strong )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_GRO ,attr.strong_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_MAGIC ,attr.magic )
        property : updateProperty( _G.Constant.CONST_ATTR_MAGIC_GRO ,attr.magic_gro )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_ATT ,attr.strong_att )
        property : updateProperty( _G.Constant.CONST_ATTR_STRONG_DEF ,attr.strong_def )
        property : updateProperty( _G.Constant.CONST_ATTR_SKILL_ATT ,attr.skill_att )
        property : updateProperty( _G.Constant.CONST_ATTR_SKILL_DEF ,attr.skill_def )
        property : updateProperty( _G.Constant.CONST_ATTR_CRIT ,attr.crit )
        property : updateProperty( _G.Constant.CONST_ATTR_RES_CRIT ,attr.crit_res )
        property : updateProperty( _G.Constant.CONST_ATTR_CRIT_HARM ,attr.crit_harm )
        property : updateProperty( _G.Constant.CONST_ATTR_DEFEND_DOWN ,attr.wreck )
        property : updateProperty( _G.Constant.CONST_ATTR_LIGHT ,attr.light )
        property : updateProperty( _G.Constant.CONST_ATTR_LIGHT_DEF ,attr.light_def )
        property : updateProperty( _G.Constant.CONST_ATTR_DARK ,attr.dark )
        property : updateProperty( _G.Constant.CONST_ATTR_DARK_DEF ,attr.dark_def )
        property : updateProperty( _G.Constant.CONST_ATTR_GOD ,attr.god )
        property : updateProperty( _G.Constant.CONST_ATTR_GOD_DEF ,attr.god_def )
        property : updateProperty( _G.Constant.CONST_ATTR_BONUS ,attr.bonus )
        property : updateProperty( _G.Constant.CONST_ATTR_REDUCTION ,attr.reduction )
        property : updateProperty( _G.Constant.CONST_ATTR_IMM_DIZZ ,attr.imm_dizz )
    end
    if _G.g_characterProperty : getChallengePanePlayInfo( ) ~= nil then
        local isGo = true
        local listPartner = playProperty : getPartner()
        for _,PlayInfo_partner_id in pairs(listPartner) do
            print("listPartner",PlayInfo_partner_id)
            local indexID      = tostring( playProperty : getUid())..tostring( PlayInfo_partner_id )
            local partnerProperty = _G.g_characterProperty : getOneByUid( indexID, _G.Constant.CONST_PARTNER )
            if partnerProperty == nil then
                isGo = false
            end
        end
        if isGo == true then
            print("_G.pStageMediator",_G.pStageMediator)
            _G.pStageMediator : gotoScene( _G.Constant.CONST_ARENA_THE_ARENA_ID, _G.Constant.CONST_ARENA_SENCE_LEFT_X,_G.Constant.CONST_ARENA_SENCE_LEFT_Y )
        end
    end
end


-- [1130]玩家单个属性更新 -- 角色
function CCharacterPropertyMediator.ACK_ROLE_PROPERTY_UPDATE( self, _ackMsg )
    print("更新角色/伙伴属性UID:",_ackMsg : getId())
    local partner_id = _ackMsg : getId()
    local property = nil
    if tonumber(partner_id) == 0 then
        print("更新玩家属性")
        property = _G.g_characterProperty : getOneByUid( partner_id, _G.Constant.CONST_PLAYER )
    else
        local index = tostring( _G.g_LoginInfoProxy :getUid())..tostring( partner_id)
        property = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
        print("更新伙伴属性：",index)
    end
    if property == nil then
        print("没有找到玩家/伙伴")
        return
    end
    property : updateProperty( _ackMsg : getType(), _ackMsg : getValue() )

    print(":::::::", _G.Constant.CONST_ATTR_CLAN_NAME, _G.Constant.CONST_ATTR_CLAN, "[[[[[===]]]]]",_ackMsg : getType(), _ackMsg : getValue())
    if _ackMsg : getType() == _G.Constant.CONST_ATTR_CLAN_NAME or _ackMsg : getType() == _G.Constant.CONST_ATTR_CLAN then
        local temp = _ackMsg : getValue() or "没有社团名"
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~修改社团名:")
        local command = CClanIdOrNameUpdateCommand()
        controller :sendCommand( command)
    end

    if _ackMsg : getType() == _G.Constant.CONST_ATTR_ALLS_POWER then
        local updateCommand = CVipViewCommand( CVipViewCommand.UPDATEPOWERFUL )
        controller :sendCommand( updateCommand )
    end

    if _ackMsg : getType() == _G.Constant.CONST_ATTR_EXP or _ackMsg : getType() == _G.Constant.CONST_ATTR_EXPN then
        CCLOG("发送经验更新")
        local updateCommand = CVipViewCommand( CVipViewCommand.UPDATEEXP )
        controller :sendCommand( updateCommand )
    end
end

-- [6530]技能信息 -- 技能系统
function CCharacterPropertyMediator.ACK_SKILL_INFO( self, _ackMsg)
    CCLOG("CCharacterPropertyMediator.ACK_SKILL_INFO")
    local skill_id = _ackMsg :getSkillId()
    local skill_lv = _ackMsg :getSkillLv()

    local _vo_data = VO_SkillUpdateModel()
    _vo_data :setSkillId( skill_id )
    _vo_data :setSkillLevel( skill_lv )

    local roleProperty = _G.g_characterProperty : getMainPlay()
    if roleProperty == nil then
        local uid = tonumber(_G.g_LoginInfoProxy : getUid())

        _G.g_characterProperty : initMainPlay(uid)
        roleProperty = _G.g_characterProperty : getMainPlay()
    end

    local roleSkillData = roleProperty :getSkillData()
    if roleSkillData == nil then
        local l_skillData = CSkillData()
        roleProperty : setSkillData( l_skillData )
        roleSkillData = l_skillData
    end
    roleSkillData :setSkillStudyList( _vo_data )

    local l_data = roleSkillData :getSkillStudyList()
    if l_data ~= nil then
        roleSkillData :setSkillStudyCount( #l_data)
    end

    local command = CSkillDataUpdateCommand( CSkillDataUpdateCommand.TYPE_UPDATE)
    controller :sendCommand( command)
end

-- [6545]返回装备技能信息 -- 技能系统
function CCharacterPropertyMediator.ACK_SKILL_EQUIP_INFO( self, _ackMsg)
    CCLOG("CCharacterPropertyMediator.ACK_SKILL_EQUIP_INFO")

    local equip_pos = tonumber( _ackMsg:getEquipPos())
    local skill_id  = tonumber( _ackMsg:getSkillId())
    local skill_lv  = tonumber( _ackMsg:getSkillLv())

     local _vo_data = VO_SkillUpdateModel()
     _vo_data :setEquipId( skill_id)
     _vo_data :setEquipPos( equip_pos)
     _vo_data :setEquipLv( skill_lv)

    local roleProperty = _G.g_characterProperty : getMainPlay()
    if roleProperty == nil then
        local uid = tonumber(_G.g_LoginInfoProxy : getUid())
        _G.g_characterProperty : initMainPlay(uid)
        roleProperty = _G.g_characterProperty : getMainPlay()
    end

    local roleSkillData = roleProperty :getSkillData()
    if roleSkillData == nil then
        local l_skillData = CSkillData()
        roleProperty :setSkillData( l_skillData )
        roleSkillData = l_skillData
    end
    roleSkillData :setSkillEquipList( _vo_data )
    --设置战斗界面技能按钮
    roleSkillData : setSkillIdByIndex( skill_id, equip_pos )

    local l_equip_skill = roleSkillData :getSkillEquipList()
    if l_equip_skill ~= nil then
        roleSkillData :setSkillEquipCount( #l_equip_skill)
    end

    local command = CSkillDataUpdateCommand( CSkillDataUpdateCommand.TYPE_EQUIP)
    controller :sendCommand( command)

end

-- [6560]伙伴技能信息 -- 技能系统
function CCharacterPropertyMediator.ACK_SKILL_PARENTINFO( self, _ackMsg)
                  print("CCharacterPropertyMediator.ACK_SKILL_PARENTINFO", _ackMsg :getSkillId(), _ackMsg :getSkillLv(), _ackMsg :getParentid(), _ackMsg :getUid() )

    local skill_id = _ackMsg :getSkillId()
    local skill_lv = _ackMsg :getSkillLv()
    local partner_id = _ackMsg :getParentid()

    local _vo_data = VO_SkillUpdateModel()
    _vo_data :setSkillId( skill_id )
    _vo_data :setSkillLevel( skill_lv )


    local roleProperty = _G.g_characterProperty : getMainPlay()
    local uid = tonumber( _ackMsg :getUid() )
    if uid == 0 then        --如果uid为0，则拿主角的uid
        uid = _G.g_LoginInfoProxy :getUid()
    end
    if roleProperty == nil then
        _G.g_characterProperty : initMainPlay(uid)
        roleProperty = _G.g_characterProperty : getMainPlay()
    end

    local index      = tostring( uid)..tostring( partner_id)
    local property = _G.g_characterProperty : getOneByUid( index, _G.Constant.CONST_PARTNER )
    if property == nil then
        property = CCharacterProperty()
        property : setUid( uid )
        property : setPartner( partner_id )
    end

    local roleSkillData = property :getSkillData()
    if roleSkillData == nil then
        local l_skillData = CSkillData()
        property :setSkillData(l_skillData)
        roleSkillData = l_skillData
    end
    roleSkillData :setSkillStudyList( _vo_data )

    local l_data = roleSkillData :getSkillStudyList()
    if l_data ~= nil then
        roleSkillData :setSkillStudyCount( #l_data)
    end

    local partnerCommand = CSkillDataUpdateCommand( CSkillDataUpdateCommand.TYPE_PARTNER)
    controller :sendCommand( partnerCommand)
end
--[[
	函数
]]



    -- --告诉StageMediator进入场景
    -- local tempCommand = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER"])
    -- tempCommand : setOtherData({mapID = 0})
    -- controller: sendCommand(tempCommand)

    -- --读取角色当前任务列表,徐敏飞增加
    -- require "proxy/TaskDataProxy"
    -- CTaskDataProxy:sendTaskList()


