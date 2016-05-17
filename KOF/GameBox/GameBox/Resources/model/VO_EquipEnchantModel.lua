VO_EquipEnchantModel = class(function(self)
    self.myData1 = 100
    self.myData2 = "gemInlayScence"
    self.myData3 = 6.07

    self.myiconnamelabels     = {[1] = "Equip_IconBox.png",[2] = "Equip_IconBox.png",[3] = "Equip_IconBox.png",[4] = "Equip_IconBox.png",[5] = "Equip_IconBox.png",[6] = "Equip_IconBox.png"}
    self.myicon_NameTextLabel = {[1] = "道具11",[2] = "道具12",[3] = "道具13",[4] = "道具14",[5] = "道具15",[6] = "道具16"}
    self.myicon_LVTextLabel   = {[1] = "1",[2] = "11",[3] = "2",[4] = "22",[5] = "3",[6] = "33"}
    self.myicon_PhotoNames    = {[1] = "Equip_IconBox.png",[2] = "Equip_IconBox.png",[3] = "Equip_IconBox.png",[4] = "Equip_IconBox.png",[5] = "Equip_IconBox.png",[6] = "Equip_IconBox.png"}
    self.mynamelabels         = {[1] = "1火影0",[2] = "2忍者0",[3]="3鸣人0",[4]="4佐助0"}


    self.mym_IconDetailName  = "Equip_IconBox.png"
    self.mym_IconName        = "手枪"
    self.mym_JieShuLabel     = "8"
    self.mym_NowJinDuLabel   = "55"
    self.mym_NextJinDuLabel  = "65"
    self.mym_NowJingYanLabel = "55555"
    self.mym_DaoJuName       = "魔石"
    self.mym_ShuLiangLabel   = 11
    self.mym_XiaoHaoLabel    = 123


end)
--附魔装备栏区域
function VO_EquipEnchantModel.geticonnamelabels(self)
    return self.myiconnamelabels
end
function VO_EquipEnchantModel.seticonlabels(self,iconnamelabels)
   self.myiconnamelabels=iconnamelabels
end


function VO_EquipEnchantModel.geticon_NameTextLabel(self)
    return self.myicon_NameTextLabel
end
function VO_EquipEnchantModel.seticon_NameTextLabel(self,icon_NameTextLabel)
   self.myicon_NameTextLabel=icon_NameTextLabel
end


function VO_EquipEnchantModel.geticon_LVTextLabel(self)
    return  self.myicon_LVTextLabel
end
function VO_EquipEnchantModel.seticon_LVTextLabel(self,icon_LVTextLabel)
   self.myicon_LVTextLabel = icon_LVTextLabel
end


function VO_EquipEnchantModel.geticon_PhotoNames(self)
    return  self.myicon_PhotoNames
end
function VO_EquipEnchantModel.seticon_PhotoNames(self,icon_PhotoNames)
   self.myicon_PhotoNames  = icon_PhotoNames
end

function VO_EquipEnchantModel.getnamelabels(self)
    return  self.mynamelabels
end
function VO_EquipEnchantModel.setnamelabels(self,namelabels)
   self.mynamelabels  = icon_PhotoNames
end

--宝附魔装备描述栏区域
function VO_EquipEnchantModel.getm_IconDetailName(self)
    return self.mym_IconDetailName
end
function VO_EquipEnchantModel.setgem_NextLVTextLabel(self,m_IconDetailName)
   self.mym_IconDetailName=m_IconDetailName
end

function VO_EquipEnchantModel.getm_IconName(self)
    return self.mym_IconName
end
function VO_EquipEnchantModel.setm_IconName(self,m_IconName)
   self.mym_IconName=m_IconName
end

function VO_EquipEnchantModel.getm_JieShuLabel(self)
    return self.mym_JieShuLabel
end
function VO_EquipEnchantModel.setm_JieShuLabel(self,m_JieShuLabel)
   self.mym_JieShuLabel=m_JieShuLabel
end

function VO_EquipEnchantModel.getm_NowJinDuLabel(self)
    return self.mym_NowJinDuLabel
end
function VO_EquipEnchantModel.setm_NowJinDuLabel(self,m_NowJinDuLabel)
   self.mym_NowJinDuLabel=m_NowJinDuLabel
end

function VO_EquipEnchantModel.getm_NextJinDuLabel(self)
    return self.mym_NextJinDuLabel
end
function VO_EquipEnchantModel.setm_NextJinDuLabel(self,m_NextJinDuLabel)
   self.mym_NextJinDuLabel=m_NextJinDuLabel
end

function VO_EquipEnchantModel.getm_NowJingYanLabel(self)
    return self.mym_NowJingYanLabel
end
function VO_EquipEnchantModel.setm_NowJingYanLabel(self,m_NowJingYanLabel)
   self.mym_NowJingYanLabel=m_NowJingYanLabel
end

function VO_EquipEnchantModel.getm_DaoJuName(self)
    return self.mym_DaoJuName
end
function VO_EquipEnchantModel.setm_NowJinDuLabel(self,m_DaoJuName)
   self.mym_DaoJuName=m_DaoJuName
end

function VO_EquipEnchantModel.getm_ShuLiangLabel(self)
    return self.mym_ShuLiangLabel
end
function VO_EquipEnchantModel.setm_ShuLiangLabel(self,m_ShuLiangLabel)
   self.mym_ShuLiangLabel=m_ShuLiangLabel
end


function VO_EquipEnchantModel.getm_XiaoHaoLabel(self)
    return self.mym_XiaoHaoLabel
end
function VO_EquipEnchantModel.setm_XiaoHaoLabel( self,m_XiaoHaoLabel)
self.mym_XiaoHaoLabel = m_XiaoHaoLabel
end

--[[
 local tdata = test_model()
 tdata:setData1(200)
]]

