
--[[下面
    变量名和函数名
    的命名都是根据服务端命名的
]]

require "proxy/CharacterWarProperty"
require "common/Constant"

-- {人物普通属性}
-- 直接将协议放进来
-- attr这个属性,直接放进去CCharacterWarProperty
CCharacterProperty = class( function ( self )
    self.uid                    = nil --玩家UID
    self.name                   = nil --玩家姓名
    self.name_color             = nil --名字颜色
    self.pro                    = nil --玩家职业      --伙伴共用
    self.sex                    = nil --玩家性别
    self.lv                     = 0   --玩家等级      --伙伴共用
    self.rank                   = nil --竞技排名
    self.country                = nil --阵营类型(见常量)
    self.clan                   = nil --家族ID
    self.clan_name              = nil --家族名称
    self.clan_post              = nil --家族职位
    self.attr                   = CCharacterWarProperty()        --角色基本属性块2002 --伙伴共用
    self.powerful               = nil --玩家战斗力     --伙伴共用
    self.renown                 = 0   --玩家声望值
    self.exp                    = 0   --经验值        --伙伴共用
    self.expn                   = nil --下级要多少经验 --伙伴共用
    self.skin_weapon            = nil --武器皮肤
    self.skin_armor             = nil --衣服皮肤
    self.count                  = nil --伙伴数量 (循环)
    self.partner                = nil --伙伴ID        --伙伴共用
    self.stata                  = nil --伙伴状态      --伙伴使用
    self.equip_count            = nil --装备数量
    self.equip_list             = nil --装备链表
    self.alls_power             = 0   --总战斗力


    self.m_skillData            = CSkillData()                  --角色技能信息块

    self.isRedName              = nil --是否红名

    self.gold                   = 0  -- {银元}
    self.rmb                    = 0  -- {金元}
    self.bind_rmb               = 0  -- {绑定金元}

    self.sum                    = 0  -- {当前体力值}
    self.max                    = 0  -- {最大体力值}

    self.vipLv                  = nil -- {自己的vip等级}
    self.vipUp                  = nil -- {已购买金元总数}

    self.teamID                 = 0  -- {队伍ID}

    --与服务器下发数据无关
    self.taskType               = nil --｛当前副本任务显示类型｝
    self.copyId                 = nil -- {当前副本任务副本ID}
    self.chapId                 = nil --{当前副本章节ID}

    self.isTeam                 = false --{是否组队战}


    --额外赠送精力  --角色
    self.buff_value             = nil
    --------------------------------------------------------

    self.ai_id                  = nil -- 伙伴用 AI

    self.funList                = {} --函数列表
    self : initFunList()


    self.magic_id = 0 -- {神器Id}
    self.ext1 = 0 -- {扩展1}
    self.ext2 = 0 -- {扩展2}
    self.ext3 = 0 -- {扩展3}
    self.ext4 = 0 -- {扩展4}
    self.ext5 = 0 -- {扩展5}

    --------------------
    --后期添加的神器

end)

function CCharacterProperty.initFunList( self )
    self.funList[_G.Constant.CONST_ATTR_COUNTRY]            = self.setCountry           --国家
    self.funList[_G.Constant.CONST_ATTR_COUNTRY_POST]       = self.setCountryPost       --国家-职位
    self.funList[_G.Constant.CONST_ATTR_CLAN]               = self.setClan              --家族ID
    self.funList[_G.Constant.CONST_ATTR_CLAN_NAME]          = self.setClanName          --家族名字
    self.funList[_G.Constant.CONST_ATTR_CLAN_POST]          = self.setClanPost          --家族职位
    self.funList[_G.Constant.CONST_ATTR_NAME_COLOR]         = self.setNameColor         --角色名颜色
    self.funList[_G.Constant.CONST_ATTR_LV]                 = self.setLv                --等级
    self.funList[_G.Constant.CONST_ATTR_VIP]                = self.setVipLv             --vip等级
    self.funList[_G.Constant.CONST_ATTR_ENERGY]             = self.setEnergy            --精力
    self.funList[_G.Constant.CONST_ATTR_EXP]                = self.setExp               --经验值
    self.funList[_G.Constant.CONST_ATTR_EXPN]               = self.setExpn              --下级要多少经验
    self.funList[_G.Constant.CONST_ATTR_EXPT]               = self.setExpt              --总共集了多少 经验
    self.funList[_G.Constant.CONST_ATTR_RENOWN]             = self.setRenown            --声望
    self.funList[_G.Constant.CONST_ATTR_SLAUGHTER]          = self.setSlaughter         --杀戮值
    self.funList[_G.Constant.CONST_ATTR_HONOR]              = self.setHonor             --荣誉值
    self.funList[_G.Constant.CONST_ATTR_POWERFUL]           = self.setPowerful          --战斗力
    self.funList[_G.Constant.CONST_ATTR_NAME]               = self.setName              --名字
    self.funList[_G.Constant.CONST_ATTR_RANK]               = self.setRank              --排名
    self.funList[_G.Constant.CONST_ATTR_WEAPON]             = self.setSkinWeapon        --装备武器id（换装）
    self.funList[_G.Constant.CONST_ATTR_ARMOR]              = self.setSkinArmor         --装备衣服id（换装）
    self.funList[_G.Constant.CONST_ATTR_FASHION]            = self.setFashion           --装备时装id(换装)
    self.funList[_G.Constant.CONST_ATTR_MOUNT]              = self.setMount             --坐骑
    self.funList[_G.Constant.CONST_ATTR_S_HP]               = self.setSHp               --气血(现有战斗中)
    self.funList[_G.Constant.CONST_ATTR_ALLS_POWER]         = self.setAllsPower         --总战斗力
end


-- {玩家UID}
function CCharacterProperty.getUid(self)
    return self.uid
end
function CCharacterProperty.setUid(self, _uid )
    self.uid = _uid
end

-- {玩家姓名}
function CCharacterProperty.getName(self)
    return self.name
end
function CCharacterProperty.setName(self, _name)
    self.name = _name
end

-- {名字颜色}
function CCharacterProperty.getNameColor(self)
    return self.name_color
end
function CCharacterProperty.setNameColor(self, _color)
    self.name_color = _color
end

-- {玩家职业}
function CCharacterProperty.getPro(self)
    return self.pro
end
function CCharacterProperty.setPro(self, _pro)
    self.pro = _pro
end

-- {玩家性别}
function CCharacterProperty.getSex(self)
    return self.sex
end
function CCharacterProperty.setSex(self, _sex)
    self.sex = _sex
end

-- {玩家等级}
function CCharacterProperty.getLv(self)
    return self.lv
end
function CCharacterProperty.setLv(self, _lv)
    self.lv = _lv
end

-- {竞技排名}
function CCharacterProperty.getRank(self)
    return self.rank
end
function CCharacterProperty.setRank(self, _rank)
    self.rank =_rank
end

-- {阵营类型(见常量)}
function CCharacterProperty.getCountry(self)
    return self.country
end
function CCharacterProperty.setCountry(self, _country)
    self.country = _country
end

-- {家族ID}
function CCharacterProperty.getClan(self)
    return self.clan
end
function CCharacterProperty.setClan(self, _clan)
    self.clan = _clan
end

-- {家族名称}
function CCharacterProperty.getClanName(self)
    return self.clan_name
end
function CCharacterProperty.setClanName(self, _clanName)
    self.clan_name = _clanName
end

-- {家族职位}
function CCharacterProperty.getClanPost(self)
    return self.clan_post
end
function CCharacterProperty.setClanPost(self, _clanPost)
    self.clan_post = _clanPost
end

-- {角色基本属性块2002}
function CCharacterProperty.getAttr(self)
    return self.attr
end
function CCharacterProperty.setAttr(self, _arrt)
    self.attr = _arrt
end

-- {玩家战斗力}
function CCharacterProperty.getPowerful(self)
    return self.powerful
end
function CCharacterProperty.setPowerful(self, _powerful)
    self.powerful = _powerful
end

-- {经验值}
function CCharacterProperty.getExp(self)
    return self.exp
end
function CCharacterProperty.setExp(self, _exp)
    self.exp = _exp
end

-- {下级要多少经验}
function CCharacterProperty.getExpn(self)
    return self.expn
end
function CCharacterProperty.setExpn(self, _expn)
    self.expn = _expn
end

-- {声望值}
function CCharacterProperty.getRenown(self)
    return self.renown
end
function CCharacterProperty.setRenown(self, _renown)
    self.renown = _renown
end

-- {武器皮肤}
function CCharacterProperty.getSkinWeapon(self)
    return self.skin_weapon
end
function CCharacterProperty.setSkinWeapon(self, _skinWeapon)
    self.skin_weapon = _skinWeapon
end

-- {衣服皮肤}
function CCharacterProperty.getSkinArmor(self)
    return self.skin_armor
end
function CCharacterProperty.setSkinArmor(self, _skinArmor)
    self.skin_armor = _skinArmor
end

-- {伙伴数量}
function CCharacterProperty.getCount(self)
    return self.count
end
function CCharacterProperty.setCount(self, _count)
    self.count = _count
end

-- {伙伴ID}
function CCharacterProperty.getPartner(self)
    return self.partner
end
function CCharacterProperty.setPartner(self, _partner)
    self.partner = _partner
end

-- {伙伴状态}
function CCharacterProperty.getStata(self)
    return self.stata
end
function CCharacterProperty.setStata(self, _stata)
    self.stata = _stata
end

-- {装备数量}
function CCharacterProperty.getEquipCount( self)
    return self.equip_count
end
function CCharacterProperty.setEquipCount( self, _equipcount)
    --print("&&&&&&更新装备数量前:",self.equip_count)
    self.equip_count = _equipcount
    print("&&&&&&更新装备数量后:",self.equip_count)
end

-- {装备链表}
function CCharacterProperty.getEquipList( self)
    return self.equip_list
end
function CCharacterProperty.setEquipList( self, _equiplist)
    self.equip_list = _equiplist
    print("&&&&&&更新装备链表："..#self.equip_list)
end

-- {神器装备数量}
function CCharacterProperty.getArtifactEquipCount( self)
    return self.artifacfEquip_count
end
function CCharacterProperty.setArtifactEquipCount( self, _equipcount)
    self.artifacfEquip_count = _equipcount
    print("&&&&&&更新装备数量后:",self.equip_count)
end

-- {神器装备链表}
function CCharacterProperty.getArtifactEquipList( self)
    return self.artifacfEquip_list
end
function CCharacterProperty.setArtifactEquipList( self, _equiplist)
    self.artifacfEquip_list = _equiplist
    print("&&&&&&更新装备链表："..#self.equip_list)
end


-- {是否红名}
function CCharacterProperty.getIsRedName(self)
    return self.isRedName
end
function CCharacterProperty.setIsRedName(self, _isRedName)
    self.isRedName = _isRedName
end

-- {银元}
function CCharacterProperty.getGold(self)
    return self.gold
end
function CCharacterProperty.setGold(self, _gold)
    self.gold = _gold
end

-- {金元}
function CCharacterProperty.getRmb(self)
    return self.rmb
end
function CCharacterProperty.setRmb(self, _rmb)
    self.rmb = _rmb
end

-- {绑定金元}
function CCharacterProperty.getBindRmb(self)
    return self.bind_rmb
end
function CCharacterProperty.setBindRmb(self, _bindRmb)
    self.bind_rmb = _bindRmb
end

-- {当前体力值}
function CCharacterProperty.getSum(self)
    return self.sum
end
function CCharacterProperty.setSum(self, _sum)
    self.sum = _sum
end

-- {最大体力值}
function CCharacterProperty.getMax(self)
    return self.max
end
-- {最大体力值}
function CCharacterProperty.setMax(self, _max)
    self.max = _max
end

-- {自己的vip等级}
function CCharacterProperty.getVipLv(self)
    return self.vipLv
end
function CCharacterProperty.setVipLv(self, _lv)
    self.vipLv = _lv
end

-- {已购买金元总数}
function CCharacterProperty.getVipUp(self)
    return self.vipUp
end
function CCharacterProperty.setVipUp(self, _vipUp)
    self.vipUp = _vipUp
end

-- {队伍ID}
function CCharacterProperty.getTeamID( self )
    if self.teamID == nil or self.teamID == 0 then
        return self.uid
    end
    return self.teamID
end
function CCharacterProperty.setTeamID( self, _teamID )
    self.teamID = _teamID
end
function CCharacterProperty.getIsTeam( self )
    return self.isTeam
end
function CCharacterProperty.setIsTeam( self, _isTeam )
    self.isTeam = _isTeam
end

-- {总战斗力}
function CCharacterProperty.setAllsPower( self, _allsPower )
    self.alls_power = _allsPower
end
function CCharacterProperty.getAllsPower( self )
    return self.alls_power
end

-- {AI}
function CCharacterProperty.getAI(self)
    return self.ai_id
end
function CCharacterProperty.setAI(self, _AI)
    self.ai_id = _AI
end

-- [1262]额外赠送精力 -- 角色
function CCharacterProperty.setBuffValue( self, valueForKey)
    self.buff_value = tonumber( valueForKey)
end
function CCharacterProperty.getBuffValue( self)
    return self.buff_value
end

--技能信息
function CCharacterProperty.setSkillData( self, _data)
    self.m_skillData = _data
end
function CCharacterProperty.getSkillData( self)
    return self.m_skillData
end

-------------------
--后期添加神器


-- {神器Id}
function CCharacterProperty.getMagicId(self)
    return self.magic_id
end
function CCharacterProperty.setMagicId(self, _magic_id)
    self.magic_id = _magic_id
end

-- {扩展1}
function CCharacterProperty.getExt1(self)
    return self.ext1
end
function CCharacterProperty.setExt1(self, _ext1)
    self.ext1 = _ext1
end

-- {扩展2}
function CCharacterProperty.getExt2(self)
    return self.ext2
end
function CCharacterProperty.setExt2(self, _ext2)
    self.ext2 = _ext2
end

-- {扩展3}
function CCharacterProperty.getExt3(self)
    return self.ext3
end
function CCharacterProperty.setExt3(self, _ext3)
    self.ext3 = _ext3
end

-- {扩展4}
function CCharacterProperty.getExt4(self)
    return self.ext4
end
function CCharacterProperty.setExt4(self, _ext4)
    self.ext4 = _ext4
end

-- {扩展5}
function CCharacterProperty.getExt5(self)
    return self.ext5
end
function CCharacterProperty.setExt5(self, _ext5)
    self.ext5 = _ext5
end




--｛当前副本任务显示类型｝
--与服务器下发数据无关
function CCharacterProperty.getTaskInfo( self )
    return self.taskType, self.copyId, self.chapId
end

function CCharacterProperty.getTaskCount( self)
    if self.taskType == _G.Constant.CONST_TASK_TRACE_MATERIAL then
        local id       = self.materialId
        self.haveCount = self : MaterialCountfromBagData(id)
    end
    return self.haveCount, self.allCount
end

function CCharacterProperty.MaterialCountfromBagData(self,_materialId)
    local m_MaterialListData =  _G.g_GameDataProxy : getMaterialList() --材料列表
    local bag_material_count = 0
    if m_MaterialListData ~=nil and _materialId ~= nil then
        for k,v in pairs(m_MaterialListData) do
            if tonumber(_materialId)  == tonumber(v.goods_id)  then
                bag_material_count =tonumber(v.goods_num)             --背包材料数量
                break
            end
        end

    end
    return bag_material_count
end

function CCharacterProperty.setTaskInfo( self, _taskType, _copyId, _chapId,_haveCount,_allCount,_materialId)
    self.taskType   = _taskType    --任务类型， 日常任务， 材料任务， 主线任务
    self.copyId     = _copyId      --任务副本关卡ID
    self.chapId     = _chapId      --任务副本章节节ID
    self.haveCount  = _haveCount   --已有材料数量， 已完成任务次数
    self.allCount   = _allCount    --总需要材料数， 总需要完成任务次数
    self.materialId = _materialId
    print("7788ttt==",_haveCount,_allCount)
end
---------------------------------------------------------

-- {得到函数 以类型}
function CCharacterProperty.getFuncByType( self, _type )
    return self.funList[ _type ]
end

function CCharacterProperty.getStringByType( self, _type)
    local tmpStr = CLanguageManager:sharedLanguageManager():getString("goodss_goods_base_types_base_type_type"..tostring( _type))
    return tmpStr or _type
end


-- {更新数据  根据类型}
function CCharacterProperty.updateProperty( self, _type, _value )
    print("#####玩家/伙伴属性:2", self :getStringByType( _type), _value, self : getName())
    local func = self : getFuncByType( _type )
    if func == nil then
        print("更新战斗类型属性")
        self.attr : updateProperty( _type, _value )
        return
    end
    print( " 基本属性数据：",_value)
    func( self, _value )
end






