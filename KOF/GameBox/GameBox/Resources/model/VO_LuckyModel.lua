VO_LuckyModel = class(function(self)
self.LuckyTimes  = 0
self.LuckyIsauto = 0
self.Luckyauto_gold = 888
self.Luckynext_gold = 889
self.Luckynext_rmb  = 999
end)
--剩余招财次数
function VO_LuckyModel.getLuckyTimes(self)
return self.LuckyTimes
end
function VO_LuckyModel.setLuckyTimes(self,LuckyTimes)
self.LuckyTimes = LuckyTimes
end
--当前是否自动招财
function VO_LuckyModel.getLuckyIsauto (self)
return self.LuckyIsauto
end
function VO_LuckyModel.setLuckyIsauto(self,LuckyIsauto)
self.LuckyIsauto = LuckyIsauto
end
--自动招财铜钱
function VO_LuckyModel.getLuckyauto_gold(self)
return self.Luckyauto_gold
end
function VO_LuckyModel.setLuckyauto_gold(self,Luckyauto_gold)
self.Luckyauto_gold = Luckyauto_gold
end
--next_rmb
function VO_LuckyModel.getLuckynext_rmb(self)
return self.Luckynext_rmb
end
function VO_LuckyModel.setLuckynext_rmb(self,Luckynext_rmb)
self.Luckynext_rmb = Luckynext_rmb
end
--next_gold
function VO_LuckyModel.getLuckynext_gold(self)
return self.Luckynext_gold
end
function VO_LuckyModel.setLuckynext_gold(self,Luckynext_gold)
self.Luckynext_gold = Luckynext_gold
end





