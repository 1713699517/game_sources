PeopleInfo_model =class(function(self)
      
    self.Uid            =nil
    self.Name           =nil
    self.Name_color     =nil
    self.Pro            =nil
    self.Sex            =nil

    self.Lv             =nil
    self.Rank           =nil
    self.Country        =nil
    self.Clan           =nil
    self.ClanName       =nil
      
    self.Powerful       = nil
    self.Exp            = nil
    self.Expn           = nil
    self.Skin_weapon    = nil
    self.Skin_armor     = nil
    self.Count          = nil
    self.Partnerr       = nil
    self.ChangeTable    = nil

    m_role_property = {"暴伤","暴击","抗暴","技攻","技防","物攻","物防","气血","智力","伤害率","免伤率","经验:","等级:","职业:","玩家名字:","竞技排名:","称号","战斗力","命格","抗暴","抗暴","抗暴","抗暴","抗暴"}
                         
     self.PropertTable = {}
                         
     for i = 1,#m_role_property do
         self.PropertTable [m_role_property[i]] = ""
     end
    
    --self.myData1 = {["暴伤"]=1,["破甲"]=12,["暴击"]=9999999,["抗暴"]=9999999,["技攻"]=9999999,["技防"]=9999999,["物攻"]=9999999,["物防"]=9999999,["气血"]=9999999,["力量"]=9999999,["智力"]=9999999,["伤害率"]=999.9,["免伤率"]=999.9,["经验:"]={[1]="9999999",[2] ="9999999"},["等级:"]=1,["职业:"]="战士",["玩家名字:"]="1111",["竞技排名:"]=999,["称号"]="玩家的称号",["战斗力"]= 99999999,["命格"]="命格",["换装备属性"]={["力量"]=10000,["物攻"]=500,["气血"]=200},["技防"]=2333}

    self.CheckTable = {["critharm"] = "暴伤",["wreck"] = "破甲",["crit"] = "暴击",["critres"] = "抗暴",["skillatt"] = "技攻",["skilldef"] = "技防",["strongatt"] = "物攻",["strongdef"] = "物防",["hp"] = "气血",["strong"] = "武力",["magic"] = "内力",["bonus"] = "伤害率",["reduction"] = "免伤率"}

    self.myData2 = "test"
    self.myData3 = 3.33
    self.PvpData = {}
end)

function PeopleInfo_model.setPropertTable( self, data1 )
    self.PropertTable = data1
end
function PeopleInfo_model.getPropertTable(self)
    return self.PropertTable
end

function PeopleInfo_model.setPropertyData(self,data)
    --[[print("PeopleInfo_model.setPropertyData",data)
    for k,v in pairs(self.CheckTable) do
        self.PropertTable[v] = data[k]
        print(k,v,self.PropertTable[v],data[k])
    end
     ]]
    print("PeopleInfo_model.setPropertyData",data)
    for k,v in pairs(data) do
        self.PropertTable[k] = v
    end
end
--self.Uid
function PeopleInfo_model.setUid(self,_value)
	self.Uid = _value
end
function PeopleInfo_model.getUid(self)
	return self.Uid
end

--self.Name
function PeopleInfo_model.setName(self,_value)
	self.Name = _value
end
function PeopleInfo_model.getName(self)
	return self.Name
end

--self.Name_color
function PeopleInfo_model.setName_color(self,_value)
	self.Name_color = _value
end
function PeopleInfo_model.getName_color(self)
	return self.Name_color
end

--self.Pro
function PeopleInfo_model.setPro(self,_value)
	self.Pro = _value
end
function PeopleInfo_model.getPro(self)
	return self.Pro
end

--self.Sex
function PeopleInfo_model.setSex(self,_value)
	self.Sex = _value
end
function PeopleInfo_model.getSex(self)
	return self.Sex
end

--self.Lv
function PeopleInfo_model.setLv(self,_value)
	self.Lv = _value
end
function PeopleInfo_model.getLv(self)
	return self.Lv
end

--self.Rank
function PeopleInfo_model.setRank(self,_value)
	self.Rank = _value
end
function PeopleInfo_model.getRank(self)
	return self.Rank
end

--self.Country
function PeopleInfo_model.setCountry(self,_value)
	self.Country = _value
end
function PeopleInfo_model.getCountry(self)
	return self.Country
end

--self.Clan
function PeopleInfo_model.setClan(self,_value)
	self.Clan = _value
end
function PeopleInfo_model.getClan(self)
	return self.Clan
end

--self.ClanName
function PeopleInfo_model.setClanName(self,_value)
	self.ClanName = _value
end
function PeopleInfo_model.getClanName(self)
	return self.ClanName
end

--self.Powerful
function PeopleInfo_model.setPowerful(self,_value)
	self.Powerful = _value
end
function PeopleInfo_model.getPowerful(self)
	return self.Powerful
end

--self.Exp
function PeopleInfo_model.setExp(self,_value)
	self.Exp = _value
end
function PeopleInfo_model.getExp(self)
	return self.Exp
end

--self.Expn
function PeopleInfo_model.setExpn(self,_value)
	self.Expn = _value
end
function PeopleInfo_model.getExpn(self)
	return self.Expn
end

--self.Skin_weapon
function PeopleInfo_model.setSkin_weapon(self,_value)
	self.Skin_weapon = _value
end
function PeopleInfo_model.getSkin_weapon(self)
	return self.Skin_weapon
end

--self.Skin_armor
function PeopleInfo_model.setSkin_armor(self,_value)
	self.Skin_armor = _value
end
function PeopleInfo_model.getSkin_armor(self)
	return self.Skin_armor
end

--self.Count
function PeopleInfo_model.setCount(self,_value)
	self.Count = _value
end
function PeopleInfo_model.getCount(self)
	return self.Count
end

--self.Partner
function PeopleInfo_model.setPartner(self,_value)
	self.Partner = _value
end
function PeopleInfo_model.getPartner(self)
	return self.Partner
end

--获取更改装备的数据表
function PeopleInfo_model.setChangeTable(self,_value)
    self.ChangeTable = _value
end

--获取更改装备的数据表
function PeopleInfo_model.getChangeTable(self)
    return self.ChangeTable
end
    
