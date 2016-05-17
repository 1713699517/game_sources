
require "common/AcknowledgementMessage"
--[[
 广播字段类型--角色名字 (组:1)  1      CONST_BROAD_PLAYER_NAME    修改 删
 广播字段类型--家族名字 (组:1) 2       CONST_BROAD_CLAN_NAME   修改 删
 广播字段类型--团队名字 (组:1) 3       CONST_BROAD_GROUP_NAME  修改 删
 广播字段类型--副本Id (组:1) 4        CONST_BROAD_COPY_ID 修改 删
 广播字段类型--普通字符串 (组:1) 50    CONST_BROAD_STRING  修改 删
 广播字段类型--普通数字 (组:1) 51      CONST_BROAD_NUMBER  修改 删
 广播字段类型--地图ID (组:1) 52       CONST_BROAD_MAPID   修改 删
 广播字段类型--阵营ID (组:1) 53       CONST_BROAD_COUNTRYID   修改 删
 广播字段类型--物品ID (组:1) 54       CONST_BROAD_GOODSID 修改 删
 广播字段类型--怪物ID (组:1) 55       CONST_BROAD_MONSTERID   修改 删
 广播字段类型--三界杀卷名ID (组:1)56   CONST_BROAD_CIRCLE_CHAP 修改 删
 广播字段类型--奖励内容 (组:1) 57       CONST_BROAD_REWARD  修改 删
 广播字段类型--取经之路名字 (组:1)58     CONST_BROAD_PILROAD_ID  修改 删
 广播字段类型--颜色 (组:1)   59         CONST_BROAD_NAME_COLOR  修改 删
 广播字段类型--星阵图名字 (组:1)60       CONST_BROAD_STARID  修改 删
 广播字段类型--伙伴名字 (组:1) 61       CONST_BROAD_PARTNER_ID  修改 删
 广播字段类型--获得钱数 (组:1) 62       CONST_BROAD_GOLD
 --]]

-- [811]广播信息块 -- 系统 

ACK_SYSTEM_DATA_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_DATA_XXX
	self:init()
end)


function ACK_SYSTEM_DATA_XXX.deserialize(self, reader)
    print("-- [811]广播信息块 -- 系统 ")
    self.type = reader :readInt8Unsigned() --见常量：CONST_BROAD_*
    print("+++++>>>> ", self.type)
    if self.type == _G.Constant.CONST_BROAD_PLAYER_NAME then      --1     角色名字
        --self.sid           = reader : readInt16Unsigned()  -- {服务器ID}
        self.uid           = reader : readInt32Unsigned()  -- {玩家Uid}
        self.uname         = reader : readString()         -- {玩家名字}     
        self.lv            = reader : readInt16Unsigned()  -- {玩家等级}
        self.color_name    = reader : readInt8Unsigned()   -- {玩家名字颜色}  
        self.pro           = reader : readInt16Unsigned()  -- {玩家职业}
        print(" Uid:",self.uid," Name:",self.uname,"LV:",self.lv,"Coloe:",self.color_name,"Pro:",self.pro) 
    elseif self.type == _G.Constant.CONST_BROAD_CLAN_NAME then    --2     家族名字
        self.clan_name     = reader : readString()         -- {家族名字}        
    elseif self.type == _G.Constant.CONST_BROAD_GROUP_NAME then   --3     团队名字
        self.group_name    = reader : readString()         -- {团队名字}        
    elseif self.type == _G.Constant.CONST_BROAD_COPY_ID then      --4     副本Id
        self.copy_id       = reader : readInt16Unsigned()  -- {副本ID}        
    elseif self.type == _G.Constant.CONST_BROAD_STRING then       --50    普通字符串
        self.string        = reader : readString()         -- {普通字符串}        
    elseif self.type == _G.Constant.CONST_BROAD_NUMBER then       --51    普通数字
        self.number        = reader : readInt32Unsigned()  -- {普通数字}        
    elseif self.type == _G.Constant.CONST_BROAD_MAPID then        --52    地图ID
        self.map_id        = reader : readInt16Unsigned()  -- {地图ID}        
    elseif self.type == _G.Constant.CONST_BROAD_COUNTRYID then    --53    阵营ID
        self.country_id    = reader : readInt8Unsigned()   -- {阵营ID}        
    elseif self.type == _G.Constant.CONST_BROAD_GOODSID then      --54    物品
        --self.goods       = reader : readXXXGroup()       -- {物品信息块} 
        local tempData    = ACK_GOODS_XXX1()
        tempData :deserialize( reader)
        self.goods        = tempData       
    elseif self.type == _G.Constant.CONST_BROAD_MONSTERID then    --55    怪物ID
        self.monster_id    = reader : readInt16Unsigned()  -- {怪物ID}         
    elseif self.type == _G.Constant.CONST_BROAD_CIRCLE_CHAP then  --56    三界杀卷名ID
        self.chap_id       = reader : readInt16Unsigned()  -- {三界杀卷名}        
    elseif self.type == _G.Constant.CONST_BROAD_REWARD then       --57    奖励内容
        self.gold          = reader : readInt32Unsigned()  -- {银元}     
        self.rmb           = reader : readInt32Unsigned()  -- {金元}        
        self.star          = reader : readInt32Unsigned()  -- {星魂}        
        self.renown        = reader : readInt32Unsigned()  -- {声望}        
        self.clan_value    = reader : readInt32Unsigned()  -- {帮贡}        
        self.count         = reader : readInt32Unsigned()  -- {物品数量}          
        --self.goods_msg_no  = reader : readXXXGroup() -- {斗气信息块【48203】}
        self.goods_msg_no = {}  --用下标取物品
        for i=1,self.count do
            print("第 "..i.." 物品:")
            local tempData = ACK_GOODS_XXX1()
            tempData :deserialize( reader)
            self.goods_msg_no[i] = tempData
        end       
    elseif self.type == _G.Constant.CONST_BROAD_PILROAD_ID then   --58    取经之路名字
        self.pilroad_id    = reader : readInt16Unsigned()  -- {取经之路id}        
    elseif self.type == _G.Constant.CONST_BROAD_NAME_COLOR then   --59    名字颜色
        self.color         = reader : readInt8Unsigned()   -- {名字颜色}        
    elseif self.type == _G.Constant.CONST_BROAD_STARID then       --60    星阵图ID
        self.star_id       = reader : readInt16Unsigned()  -- {星阵图ID}
    elseif self.type == _G.Constant.CONST_BROAD_PARTNER_ID then   --61    伙伴名字
        self.partner_id    = reader : readInt16Unsigned()  -- {伙伴名字}
        self.partner_color = reader : readInt8Unsigned()   -- {伙伴名字颜色} 
    elseif self.type == _G.Constant.CONST_BROAD_DOUQI_ID then     --62    获得斗气
        self.douqi_id      = reader : readInt16Unsigned()
    elseif self.type == _G.Constant.CONST_BROAD_VIP_LV then       --63    VIP等级 
        self.vip_lv        = reader : readInt8Unsigned()
    else                                                          -- 未定义
        print("Error ----------- 未定义的广播常量:",self.type)        
    end
end

-- {参数类型(见常量：CONST_BROAD_*)}
function ACK_SYSTEM_DATA_XXX.getType(self)
	return self.type
end

-- {服务器ID}
function ACK_SYSTEM_DATA_XXX.getSid(self)
	return self.sid
end

-- {用户id}
function ACK_SYSTEM_DATA_XXX.getUid(self)
	return self.uid
end

-- {用户名称}
function ACK_SYSTEM_DATA_XXX.getUname(self)
	return self.uname
end

-- {等级}
function ACK_SYSTEM_DATA_XXX.getLv(self)
	return self.lv
end

-- {等级}
function ACK_SYSTEM_DATA_XXX.getPro(self)
	return self.pro
end

-- {名字颜色}
function ACK_SYSTEM_DATA_XXX.getColorName(self)
	return self.color_name
end

-- {家族名字}
function ACK_SYSTEM_DATA_XXX.getClanName(self)
	return self.clan_name
end

-- {团队名字}
function ACK_SYSTEM_DATA_XXX.getGroupName(self)
	return self.group_name
end

-- {副本Id}
function ACK_SYSTEM_DATA_XXX.getCopyId(self)
	return self.copy_id
end

-- {普通字符串}
function ACK_SYSTEM_DATA_XXX.getString(self)
	return self.string
end

-- {普通数字}
function ACK_SYSTEM_DATA_XXX.getNumber(self)
	return self.number
end

-- {地图ID}
function ACK_SYSTEM_DATA_XXX.getMapId(self)
	return self.map_id
end

-- {阵营ID}
function ACK_SYSTEM_DATA_XXX.getCountryId(self)
	return self.country_id
end

-- {物品信息块(2001)}
function ACK_SYSTEM_DATA_XXX.getGoods(self)
	return self.goods
end

-- {怪物ID}
function ACK_SYSTEM_DATA_XXX.getMonsterId(self)
	return self.monster_id
end

-- {三界杀卷名ID}
function ACK_SYSTEM_DATA_XXX.getChapId(self)
	return self.chap_id
end

-- {银元}
function ACK_SYSTEM_DATA_XXX.getGold(self)
	return self.gold
end

-- {金元}
function ACK_SYSTEM_DATA_XXX.getRmb(self)
	return self.rmb
end

-- {星魂}
function ACK_SYSTEM_DATA_XXX.getStar(self)
	return self.star
end

-- {声望}
function ACK_SYSTEM_DATA_XXX.getRenown(self)
	return self.renown
end

-- {帮贡}
function ACK_SYSTEM_DATA_XXX.getClanValue(self)
	return self.clan_value
end

-- {物品数量(循环)}
function ACK_SYSTEM_DATA_XXX.getCount(self)
	return self.count
end

-- {物品信息块(2001)}
function ACK_SYSTEM_DATA_XXX.getGoodsMsgNo(self)
	return self.goods_msg_no
end

-- {取经之路Id}
function ACK_SYSTEM_DATA_XXX.getPilroadId(self)
	return self.pilroad_id
end

-- {名字颜色}
function ACK_SYSTEM_DATA_XXX.getColor(self)
	return self.color
end

-- {星阵图ID}
function ACK_SYSTEM_DATA_XXX.getStarId(self)
	return self.star_id
end

-- {伙伴名字}
function ACK_SYSTEM_DATA_XXX.getPartnerId(self)
	return self.partner_id
end

-- {名字颜色}
function ACK_SYSTEM_DATA_XXX.getColor2(self)
	return self.color2
end

-- {斗气Id}
function ACK_SYSTEM_DATA_XXX.getDouqiId(self)
	return self.douqi_id
end

-- {VIP LV}
function ACK_SYSTEM_DATA_XXX.getVipLv(self)
	return self.vip_lv
end
