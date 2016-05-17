--BackpackLayer
require "view/view"
require "mediator/mediator"


CGameDataProxy = class(view, function( self)
    self.m_bInitialized  = false
    self.m_goodscount    = 0
    self.m_clanlv        = 0
    self.m_maxcapacity   = 40
    self.m_backpacklist  = {}
    self.m_roleequiplist = {}
    self.m_allcurrency   = {}   --金币 银币 人民币

    self.FriendRecommendData    = {}
    self.InviteFriendsData      = {}
    self.InviteFriendsIconCount = 0

    self.IsActivityIconCCBIcreate = 0 --精彩活动特效变量
    self.isActivenessCCBIHere     = false
end)

_G.g_GameDataProxy = CGameDataProxy()
--缓存存放

function CGameDataProxy.setInitialized(self, _bValue)
    print("CGameDataProxy.setInitializedXXXXX")
    self.m_bInitialized = _bValue
end
function CGameDataProxy.getInitialized(self)
    print("CGameDataProxy.getInitializedYYYYY")
    return self.m_bInitialized
end

--背包当前最大容量
function CGameDataProxy.setMaxCapacity( self, _data)
    print("CGameDataProxy.setMaxCapacity",_data)

    self.m_maxcapacity = _data
end
function CGameDataProxy.getMaxCapacity( self)
	print("CGameDataProxy.getMaxCapacity",self.m_maxcapacity)

    return self.m_maxcapacity
end

--背包中的物品数量
function CGameDataProxy.setGoodsCount( self, _data)
    print("CGameDataProxy.setGoodsCount",_data)
	self.m_goodscount = _data
end
function CGameDataProxy.getGoodsCount( self)
	print("CGameDataProxy.getGoodsCount",self.m_goodscount)
	return self.m_goodscount
end

--table
--背包中所有物品list
function CGameDataProxy.setBackpackList(self,_data)
    print("CGameDataProxy.setBackpackList",_data)
 	self.m_backpacklist =_data
end
function CGameDataProxy.getBackpackList(self)
    return self.m_backpacklist
end

--临时背包中物品list
function CGameDataProxy.setTemporaryBackpackList( self, _data)
	self.m_temporarybackpacklist = _data
end
function CGameDataProxy.getTemporaryBackpackList( self)
	return self.m_temporarybackpacklist
end

--背包中装备list
function CGameDataProxy.setEquipmentList( self, _data)
	self.m_equipmentlist = _data
end
function CGameDataProxy.getEquipmentList( self)
	return self.m_equipmentlist
end

--背包中装备list
function CGameDataProxy.setEquipAndExpList( self, _data)
    self.m_equipandexplist = _data
end
function CGameDataProxy.getEquipAndExpList( self)
    return self.m_equipandexplist
end

--背包中宝石list
function CGameDataProxy.setGemstoneList( self, _data)
	self.m_gemstonelist = _data
end
function CGameDataProxy.getGemstoneList( self)
	return self.m_gemstonelist
end

--背包中神器list
function CGameDataProxy.setArtifactList( self, _data)
	self.m_artifactlist = _data
end
function CGameDataProxy.getArtifactList( self)
	return self.m_artifactlist
end


--背包中道具list
function CGameDataProxy.setPropsList( self, _data)
	self.m_propslist = _data
end
function CGameDataProxy.getPropsList( self)
	return self.m_propslist
end

--背包中材料list
function CGameDataProxy.setMaterialList( self, _data)
	self.m_materiallist = _data
end
function CGameDataProxy.getMaterialList( self)
	return self.m_materiallist
end

--角色身上装备list
function CGameDataProxy.setRoleEquipListByPartner( self, _data, _partner)
	print( "CGameDataProxy.setRoleEquipList")
    self.m_roleequiplist[_partner] = _data
end
function CGameDataProxy.getRoleEquipListByPartner( self, _partner)
	print( "CGameDataProxy.getRoleEquipList")
    return self.m_roleequiplist[_partner]
end

-- 帮派等级   临时使用
function CGameDataProxy.setClanLv( self, _data)
    self.m_clanlv = _data
end
function CGameDataProxy.getClanLv( self)
    return self.m_clanlv
end

--各种货币
function  CGameDataProxy.setAllCurrency( self, _data)
	self.m_allcurrency = _data
end
function CGameDataProxy.getAllCurrency( self)
	return self.m_allcurrency
end
function CGameDataProxy.getGold( self)
	return self.m_allcurrency.gold
end
function CGameDataProxy.getRmb( self)
	return self.m_allcurrency.rmb
end
function CGameDataProxy.getBindRmb( self)
	return self.m_allcurrency.bind_rmb
end
---------------------------------------------------------------

function CGameDataProxy.setItem( self,_data)
    self.Item_Data = _data
end

function CGameDataProxy.getItem( self, _id)
    return self.Item_Data
end

function CGameDataProxy.getGoodById( self, _data)
	local good_id = tostring( _data)
    _G.Config:load("config/goods.xml")
	local goodsnode = _G.Config.goodss:selectSingleNode("goods[@id="..good_id.."]")
    if goodsnode :isEmpty() == false then
        return goodsnode
    end
    return nil
end

--郭俊志 2013.08.28 好友推荐常量值存储
function CGameDataProxy.setIsFriendRecommend(self,_data)
    self.IsFriendRecommend = _data
end
function CGameDataProxy.getIsFriendRecommend(self)
    return self.IsFriendRecommend
end

function CGameDataProxy.setFriendRecommendData(self,_data)
    self.FriendRecommendData = _data
end
function CGameDataProxy.getFriendRecommendData(self)
    return self.FriendRecommendData
end
--jun 2013.10.11 好友邀请常量存储
function CGameDataProxy.setInviteFriendsData(self,_data) --判断按了没有
    self.InviteFriendsData = _data
end
function CGameDataProxy.getInviteFriendsData(self)
    return self.InviteFriendsData
end

function CGameDataProxy.setInviteFriendsIconCount(self,_data) --判断有几个好友邀请图标
    self.InviteFriendsIconCount = _data
end
function CGameDataProxy.getInviteFriendsIconCount(self)
    return self.InviteFriendsIconCount
end

function CGameDataProxy.setIsInviteFriends(self,_data) --存储的好友邀请数据
    self.IsInviteFriends = _data
end
function CGameDataProxy.getIsInviteFriends(self)
    return self.IsInviteFriends
end

function CGameDataProxy.setIsActivityIconCCBIcreate(self,_data) --存储精彩活动特效只在第一次创建一次
    self.IsActivityIconCCBIcreate = _data
end
function CGameDataProxy.getIsActivityIconCCBIcreate(self)
    return self.IsActivityIconCCBIcreate
end


function CGameDataProxy.setIsActivenessCCBIHere( self, _bool )
    self.isActivenessCCBIHere = _bool
end
function CGameDataProxy.getIsActivenessCCBIHere( self, _bool )
    return self.isActivenessCCBIHere
end
