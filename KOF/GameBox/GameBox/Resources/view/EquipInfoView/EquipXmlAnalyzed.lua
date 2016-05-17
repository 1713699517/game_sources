
require "view/view"

CEquipXmlAnalyzed = class(view,function(self)
           -- self : loadResources()
            self.good_id           = nil --物品ID
            
end)

function CEquipTipsView.loadResources(self)
    CConfigurationManager : sharedConfigurationManager():load("config/goods.xml")
    if _G.Config.equip_strens == nil then
        CConfigurationManager : sharedConfigurationManager():load("config/equip_stren.xml")
    end
    CConfigurationManager : sharedConfigurationManager():load("config/equip_enchant.xml")
--base_type_name[k] = CLanguageManager:sharedLanguageManager():getString(tostring(base_type_id)) --属性名称名字
end



-- {物品ID}
function CEquipXmlAnalyzed.getGood_id(self)
    return self.good_id
end
function CEquipXmlAnalyzed.setGood_id(self, _goods_id )
    self.good_id = _good_id
end

--XML
function CEquipXmlAnalyzed.getXMLGoodById( self, _nGoodID )
    return  _G.Config.goodss:selectNode("goods","id",tostring(_nGoodID)) --物品信息
end

function CEquipXmlAnalyzed.getXMLGoodByType( self, _nGoodType )
    return _G.Config.goodss:selectNode("goods","type_sub",tostring(_nGoodType))      --通过孔类型找物品
end


function CEquipXmlAnalyzed.getXMLGoodStren( self, _nGoodID )
    return  _G.Config.equip_strens :selectNode("equip_stren","id",tostring(_nGoodID)) --装备强化信息
end



function CEquipXmlAnalyzed.getXMLGoodByIdAnalyzed( self, _nGoodID )
    --装备宝石XML列表
   local good = self : getXMLGoodById(_nGoodID) --获取宝石信息

    if good ~= nil then

      good[_nGoodID] ={}

      good[_nGoodID]["name"]       = good.name       --装备名字
      good[_nGoodID]["name_color"] = good.name_color --装备名字颜色
      good[_nGoodID]["class"]      = good.class      --装备class
      good[_nGoodID]["remark"]     = good.remark     --装备
      good[_nGoodID]["type"  ]     = good.type       --装备
      good[_nGoodID]["type_sub"]   = good.type_sub   --装备基础类型

      good[_nGoodID]["goods_id"  ] = good.id         --装备id
      good[_nGoodID]["price_type"] = good.price_type --装备
      good[_nGoodID]["price"     ] = good.price      --装备价格
      good[_nGoodID]["lv"     ]    = good.lv         --装备lv

      for i,base_type in pairs(good.base_types[1].base_type) do  --装备的基础属性
        good[_nGoodID]["base_type_count"]      = i
        good[_nGoodID]["base_type"..i]         = {}
        good[_nGoodID]["base_type"..i]["type"] = base_type.type
        good[_nGoodID]["base_type"..i]["v"]    = base_type.v    
      end

      for i,slot in pairs(good.slots[1].slot) do           --装备的镶嵌孔属性
        good[_nGoodID]["slot_count"]      = i
        good[_nGoodID]["slot"..i]         = {}
        good[_nGoodID]["slot"..i]["type"] = slot.type
        good[_nGoodID]["slot"..i]["gem"]  = slot.gem 
        good[_nGoodID]["slot"..i]["v"]    = slot.v 
      end

      return good[_nGoodID]
    end
end













_G.g_EquipXmlAnalyzed = CEquipXmlAnalyzed()