require "view/Character/Monster"
require "common/ColorManager"

CPartner = class(CMonster, function( self, _nType )
    if( _nType == nil ) then
        error( "CPartner _nType == nil" )
        return
    end
    self.m_nType = _nType --CONST_PARTNER 2 伙伴

    self : initAI()
end)


function CPartner.partnerInit( self, _property )
    local playCharacter = _G.CharacterManager : getPlayerByID( tonumber(_property : getUid()) )
    print("_property : getUid()",_property : getUid())
    self : init( tostring(_property : getUid() )..tostring(_property : getPartner()),
                _property : getName(),
                _property : getAttr() : getMaxHp(),
                _property : getAttr() : getHp(),
                _property : getAttr() : getSp(),
                _property : getAttr() : getSp(),
                tonumber( playCharacter : getLocationX() ),
                tonumber( playCharacter : getLocationY() ),
                tonumber( _property : getSkinArmor() ) )
    self : setAI( tonumber( _property : getAI() ) )

    local colorNum = _property : getNameColor()
    local rgb = _G.g_ColorManager : getRGB(tonumber(colorNum))
    if rgb ~= nil then
        self : setColor( rgb )
    end
end
