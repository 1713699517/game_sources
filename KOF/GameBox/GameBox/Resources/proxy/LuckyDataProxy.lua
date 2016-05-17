--LuckyDataProxy
require "view/view"
require "mediator/mediator"


CLuckyDataProxy = class( view , function( self )

    self.m_bInitialized         = false   
    self.m_currentchapter       = 0


end)

_G.g_LuckyDataProxy = CLuckyDataProxy()

--缓存存放
function CLuckyDataProxy.setInitialized( self, bValue)
    self.m_bInitialized = bValue
end
function CLuckyDataProxy.getInitialized( self)
    return self.m_bInitialized 
end

--剩余招财次数
function CLuckyDataProxy.getLuckyTimes(self)
    return self.LuckyTimes
end
function CLuckyDataProxy.setLuckyTimes(self,LuckyTimes)
    self.LuckyTimes = LuckyTimes
end
--当前是否自动招财
function CLuckyDataProxy.getLuckyIsauto (self)
    return self.LuckyIsauto
end
function CLuckyDataProxy.setLuckyIsauto(self,LuckyIsauto)
    self.LuckyIsauto = LuckyIsauto
end
--自动招财铜钱
function CLuckyDataProxy.getLuckyauto_gold(self)
    return self.Luckyauto_gold
end
function CLuckyDataProxy.setLuckyauto_gold(self,Luckyauto_gold)
    self.Luckyauto_gold = Luckyauto_gold
end
--next_rmb
function CLuckyDataProxy.getLuckynext_rmb(self)
    return self.Luckynext_rmb
end
function CLuckyDataProxy.setLuckynext_rmb(self,Luckynext_rmb)
    self.Luckynext_rmb = Luckynext_rmb
end
--next_gold
function CLuckyDataProxy.getLuckynext_gold(self)
    return self.Luckynext_gold
end
function CLuckyDataProxy.setLuckynext_gold(self,Luckynext_gold)
    self.Luckynext_gold = Luckynext_gold
end










