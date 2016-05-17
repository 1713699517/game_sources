--SkillDataProxy
require "view/view"
require "model/VO_SkillModel"


CSkillData = class( function ( self )

    self.m_nSkillId1    = 0 --三连击
    self.m_nSkillId2    = 0
    self.m_nSkillId3    = 0
    self.m_nSkillId4    = 0            --跳跃
    self.m_nSkillId5    = 0            --对应技能1
    self.m_nSkillId6    = 0            --对应技能2
    self.m_nSkillId7    = 0            --对应技能3
    self.m_nSkillId8    = 0            --对应技能4
    self.m_nSkillId9    = 0            --预留备用2个
    self.m_nSkillId10   = 0

    self.m_skill_list           = {}      --技能列表数据 gold, rmb, power, rmb_bind --钱

    self.skill_study_count      = 0
    self.skill_study_list       = {}      --已经学习的技能信息    skill_id, skill_lv

    self.skill_equip_count      = 0
    self.skill_equip_list       = {}      --装备技能信息 equip_pos, skill_id, skill_lv

    --self.skill_partner_cout     = 0
    --self.skill_partner_list     = {}      --伙伴技能信息   skill_id, skill_lv


    --self.m_skill_id_list        = {}      --显示在 技能界面的技能信息

--[[
    for i=1,10 do
        local function setfun( self, _skillId )
            self["m_nSkillId"..i] = _skillId
        end
        local function getfun( self )
            return self["m_nSkillId"..i]
        end
        self["setSkillId"..i] = setfun
        self["getSkillId"..i] = getfun
    end
 --]]
end)
-------------1
function CSkillData.setSkillId1( self, valueForKey)
    self.m_nSkillId1 = valueForKey
end
function CSkillData.getSkillId1( self)
    return self.m_nSkillId1
end
-------------2
function CSkillData.setSkillId2( self, valueForKey)
    self.m_nSkillId2 = valueForKey
end
function CSkillData.getSkillId2( self)
    return self.m_nSkillId2
end
-------------3
function CSkillData.setSkillId3( self, valueForKey)
    self.m_nSkillId3 = valueForKey
end
function CSkillData.getSkillId3( self)
    return self.m_nSkillId3
end
-------------4
function CSkillData.setSkillId4( self, valueForKey)
    self.m_nSkillId4 = valueForKey
end
function CSkillData.getSkillId4( self)
    return self.m_nSkillId4
end
-------------5
function CSkillData.setSkillId5( self, valueForKey)
    self.m_nSkillId5 = valueForKey
end
function CSkillData.getSkillId5( self)
    return self.m_nSkillId5
end
-------------6
function CSkillData.setSkillId6( self, valueForKey)
    self.m_nSkillId6 = valueForKey
end
function CSkillData.getSkillId6( self)
    return self.m_nSkillId6
end
-------------7
function CSkillData.setSkillId7( self, valueForKey)
    self.m_nSkillId7 = valueForKey
end
function CSkillData.getSkillId7( self)
    return self.m_nSkillId7
end
-------------8
function CSkillData.setSkillId8( self, valueForKey)
    self.m_nSkillId8 = valueForKey
end
function CSkillData.getSkillId8( self)
    return self.m_nSkillId8
end
-------------9
function CSkillData.setSkillId9( self, valueForKey)
    self.m_nSkillId9 = valueForKey
end
function CSkillData.getSkillId9( self)
    return self.m_nSkillId9
end
-------------10
function CSkillData.setSkillId10( self, valueForKey)
    self.m_nSkillId10 = valueForKey
end
function CSkillData.getSkillId10( self)
    return self.m_nSkillId10
end
-------------
function CSkillData.setSkillIdByIndex( self, _id, _index )
    print(" _id, _index 111",  _id, _index, self  )
    --[[local fun = self["setSkillId".._index]
    if fun ~= nil then
        fun(self, _id)
    end
     --]]
    local fun = self["setSkillId".._index]
    if fun ~= nil then
        fun(self, _id)
    end
    print(" _id, _index 222",  _id, _index, fun, self  )
end

function CSkillData.getSkillIdByIndex( self, _index )
    local fun = self["getSkillId".._index]
    if fun ~= nil then
        return fun(self)
    end
    return 0
end

--技能列表数据    6520 gold, rmb, power, rmb_bind
function CSkillData.setSkillList( self, valueForKey )
    self.m_skill_list = valueForKey
end

function CSkillData.getSkillList( self )
    return self.m_skill_list
end


--技能信息   6530 skill_id, skill_lv
function CSkillData.setSkillInfo( self, valueForKey)
    self.skill_study_list = valueForKey
end

function CSkillData.getSkillInfo( self )
    return self.skill_study_list
end

function CSkillData.getSkillLvBySkillID( self, _skillID )
    local skillInfo = self : getSkillInfo()
    if skillInfo == nil then
        return
    end
    return skillInfo[_skillID]
end


--技能装备信息    6545   equip_pos, skill_id, skill_lv
function CSkillData.setSkillEquipInfo( self, valueForKey )
    self.skill_equip_list = valueForKey
end

function CSkillData.getSkillEquipInfo( self )
    return self.skill_equip_list
end


------new   begin
--已学的技能链表 6530
function CSkillData.setSkillStudyCount( self, _value)
    self.skill_study_count = _value
end
function CSkillData.getSkillStudyCount( self)
    return self.skill_study_count
end

function CSkillData.setSkillStudyList( self, _skillDataInfo)
    if _skillDataInfo == nil then
        return
    end
    if self.skill_study_list == nil then
        self.skill_study_list = {}
    end
    local lo = self.skill_study_list[_skillDataInfo:getSkillId()]
    if lo == nil or lo :getSkillLevel() < _skillDataInfo :getSkillLevel() then
        self.skill_study_list[ _skillDataInfo:getSkillId() ] = _skillDataInfo
    end
end

function CSkillData.getSkillStudyList( self)
    return self.skill_study_list
end

--已装备的技能链表   6545
function CSkillData.setSkillEquipCount( self, _value)
    self.skill_equip_count = _value
end

function CSkillData.getSkillEquipCount( self)
    return self.skill_equip_count
end


function CSkillData.setSkillEquipList( self, _equipData)
    if _equipData == nil then
        return
    end
    if self.skill_equip_list == nil then
        self.skill_equip_list = {}
    end
    local vo = self.skill_equip_list[ _equipData :getEquipPos()]

    print("character6545Equip", _equipData :getEquipId(), _equipData :getEquipPos(), _equipData :getEquipLv())
    if vo == nil or vo :getEquipId() ~= _equipData :getEquipId() then
        self.skill_equip_list[ _equipData :getEquipPos()] = _equipData
    end
    --self.skill_equip_list = value
end

function CSkillData.getSkillEquipList( self)
    return self.skill_equip_list
end


--6560
--伙伴的技能链表
function CSkillData.setSkillPartnerCount( self, _value)
    self.skill_partner_cout = _value
end

function CSkillData.getSkillPartnerCount( self)
    return self.skill_partner_cout
end


function CSkillData.setSkillPartnerList( self, _partnerData)
    --[[if _skillDataInfo == nil then
        return
    end
    if self.skill_partner_list == nil then
        self.skill_partner_list = {}
    end
    local lo = self.skill_partner_list[_skillDataInfo :getSkillId()]
    if lo == nil or lo :getSkillLevel() ~= _skillDataInfo :getSkillLevel() then
        self.skill_partner_list[ _skillDataInfo:getSkillId() ] = _skillDataInfo
    end
         --]]
    if _partnerData == nil then
        return
    end
    if self.skill_partner_list == nil then
        self.skill_partner_list = {}
    end
    local vo = self.skill_partner_list[ _partnerData.skill_id]

    print("6560PartnerList", _partnerData.skill_id, _partnerData.skill_lv)
    if vo == nil or vo.skill_lv ~= _partnerData.skill_lv then
        self.skill_partner_list[ _partnerData.skill_id] = _partnerData
    end
                                                        --]]
end
function CSkillData.getSkillPartnerList( self)
    return self.skill_partner_list
end

-------new end



CSkillDataProxy = class( view, function( self )
    self.m_bInitialized = true


    self.m_lpCharacterSkillList = {} --所有人物技能列表


    CCLOG("CSkillDataProxy init Success!--")
    --初始化 技能位置 测试用

    ---------------------------------------------------------分割线，以下数据未使用-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --废弃 0724 begin
    self.m_nSkillPos1   = 0
    self.m_nSkillPos2   = 0
    self.m_nSkillPos3   = 0
    self.m_nSkillPos4   = 0

    self.m_nSkillPos5   = 5
    self.m_nSkillPos6   = 6
    self.m_nSkillPos7   = 7

    --技能界面显示的
    self.m_nMoney       = 111               --金币
    self.m_nGold        = 222               --银币
    self.m_nPower       = 333               --潜能

    self.m_skill_skillId_info   = {}        --返回该技能id信息(含下)
    self.m_nStudyCount          = 0         --已经学习的技能列表数量
    self.m_skill_study_list     = {}        --已经学习技能列表信息
    self.m_skill_request_info   = {}        --单个技能信息显示
    self.m_skill_learn_list       = {}        ---- [6549]返回该职业所能学习的技能 -- 技能系统
    self.m_skill_learn_list_count = 1         --[6549]返回该职业所能学习的技能数量
    self.m_allSkill             = {}        --每个直接所有技能   倒序
    --xml数据
    self.m_id               = 1001           --技能id
    self.m_pro              = "[1]"         --人物职业
    self.m_battle_remark    = 999             --技能需要等级
    self.m_remark           = "技能威力系数110%，提升自身18%格挡3回合"     --技能描述
    self.m_name             = "等等技能"      --技能名字
    self.m_icon             = ""            --技能图标
    self.m_rmb              = 1002           --技能学习所需金币
    self.m_studyPower       = 1003           --技能学习所需潜能
    self.m_lv               = 1005             --技能当前级别
    self.m_lv_max           = 1004            --技能最大等级

    --07.10 add
    self.m_nCurrentSkillLvList  = {}            --级别对应的技能个数
    self.m_szSkillNameList          = {}        --所有技能对应的名字

    --07.11 add
    self.m_equipList       = {}     --已经装备的技能表

    self.m_bindRmb         = 0.0
     --废弃 0724 end


end)


function CSkillDataProxy.getCharacterSkillByUid( self, _uid )
    _uid = tonumber( _uid )
    local data = self.m_lpCharacterSkillList[_uid]
    return data
end
function CSkillDataProxy.setCharacterSkill( self, _uid, _skillInfo )
    _uid = tonumber(_uid)
    self.m_lpCharacterSkillList[_uid] = _skillInfo
end

--6530
function CSkillDataProxy.setSkillDataInfo(self, _skillDataInfo)
    if _skillDataInfo == nil then
        return
    end
    if self.m_skillTab == nil then
        self.m_skillTab = {}
    end
    local lo = self.m_skillTab[_skillDataInfo:getSkillId()]
    if lo == nil or lo:getSkillLevel() < _skillDataInfo:getSkillLevel() then
    self.m_skillTab[ _skillDataInfo:getSkillId() ] = _skillDataInfo
    end
end

function CSkillDataProxy.getSkillDataInfo(self, _skillId)
    return self.m_skillTab[ _skillId ]
end

--所有的已经学习的技能信息
function CSkillDataProxy.getSkillDataInfoList(self)
    return self.m_skillTab
end

--6545
function CSkillDataProxy.setEquipDataInfo( self, _equipData)
    if _equipData == nil then
        return
    end
    if self.m_equipTab == nil then
        self.m_equipTab = {}
    end
    local vo = self.m_equipTab[ _equipData :getEquipPos()]
    print("6545proxy", _equipData :getEquipId(), _equipData :getEquipPos(), _equipData :getEquipLv())
    if vo == nil or vo :getEquipId() ~= _equipData :getEquipId() then

        self.m_equipTab[ _equipData :getEquipPos()] = _equipData
    end
end

function CSkillDataProxy.getEquipDataInfo( self, _equipId)
    return self.m_equipTab[ _equipId]
end

--所有的已装备的技能信息
function CSkillDataProxy.getEquipDataInfoList( self)
    return self.m_equipTab
end


--伙伴6560
function CSkillDataProxy.setPartnerSkillData( self, _partnerData)
    if _partnerData == nil then
        return
    end
    if self.m_partnerList == nil then
        self.m_partnerList = {}
    end
    local vo = self.m_partnerList[ _partnerData.skill_id]
    print("6560proxy", _partnerData.skill_id, _partnerData.skill_lv)
    if vo == nil or vo.skill_lv ~= _partnerData.skill_lv then
        self.m_partnerList[ _partnerData.skill_id] = _partnerData
    end
end

function CSkillDataProxy.getPartnerSkillData( self, _nId)
    return self.m_partnerList[ _nId ]
end

function CSkillDataProxy.getPartnerSkillDataList( self)
    return self.m_partnerList
end

function CSkillDataProxy.cleanPartnerSkillData( self)
    if self.m_partnerList then
        print("111213123123")
        table.remove( self.m_partnerList)
        print("11121312312self.m_partnerList3")
        self.m_partnerList = nil
        print("11121312312self.m_partnerLssssist3", self.m_partnerList)
    end
end

if _G.g_SkillDataProxy == nil then

    _G.g_SkillDataProxy = CSkillDataProxy()
    --[[
    require "mediator/SkillDataMediator"
    _G.g_CSkillDataMediator = CSkillDataMediator( _G.g_SkillDataProxy )
    controller :registerMediator( _G.g_CSkillDataMediator )
                                                  --]]
end
-----------------------------------------------<<<<<<<<




------------------------------------07.11大修改后

function CSkillDataProxy.setSkillUiInfo( self, valueForKey)
    self.m_skill_id_list = valueForKey
end

function CSkillDataProxy.getSkillUiInfo( self)
    return self.m_skill_id_list
end



------------------------------------ 07.11大修改




function CSkillDataProxy.getBindRmb( self)
   return self.m_bindRmb
end

function CSkillDataProxy.setBindRmb( self, valueForKey)
     self.m_bindRmb = valueForKey
end

--已经装备的技能表
function CSkillDataProxy.setEquipList( self, valueForKey)
    self.m_equipList = valueForKey
end

function CSkillDataProxy.getEquipList( self )
    return self.m_equipList
end

--所有技能对应的名字
function CSkillDataProxy.setSkillNameList( self, valueForKey)
    self.m_szSkillNameList = valueForKey
end

function CSkillDataProxy.getSkillNameList( self)
    return self.m_szSkillNameList
end

----级别对应的技能个数
function CSkillDataProxy.setCurrentSkillLvList( self, valueForKey)
    self.m_nCurrentSkillLvList = valueForKey
end

function CSkillDataProxy.getCurrentSkillLvList( self )
    return self.m_nCurrentSkillLvList
end

-- [6549]返回该职业所能学习的技能 -- 技能系统
function CSkillDataProxy.setSkillLearnList( self, valueForKey)
    self.m_skill_learn_list = valueForKey
end

function CSkillDataProxy.getSkillLearnList( self )
    return self.m_skill_learn_list
end

--[6549]返回该职业所能学习的技能数量
function CSkillDataProxy.setSkillCount( self, valueForKey)
    self.m_skill_learn_list_count = valueForKey
end

function CSkillDataProxy.getSkillCount( self)
    return self.m_skill_learn_list_count
end


--已经学习技能数量
function CSkillDataProxy.setStudyCount( self, valueForKey)
    self.m_nStudyCount = valueForKey
end

function CSkillDataProxy.getStudyCount( self)
    return self.m_nStudyCount
end

--已经学习技能列表信息
function CSkillDataProxy.setSkillStudyList( self, valueForKey)
    self.m_skill_study_list = valueForKey
end

function CSkillDataProxy.getSkillStudyList( self)
    return self.m_skill_study_list
end

--技能界面显示的潜能
function CSkillDataProxy.setPower( self, valueForKey )
    self.m_nPower = valueForKey
end

function CSkillDataProxy.getPower( self )
    return self.m_nPower
end
--金币
function CSkillDataProxy.setMoney( self, valueForKey )
    self.m_nMoney = valueForKey
end

function CSkillDataProxy.getMoney( self )
    return self.m_nMoney
end
--银币
function CSkillDataProxy.setGold( self, _bValue)
    --print("gold  ==", _bValue)
    self.m_nGold = _bValue
end

function CSkillDataProxy.getGold( self)
   return self.m_nGold
end

--缓存存放
function CSkillDataProxy.setInitialized( self, _bValue)
    self.m_bInitialized = _bValue
end

function CSkillDataProxy.getInitialized( self )
    return self.m_bInitialized
end

--table
--得到一个技能数据， 数据格式为: CSkillDataProxy   --通过id获取xml数据
function CSkillDataProxy.getSkillById( self,  _skillId )
    return _G.Config.skills:selectSingleNode("skill[@id="..tostring( _skillId).."]")
end

--通过职业读取技能id
function CSkillDataProxy.getSkillIdByPro( self,  _nPro )
    _G.Config : load("config/skill_start.xml")
    return _G.Config.skill_starts:selectSingleNode("skill_start[@pro="..tostring( _nPro).."]")
end

--通过技能id设置xml数据，可以使用proxy使用xml数据
function CSkillDataProxy.setSkillDataById( self,_skillId )
    --[[
    _G.Config : load("config/skill.xml")
    local skillNode = _G.Config.skills:selectSingleNode("skill[@id="..tostring(_skillId).."]")
    self: setId( skillNode.id)
    self: setPro( skillNode.pro)
    self: setBattleRemark( skillNode.battle_remark)
    self: setRemark( skillNode.lvs[1].lv[1].remark)
    self: setName( skillNode.name)
    self: setIcon( skillNode.icon)
    self: setRmb( skillNode.lvs[1].lv[1].up[1].rmb)
    self: setStudyPower( skillNode.lvs[1].lv[1].up[1].power)
    self: setLv( skillNode.lvs[1].lv[1].lv)
    self: setMaxLv( skillNode.lv_max)
    --]]
end



--设置技能
function CSkillDataProxy.setSkillById( _skillId, _data )
	_skillId = tostring(_skillId)

	local vo --= readXmlAndInitData( _skillId, _data)

	CSkillDataProxy[_skillId] = vo

	if CSkillDataProxy.ids == nil then
		CSkillDataProxy.ids = {}
	end

	local tt = false

	for i, v in pairs(CSkillDataProxy.ids) do
		if v == _skillId then
			tt = true
			break
		end
	end

	if tt == false then
		table.insert( CSkillDataProxy.ids, _skillId )
	end
end

--------------
-----------------------
function CSkillDataProxy.setSkillPos1( self, valueForKey )
    self.m_nSkillPos1 = tonumber(valueForKey)
end

function CSkillDataProxy.getSkillPos1( self )
    return tonumber(self.m_nSkillPos1)
end
-----------------------
function CSkillDataProxy.setSkillPos2( self, valueForKey )
    self.m_nSkillPos2 = tonumber(valueForKey)
end

function CSkillDataProxy.getSkillPos2( self )
    return tonumber(self.m_nSkillPos2)
end
-----------------------
function CSkillDataProxy.setSkillPos3( self, valueForKey )
    self.m_nSkillPos3 = tonumber(valueForKey)
end

function CSkillDataProxy.getSkillPos3( self )
    return tonumber(self.m_nSkillPos3)
end
-----------------------
function CSkillDataProxy.setSkillPos4( self, valueForKey )
    self.m_nSkillPos4 = tonumber(valueForKey)
end

function CSkillDataProxy.getSkillPos4( self )
    return tonumber(self.m_nSkillPos4)
end
-----------------------
function CSkillDataProxy.setSkillPos5( self, valueForKey )
    self.m_nSkillPos5 = tonumber(valueForKey)
end

function CSkillDataProxy.getSkillPos5( self )
    return tonumber(self.m_nSkillPos5)
end

-----------------------
function CSkillDataProxy.setSkillPos6( self, valueForKey )
    self.m_nSkillPos6 = tonumber(valueForKey)
end

function CSkillDataProxy.getSkillPos6( self )
    return tonumber(self.m_nSkillPos6)
end
-----------------------
function CSkillDataProxy.setSkillPos7( self, valueForKey )
    self.m_nSkillPos7 = tonumber(valueForKey)
end

function CSkillDataProxy.getSkillPos7( self )
    return tonumber(self.m_nSkillPos7)
end
-----------------------


function CSkillDataProxy.setId( self, value )
    --print(" value ===", value)
    self.m_id = value
end

function CSkillDataProxy.getId( self )

    return self.m_id
end
--------------------

function CSkillDataProxy.setPro( self, value )
    --print(" value ===", value)
    self.m_pro = value
end

function CSkillDataProxy.getPro( self )
    return self.m_pro
end
--------------------

--
function CSkillDataProxy.setBattleRemark( self, value )
    --print(" value ===", value)
    self.m_battle_remark = value
end

function CSkillDataProxy.getBattleRemark( self )
    return self.m_battle_remark
end
--------------------

--
function CSkillDataProxy.setRemark( self, value )
    --print(" value ===", value)
    self.m_remark = value
end

function CSkillDataProxy.getRemark( self )
    return self.m_remark
end
--------------------

--
function CSkillDataProxy.setName( self, value )
    --print(" value ===", value)
    self.m_name = value
end

function CSkillDataProxy.getName( self )
    return self.m_name
end
--------------------

--
function CSkillDataProxy.setIcon( self, value )
    --print(" value ===", value)
    self.m_icon = value
end

function CSkillDataProxy.getIcon( self )
    return self.m_icon
end
--------------------

--
function CSkillDataProxy.setRmb( self, value )
    --print(" self.m_rmb ===", value)
    self.m_rmb = value
end

function CSkillDataProxy.getRmb( self )
    return self.m_rmb
end
--------------------
--
function CSkillDataProxy.setStudyPower( self, value )
    --print(" self.m_studyPower ===", value)
    self.m_studyPower = value
end

function CSkillDataProxy.getStudyPower( self )
    return self.m_studyPower
end
--------------------

--
function CSkillDataProxy.setLv( self, value )
    --print(" value ===", value)
    self.m_lv = value
end

function CSkillDataProxy.getLv( self )
    return self.m_lv
end
--------------------

--
function CSkillDataProxy.setMaxLv( self, value )
    --print(" value ===", value)
    self.m_lv_max = value
end

function CSkillDataProxy.getMaxLv( self )
    return self.m_lv_max
end
--------------------



--技能id信息
function CSkillDataProxy.setSkillSkillIdinfo( self, _skillSkillIdInfo )
    self.m_skill_skillId_info = _skillSkillIdInfo
end

function CSkillDataProxy.getSkillSkillIdinfo( self )
    return self.m_skill_skillId_info
end




--单个技能信息
function CSkillDataProxy.setSkillRequestInfo( self, _skillRequestInfo )
    self.m_skill_request_info = _skillRequestInfo
end

function CSkillDataProxy.getSkillRequestInfo( self )
    return self.m_skill_request_info
end

