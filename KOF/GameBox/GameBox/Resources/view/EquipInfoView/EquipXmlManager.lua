
require "view/view"
require "view/EquipInfoView/EquipXmlAnalyzed"

CEquipXmlManager = class(view,function(self)
     self.m_xmlgoodsList    = {} --物品列表 
end)

function CEquipTipsView.loadResources(self)
    CConfigurationManager : sharedConfigurationManager():load("config/goods.xml")
    if _G.Config.equip_strens == nil then
        CConfigurationManager : sharedConfigurationManager():load("config/equip_stren.xml")
    end
    if _G.Config.equip_makes == nil then
        CConfigurationManager : sharedConfigurationManager():load("config/equip_make.xml")
    end
    CConfigurationManager : sharedConfigurationManager():load("config/equip_enchant.xml")
--base_type_name[k] = CLanguageManager:sharedLanguageManager():getString(tostring(base_type_id)) --属性名称名字
end


function CEquipTipsView.getXMLGoodById( self, _nGoodID )
    return  _G.Config.goodss:selectNode("goods","id",tostring(_nGoodID)) --物品信息
end

function CEquipTipsView.getXMLGoodByType( self, _nGoodType )
    return _G.Config.goodss:selectNode("goods","type_sub",tostring(_nGoodType))      --通过孔类型找物品
end


function CEquipTipsView.getXMLGood( self, _nGoodID )
    return  _G.Config.equip_strens :selectNode("equip_stren","id",tostring(_nGoodID)) --装备强化信息
end




--初始化
function CEquipTipsView.initGoodsList(self,_goods_id)
    self.m_oneGood =  CEquipXmlAnalyzed ()
    self.m_oneGood : setGood_id( _goods_id )
    self           : addGood(self.m_oneGood)
end

--添加物品
function CEquipTipsView.addGood( self, good )

    if good ~= nil then
    local  id = good : getGood_id()
    self.m_xmlgoodsList[id] = {}
    self.m_xmlgoodsList[id] = good : getXMLGoodByIdAnalyzed(id)
    end
end

_G.g_EquipXmlManager = CEquipXmlManager()


