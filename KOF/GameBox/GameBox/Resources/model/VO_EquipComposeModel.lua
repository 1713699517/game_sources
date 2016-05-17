VO_EquipComposeModel = class(function(self)
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
function VO_EquipComposeModel.getequipmentId(self)
    return self.EquipmentId
end
function VO_EquipComposeModel.setequipmentId(self,EquipmentId)
   self.EquipmentId = EquipmentId
end

function VO_EquipComposeModel.getEquipmentName(self)
    return self.EquipmentName
end
function VO_EquipComposeModel.setEquipmentName(self,EquipmentName)
   self.EquipmentName = EquipmentName
end

function VO_EquipComposeModel.getEquipment_Solt(self)
    return self.Equipment_Solt
end
function VO_EquipComposeModel.setEquipment_Solt(self,Equipment_Solt)
   self.Equipment_Solt = Equipment_Solt
end

function VO_EquipComposeModel.getEquipment_Gem(self)
    return self.Equipment_Gem
end
function VO_EquipComposeModel.setEquipment_Gem(self,Equipment_Gem)
   self.Equipment_Gem = Equipment_Gem
end

----
function VO_EquipComposeModel.getEquipinitnum(self)
    return self.Equipminitnumm
end
function VO_EquipComposeModel.setEquipinitnum(self,initnum)
    print("VO_EquipComposeModel.setEquipinitnum=",initnum)
    self.Equipminitnumm = initnum
end


 



