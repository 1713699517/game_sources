VO_GemInlayModel = class(function(self)
                            self.EquipmentId = 1201
                            self.EquipmentName = "帽子"
                            self.Equipment_Solt ={"111","113"}
                            self.Equipment_Gem = {
                                {["GemName"] = "1级红宝石" , ["GemLv"] = 1,["GemRemark"] = "物攻+100,物防+70",["GemPrice"] = 1000,["GemType"] = 113,["GemNextId"] = 20021,["GemNextLv"] = 2,["GemNextRemark"] = "物攻+200,物防+130"},
                                {["GemName"] = "1级红宝石" , ["GemLv"] = 1,["GemRemark"] = "物攻+100,物防+70",["GemPrice"] = 1000,["GemType"] = 113,["GemNextId"] = 20021,["GemNextLv"] = 2,["GemNextRemark"] = "物攻+200,物防+130"},
                                {["GemName"] = "1级红宝石" , ["GemLv"] = 1,["GemRemark"] = "物攻+100,物防+70",["GemPrice"] = 1000,["GemType"] = 113,["GemNextId"] = 20021,["GemNextLv"] = 2,["GemNextRemark"] = "物攻+200,物防+130"}
                            }
                            
end)
--装备
function VO_GemInlayModel.getequipmentId(self)
    return self.EquipmentId
end
function VO_GemInlayModel.setequipmentId(self,EquipmentId)
   self.EquipmentId = EquipmentId
end

function VO_GemInlayModel.getEquipmentName(self)
    return self.EquipmentName
end
function VO_GemInlayModel.setEquipmentName(self,EquipmentName)
   self.EquipmentName = EquipmentName
end

function VO_GemInlayModel.getEquipment_Solt(self)
    return self.Equipment_Solt
end
function VO_GemInlayModel.setEquipment_Solt(self,Equipment_Solt)
   self.Equipment_Solt = Equipment_Solt
end

function VO_GemInlayModel.getEquipment_Gem(self)
    return self.Equipment_Gem
end
function VO_GemInlayModel.setEquipment_Gem(self,Equipment_Gem)
   self.Equipment_Gem = Equipment_Gem
end
--宝石
--[[
                            self.equ_GemName = "红宝石" --宝石名称
                            self.equ_GemLv = 1--宝石等级
                            self.equ_GemRemark = "物攻+100,物防+70"--宝石属性
                            self.equ_GemPrice = 1000--宝石价格
                            self.equ_GemType = 113 --宝石类型
                            self.equ_GemNextId = 20021
                            self.equ_GemNextLV = 2 --下一等级宝石属性
                            self.equ_GemNextRemark ="物攻+200,物防+130"--下一等级宝石属性

function VO_GemInlayModel.getequ_GemName(self)
    return self.equ_GemName
end
function VO_GemInlayModel.setequ_GemName(self,equ_GemName)
   self.equ_GemName = equ_GemName
end

function VO_GemInlayModel.getequ_GemLv(self)
    return self.equ_GemLv
end
function VO_GemInlayModel.setequ_GemLv(self,equ_GemLv)
   self.equ_GemLv = equ_GemLv
end

function VO_GemInlayModel.getequ_GemRemark(self)
    return self.equ_GemRemark
end
function VO_GemInlayModel.setequ_GemRemark(self,equ_GemRemark)
   self.equ_GemRemark = equ_GemRemark
end
-----
function VO_GemInlayModel.getequ_GemPrice(self)
    return self.equ_GemPrice
end
function VO_GemInlayModel.setequ_GemPrice(self,equ_GemPrice)
   self.equ_GemPrice = equ_GemPrice
end

function VO_GemInlayModel.getequ_GemType(self)
    return self.equ_GemType
end
function VO_GemInlayModel.setequ_GemType(self,equ_GemType)
   self.equ_GemType = equ_GemType
end

function VO_GemInlayModel.getequ_GemNextId(self)
    return self.equ_GemNextId
end
function VO_GemInlayModel.setequ_GemNextId(self,equ_GemNextId)
   self.equ_GemNextId = eequ_GemNextId
end

function VO_GemInlayModel.getGemNextLV(self)
    return self.GemNextLV
end
function VO_GemInlayModel.setGemNextLV(self,equ_GemNextLV)
   self.GemNextLV = equ_GemNextLV
end

function VO_GemInlayModel.getGemNextRemark(self)
    return self.GemNextRemark
end
function VO_GemInlayModel.setGemNextRemark(self,equ_GemNextRemark)
   self.GemNextRemark = equ_GemNextRemark
end


--]]

 



