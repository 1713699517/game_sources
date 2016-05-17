require "view/Character/Monster"
require "view/Stage/TouchPlayView"

CPlayer = class(CMonster, function( self, _nType )
    if( _nType == nil ) then
        error( "CPlayer _nType == nil" )
        return
    end
    self.m_nType = _nType --人物／npc 4

    self : initAI()
end)


--AI相关参数
function CPlayer.initAI( self )
    self.m_fThinkInterval = 1.0     --怪物反应速度
    self.m_fStartPosX = 300         --怪物出生点
    self.m_fStartPosY = 300
    self.m_fTraceDistance = 600     --追踪距离
    self.m_fAttackInterval = 5.0    --攻击间隔时间

    self.m_nStandupSkillID = 0      --倒地站立

    self.m_nTarget = nil
    self.m_nThoughtSkillId = 0      --确定使用技能ID
    self.m_fThoughtSkillRangeWidth = 0      --确定使用技能范围X
    self.m_fThoughtSkillRangeHeight = 0     --确定使用技能范围Z
    self.m_fThoughtSkillRangeRange = 0      --确定使用技能范围Y

    self.m_fLastThinkTime = 0       --上次反应时间,秒
    self.m_fLastAttackTime = 0      --上次攻击时间,秒

    self.m_fBackTospTime = 0 --回复SP最后时间

    self.m_fTargetAttackDispersion = 0.08 --目标点+攻击距离+分散值
-----------------
end

function CPlayer.playerInit( self, _nUID, _szName, _nSex, _nPro, _nLv, _nCountry, _isRedName, _skinID , _clanId, _clanName)
    self.m_nID = _nUID --玩家ID
    self.m_szName = _szName
    self.m_nSex  = _nSex
    self.m_nPro = _nPro -- 职业
    self.m_nLv = _nLv
    self.m_nCountry = _nCountry --阵营
    self.m_isRedName = _isRedName
    self.m_SkinId = _skinID --人物皮肤

    self.m_nClan = _clan
    self.m_szClanName = _clanName
    self:setClanInfo( _clan, _clanName )
end

function CPlayer.setClanInfo( self, _clanId, _szName )
    self.m_nClan = _clan
    self.m_szClanName = _clanName
    if _clanId == nil or _clanId == 0 then
        if self.m_lpClanName ~= nil then
            self.m_lpClanName:removeFromParentAndCleanup(true)
            self.m_lpClanName = nil
            return
        end
    else
        if _szName == nil then
            _szName = ""
        end
        if self.m_lpClanName == nil then
            self.m_lpClanName = CCLabelTTF : create( "[".._szName.."]", "Marker Felt", 21 )
            self.m_lpNameContainer : addChild( self.m_lpClanName )
            local locationZ = self : getLocationZ()
            self.m_lpClanName : setPosition( ccp( 0, locationZ + 220 ) )
        else
            self.m_lpClanName:setString( "[".._szName.."]" )
        end
        self.m_lpClanName:setColor(ccc3(255, 255, 255))
    end
end

function CPlayer.setPetSkinId( self, _petId )
    if self.m_PetId == _petId then
        return
    end
    self.m_PetId = _petId

    if self.m_PetMC ~= nil then
        self.m_PetMC:removeFromParentAndCleanup(true)
        self.m_PetMC = nil
    end

    if self.m_PetId ~= nil and self.m_PetId ~= 0 and self.m_lpCharacterContainer ~= nil then
        self.m_PetMC = CMovieClip:create("CharacterMovieClip/"..tostring( self.m_PetId ).."_normal.ccbi")
        self.m_lpCharacterContainer:addChild( self.m_PetMC, 10 )
        self.m_PetMC:setPosition( ccp(self.xmlChar.pet_x, self.xmlChar.pet_y ) )
        print("play___idle")
        self.m_PetMC:play("idle")
    end
end

function CPlayer.getPetSkinId( self )
    if self.m_PetId ~= nil then
        return self.m_PetId
    else
        return 0
    end
end

function CPlayer.setMagicSkinId( self, _MagicId )
    if self.m_MagicId == _MagicId then
        return
    end
    self.m_MagicId = _MagicId

    if self.m_MagicMC ~= nil then
        self.m_MagicMC:removeFromParentAndCleanup(true)
        self.m_MagicMC = nil
    end
    if self.m_MagicMC_before ~= nil then
        self.m_MagicMC_before:removeFromParentAndCleanup(true)
        self.m_MagicMC_before = nil
    end
    if self.m_MagicId ~= nil and self.m_MagicId ~= 0 and self.m_lpCharacterContainer ~= nil then
        self.m_MagicMC = CMovieClip:create("CharacterMovieClip/"..tostring( self.m_MagicId ).."_"..tostring(self:getSkinID()).."_normal.ccbi")
        self.m_lpCharacterContainer:addChild( self.m_MagicMC, -10 )
        self.m_MagicMC:setPosition( ccp(self.xmlChar.pet_x, self.xmlChar.pet_y ) )
        self.m_MagicMC:play("idle")

        self.m_MagicMC_before = CMovieClip:create("CharacterMovieClip/"..tostring( self.m_MagicId ).."_"..tostring(self:getSkinID()).."_normal_1.ccbi")
        self.m_lpCharacterContainer:addChild( self.m_MagicMC_before, 100 )
        self.m_MagicMC_before:setPosition( ccp(self.xmlChar.pet_x, self.xmlChar.pet_y ) )
        self.m_MagicMC_before:play("idle")
    end
end


function CPlayer.getSkinID( self )
    return self.m_SkinId
end

function CPlayer.setPro( self, _pro )
    self.m_nPro = _pro
end
function CPlayer.getPro( self )
    return self.m_nPro
end

function CPlayer.setNameColor( self, _nameColor )
    self.m_nNameColor = _nameColor
end
function CPlayer.getNameColor( self )
    return self.m_nNameColor
end

function CPlayer.setSex( self, _sex )
    self.m_nSex = _sex
end
function CPlayer.getSex( self )
    return self.m_nSex
end

function CPlayer.setIsWar( self, _isWar )
    self.m_bIsWar = _isWar
end
function CPlayer.getIsWar( self )
    return self.m_bIsWar
end

function CPlayer.setIsGuide( self, _isGuide )--新手指导员 (0:正常状态|1:指导员)
    self.m_bIsGuide = _isGuide
end
function CPlayer.getIsGuide( self )
    return self.m_bIsGuide
end

function CPlayer.setLeaderUID( self, _leaderUid )
    self.m_nLeaderUid = _leaderUid
end
function CPlayer.getLeaderUID( self )
    return self.m_nLeaderUid
end

function CPlayer.setCountry( self, _country )
    self.m_nCountry = _country
end
function CPlayer.getCountry( self )
    return self.m_nCountry
end

function CPlayer.setCountryPost( self, _countryPost )
    self.m_nCountryPost = _countryPost
end
function CPlayer.getCountryPost( self )
    return self.m_nCountryPost
end

function CPlayer.setClan( self, _clan )--家族
    self.m_nClan = _clan
end
function CPlayer.getClan( self )
    return self.m_nClan
end

function CPlayer.setClanName( self, _clanName )--家族名字
    self.m_szClanName = _clanName
end
function CPlayer.getClanName( self )--家族名字
    return self.m_szClanName
end

function CPlayer.setClanPost( self, _clanPost )--家族职位
    self.m_szClanPost = _clanPost
end
function CPlayer.getClanPost( self )--家族职位
    return self.m_szClanPost
end

function CPlayer.setVIP( self, _vip )
    self.m_nVIP = _vip
end
function CPlayer.getVIP( self )
    return self.m_nVIP
end

function CPlayer.setSkinMount( self, _skinMount )--坐骑皮肤
    self.m_nSkinMount = _skinMount
end
function CPlayer.getSkinMount( self )--坐骑皮肤
    return self.m_nSkinMount
end


-- function CPlayer.getExp( self )
--     return self.m_nExp
-- end

-- function CPlayer.setExp( self, _nExp )
--     self.m_nExp = _nExp
-- end

-- function CPlayer.setTitleID( self, _nTitleID )
--     self.m_nTitleID = _nTitleID
-- end

-- function CPlayer.getTitleID( self )
--     return self.m_nTitleID
-- end

-- function CPlayer.upLevel( self )
-- end

-- function CPlayer.uesItems( self, _nItemTemplateID, _nItemID )
--     -- 使用物品 _nItemTemplateID 模板id      _nItemID 数据库id
-- end

-- function CPlayer.wearEquip( self, _nItemTemplateID, _nItemID )
--     -- 穿装备   _nItemTemplateID 模板id      _nItemID 数据库id
-- end

function CPlayer.initTouchSelf( self )

    local function localClickFun ( eventType, arg0, arg1, arg2, arg3 )
        --eventType, obj, x, y
        self : animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        return self : onClickFun (eventType, arg0, arg1, arg2)
    end
    if self.m_lpMovieClip then
        self.m_lpMovieClip : setTouchesPriority( -20 )
        self.m_lpMovieClip : setTouchesEnabled ( true )
        self.m_lpMovieClip : registerControlScriptHandler ( localClickFun, "this CPlayer self.m_lpMovieClip 181"..self:getName())
    end
end

function CPlayer.onClickFun( self, eventType, obj, x, y )
    --print("_G.g_ClickNpc", _G.g_ClickNpc, "  _G.g_isEnterTransport", _G.g_isEnterTransport)
    if obj ~= self.m_lpMovieClip or _G.g_ClickNpc == true or _G.g_isEnterTransport == true then
        return false
    end
    if _G.pCSystemSettingProxy : getStateByType(_G.Constant.CONST_SYS_SET_ROLE_DATA) == 1 then
        return false
    end

    if eventType == "TouchBegan" then
        local collider = self : getCollider ()
        local npcAR = obj:convertToWorldSpaceAR( ccp(0, 0) )
        if collider == nil then
            return
        end
        local npcAR_X = npcAR.x + collider.offsetX
        local npcAR_Y = npcAR.y + collider.offsetZ
        local tmpRect = CCRectMake( npcAR_X, npcAR_Y,
            collider.vWidth,
            collider.vHeight )
        local bTouched = tmpRect:containsPoint( ccp(x,y) )
        if bTouched == true then
            local viewObject = CTouchPlayView( self : getID(), self : getName(), self : getLv() , self :getPro(),  x, y )
            local tempView = viewObject : getShowView( )
            local scene = CCDirector : sharedDirector() : getRunningScene()
            if scene ~= nil and _G.g_Stage : getScene() == scene then
                _G.g_Stage : removeTouchPlayContainerChild()
                container = _G.g_Stage : getTouchPlayContainer()
                if container ~= nil then
                    container : addChild( tempView )
                end
            end

            return true
        end
        return false
    end

end

function CPlayer.onGetItem(self, _itemId)
    local itemNode = _G.Config.goodss:selectSingleNode("goods[@id="..tostring(_itemId).."]")
    local iconName = "Icon/i"..tostring(itemNode:getAttribute("icon"))..".jpg"
    local iconSprite = CSprite:create(iconName)
    local viewSize = CCDirector:sharedDirector():getVisibleSize()
    iconSprite:setPosition(ccp( math.random(-viewSize.width/2,viewSize.width/2),640))
    self.m_lpContainer:addChild( iconSprite, 100 )
    local function onMovedCallback()
        self.m_lpContainer:removeChild(iconSprite, true)
        _G.Scheduler:performWithDelay(0.5, function(dt)
            local texture = CCTextureCache:sharedTextureCache():textureForKey(iconName)
            if texture ~= nil and texture:retainCount() == 1 then
                CCTextureCache:sharedTextureCache():removeTexture(texture)
            end
        end)
    end
    local arr = CCArray:create()
    arr:addObject( CCMoveTo:create(2, ccp(0,50)))
    arr:addObject( CCCallFunc:create(onMovedCallback))
    iconSprite:runAction( CCSequence:create(arr) )
    iconSprite:runAction( CCScaleTo:create(2, 0.2))
end