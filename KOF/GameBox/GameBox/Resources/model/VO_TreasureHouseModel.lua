VO_TreasureHouseModel = class(function(self)

end)
--剩余招财次数
function VO_TreasureHouseModel.getLuckyTimes(self)
	return self.LuckyTimes
end
function VO_TreasureHouseModel.setLuckyTimes(self,LuckyTimes)
	self.LuckyTimes = LuckyTimes
end
--当前是否自动招财
function VO_TreasureHouseModel.getLuckyIsauto (self)
	return self.LuckyIsauto
end
function VO_TreasureHouseModel.setLuckyIsauto(self,LuckyIsauto)
	self.LuckyIsauto = LuckyIsauto
end
--自动招财铜钱
function VO_TreasureHouseModel.getLuckyauto_gold(self)
	return self.Luckyauto_gold
end
function VO_TreasureHouseModel.setLuckyauto_gold(self,Luckyauto_gold)
	self.Luckyauto_gold = Luckyauto_gold
end
--next_rmb
function VO_TreasureHouseModel.getLuckynext_rmb(self)
	return self.Luckynext_rmb
end
function VO_TreasureHouseModel.setLuckynext_rmb(self,Luckynext_rmb)
	self.Luckynext_rmb = Luckynext_rmb
end
--next_gold
function VO_TreasureHouseModel.getLuckynext_gold(self)
	return self.Luckynext_gold
end
function VO_TreasureHouseModel.setLuckynext_gold(self,Luckynext_gold)
	self.Luckynext_gold = Luckynext_gold
end





