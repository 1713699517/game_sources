require "controller/command"

CMoneyChangedCommand = class( command, function( self, VO_data )
	self.type = "TYPE_CMoneyChangedCommand"
	self.data = VO_data
    print("mmmmmm", self.type)
end)


CMoneyChangedCommand.TYPE = "TYPE_CMoneyChangedCommand"
--金钱
CMoneyChangedCommand.MONEY  = "MONEY_CMoneyChangedCommand"
-- (手动) -- [1262]额外赠送精力 -- 角色 
CMoneyChangedCommand.ENERGY = "ENERGY_CMoneyChangedCommand"