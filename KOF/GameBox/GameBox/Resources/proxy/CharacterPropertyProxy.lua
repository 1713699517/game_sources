require "view/view"
require "proxy/CharacterProperty"
require "proxy/CharacterWarProperty"
require "mediator/CharacterPropertyMediator"



CCharacterPropertyProxy = class( view , function( self )
                        self.m_lpMainPlay = nil --主人物
                        self.m_lpChallengePanePlayInfo = nil -- 逐鹿台PK人物

                        self.m_lpPlayList = {} --其他人物列表
                        self.m_lpPartnerList = {} --伙伴列表
                        self.m_lpMonsterList = {} --怪物列表
                       end)

_G.g_characterProperty = CCharacterPropertyProxy()
-- 09 25 搬移
--_G.pCharacterPropertyMediator = CCharacterPropertyMediator(_G.g_characterProperty)
--_G.controller : registerMediator( _G.pCharacterPropertyMediator )

-- {初始化主角}
function CCharacterPropertyProxy.initMainPlay( self, _uid )
    print("CCharacterPropertyProxy.initMainPlay:".._uid.."/"..type(_uid))
    self.m_lpMainPlay = CCharacterProperty(  )
    self.m_lpMainPlay : setUid( _uid )
    self : addOne( self.m_lpMainPlay, _G.Constant.CONST_PLAYER )
    return self.m_lpMainPlay
end

function CCharacterPropertyProxy.getMainPlay( self )
    return self.m_lpMainPlay
end

function CCharacterPropertyProxy.getChallengePanePlayInfo( self )
    return self.m_lpChallengePanePlayInfo
end
function CCharacterPropertyProxy.setChallengePanePlayInfo( self, _info )
    self.m_lpChallengePanePlayInfo = _info
end

-- {获取人物属性}
function CCharacterPropertyProxy.getOneByUid( self, _uid, _characterType )

    if _uid == 0 then
        return self.m_lpMainPlay
    else
        if _G.Constant.CONST_PLAYER == _characterType then
            return self.m_lpPlayList[_uid]
        elseif _G.Constant.CONST_PARTNER == _characterType then
            return self.m_lpPartnerList[_uid]
        elseif _G.Constant.CONST_MONSTER == _characterType then
            return self.m_lpMonsterList[_uid]
        end
    end
end

-- {更新人物属性}
function CCharacterPropertyProxy.updateSomeOne( self, uid, _type, _value, _characterType )
    local play = self : getOneByUid( uid, _characterType )
    if play == nil then
        return
    end
    play : updateProperty( _type, _value )
end

-- {清空人物内存}
function CCharacterPropertyProxy.cleanUp( self )
    CCLOG("~!@#$^&: 清除人物属性缓存")
    self.m_lpPlayList = {}
    if self.m_lpMainPlay ~= nil then
        CCLOG("~!@#$^&: 保存主角人物属性UID:"..tostring(self.m_lpMainPlay : getUid()))
        local mainPlayUid = self.m_lpMainPlay : getUid()
        self.m_lpPlayList[ mainPlayUid ] = self.m_lpMainPlay
        if self.m_lpChallengePanePlayInfo ~= nil then
            CCLOG("~!@#$^&: 在竞技场里面对手UID："..tostring(self.m_lpChallengePanePlayInfo : getUid()))
            local pkPlayUid = self.m_lpChallengePanePlayInfo : getUid()
            if pkPlayUid ~= nil then
                CCLOG("~!@#$^&: 保存对手人物属性")
                self.m_lpPlayList[ pkPlayUid ] = self.m_lpChallengePanePlayInfo
            end
        end
    end
    self.m_lpMonsterList = {}

    local list = {}
    for uid,info in pairs(self.m_lpPartnerList) do
        CCLOG("~!@#$^&:伙伴主人UID:"..tostring(info : getUid()).." 伙伴Index: "..tostring(uid))
        if info : getUid() == self.m_lpMainPlay : getUid() then
            CCLOG("~!@#$^&:保存主角伙伴属性index: "..tostring(uid).." UID: "..tostring(self.m_lpMainPlay : getUid()))
            list[uid] = info
        end
        if self.m_lpChallengePanePlayInfo ~= nil then
            if info : getUid() == self.m_lpChallengePanePlayInfo : getUid() then
                CCLOG("~!@#$^&:保存对手伙伴属性index: "..tostring(uid).." 对手UID: "..tostring( self.m_lpChallengePanePlayInfo : getUid()))
                list[uid] = info
            end
        end
    end
    self.m_lpPartnerList = list
end

-- {添加某一个}
function CCharacterPropertyProxy.addOne( self, _characterProperty, _characterType )
    if _G.Constant.CONST_PLAYER == _characterType then
        self.m_lpPlayList[_characterProperty : getUid()] = _characterProperty
    elseif _G.Constant.CONST_PARTNER == _characterType then
        local index      = tostring( _characterProperty : getUid())..tostring(_characterProperty : getPartner())
        self.m_lpPartnerList[index] = _characterProperty
    elseif _G.Constant.CONST_MONSTER == _characterType then
        self.m_lpMonsterList[_characterProperty : getUid()] = _characterProperty
    end
end

-- {移除某一个.主角除外}
function CCharacterPropertyProxy.removeOne( self, _uid, _characterType )
    print( " CCharacterPropertyProxy.removeOne:", _uid, _characterType)
    if _G.Constant.CONST_PLAYER == _characterType then
        if _uid == self.m_lpMainPlay:getID() then
            return
        end
        self.m_lpPlayList[_uid] = nil
    elseif _G.Constant.CONST_PARTNER == _characterType then
        self.m_lpPartnerList[_uid] = nil
    elseif _G.Constant.CONST_MONSTER == _characterType then
        self.m_lpMonsterList[_uid] = nil
    end
end

function CCharacterPropertyProxy.resetMainPlayHp( self )
    local mainHp = self.m_lpMainPlay : getAttr() : getNowMaxHp()
    self.m_lpMainPlay : getAttr() : setHp(mainHp)
    local partnerID_List = self.m_lpMainPlay : getPartner()
    if partnerID_List ~= nil then
        for k,partnerID_Property in pairs(partnerID_List) do
            local index = tostring(self.m_lpMainPlay : getUid())..tostring(partnerID_Property)
            local partnerProperty = self : getOneByUid( index ,_G.Constant.CONST_PARTNER)
            if partnerProperty ~= nil then
                local partnerMaxHp = partnerProperty : getAttr() : getNowMaxHp()
                partnerProperty : getAttr() : setHp(partnerMaxHp)
            end
        end
    end
end
