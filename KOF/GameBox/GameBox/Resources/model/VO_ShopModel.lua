
VO_ShopModel = class(function(self)

end)
--店铺类型
function VO_ShopModel.getType(self)
    return self.Type
end
function VO_ShopModel.setType(self,_data)
    self.Type = _data
end

--子店铺类型
function VO_ShopModel.getTypeBb(self)
    return self.TypeBb
end
function VO_ShopModel.setTypeBb(self,_data)
    self.TypeBb = _data
end

--物品数量
function VO_ShopModel.getCount(self)
    return self.Count
end
function VO_ShopModel.setCount(self,_data)
    self.Count = _data
end

--信息块
function VO_ShopModel.getMsg(self)
    return self.Msg
end
function VO_ShopModel.setMsg(self,_data)
    self.Msg = _data
end

--结束时间
function VO_ShopModel.getEndTime(self)
    return self.EndTime
end
function VO_ShopModel.setEndTime(self,_data)
    self.EndTime = _data
end


