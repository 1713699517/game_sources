VO_VipUIModel = class( function(self)
    self.lv     = nil
    self.vip_up = nil
end)

-- {自己的vip等级}
function VO_VipUIModel.getLv( self)
	return self.lv
end
function VO_VipUIModel.setLv( self, valueForKey)
    self.lv = valueForKey
end

-- {已购买金元总数}
function VO_VipUIModel.getVipUp( self)
	return self.vip_up
end
function VO_VipUIModel.setVipUp( self, valueForKey)
    self.vip_up = valueForKey
end