require "view/view"
require "common/Constant"

CCharacterManager = class(view, function(self)
                          self : init()
end)

function CCharacterManager.init( self )
    self : releaseCharacter()
    self.m_lpPlayerArray = {}
    self.m_lpPartnerArray = {}
    self.m_lpMonsterArray = {}
    self.m_lpNpcArray = {}
    self.m_lpPetArray = {}
    self.m_lpTransportArray = {}
    self.m_lpVitroArray = {}
    self.m_lpCharacterArray = {}



    self[_G.Constant.CONST_PLAYER] = self.m_lpPlayerArray    -- [1]玩家 -- 系统
    self[_G.Constant.CONST_PARTNER] = self.m_lpPartnerArray    -- [2]伙伴 -- 系统
    self[_G.Constant.CONST_MONSTER] = self.m_lpMonsterArray    -- [3]怪物 -- 系统
    self[_G.Constant.CONST_NPC] = self.m_lpNpcArray    -- [4]NPC -- 系统
    self[_G.Constant.CONST_PET] = self.m_lpPetArray    -- [5]宠物 -- 系统
    self[_G.Constant.CONST_TRANSPORT] = self.m_lpTransportArray   -- [6]传送点
    self[_G.Constant.CONST_VITRO] = self.m_lpVitroArray   -- [7]离体攻击

end

function CCharacterManager.releaseCharacter( self )
    if self.m_lpCharacterArray == nil then
        return
    end
    -- for k,character in pairs(self.m_lpCharacterArray) do
    --     character : releaseResource()
    -- end
    CMovieClip : releaseAllResource()
end

function CCharacterManager.getCharacter( self )
    return self.m_lpCharacterArray
end
function CCharacterManager.getNpc( self )
    return self.m_lpNpcArray
end
function CCharacterManager.getMonster( self )
    return self.m_lpMonsterArray
end
function CCharacterManager.getTransport( self )
    return self.m_lpTransportArray
end
function CCharacterManager.getPlayer( self )
    return self.m_lpPlayerArray
end

function CCharacterManager.isMonsterEmpty( self )
    for _,monster in pairs( self : getMonster() ) do
        return false
    end
    return true
end

function CCharacterManager.add( self, _lpCharater )
    self : remove( _lpCharater )
    local _nCharacterType = _lpCharater : getType()
    if self[_nCharacterType] ~= nil then
        table.insert( self.m_lpCharacterArray, _lpCharater)
        if _nCharacterType == _G.Constant.CONST_PLAYER then
            self[_nCharacterType][_lpCharater : getID()] = _lpCharater
        else
            table.insert( self[_nCharacterType], _lpCharater)
        end
    end
end

function CCharacterManager.remove( self, _lpCharater )
    local _nCharacterType = _lpCharater : getType()

    if self[_nCharacterType] ~= nil then

        if _nCharacterType == _G.Constant.CONST_PLAYER then
            self[_nCharacterType][_lpCharater : getID()] = nil
        else
            for index, character in pairs(self[_nCharacterType]) do
                if character == _lpCharater then
                    self[_nCharacterType][index] = nil
                    break
                end
            end
        end
    end

    for index, character in pairs(self.m_lpCharacterArray) do
        if character == _lpCharater then
            self.m_lpCharacterArray[index] = nil
            break
        end
    end
end

function CCharacterManager.removeOtherPlayer( self )
    local list = self : getPlayer()
    for id,character in pairs(list) do
        if id ~= _G.g_Stage : getPlay() : getID() then
            _G.g_Stage : removeCharacter(character)
        end
    end
end


function CCharacterManager.getPlayerByID( self, _nID )
    return self.m_lpPlayerArray[_nID]
end

function CCharacterManager.getCharacterByTypeAndID( self, _nCharacterType, _nID )
    if self[_nCharacterType] ~= nil then
        for _,character in pairs(self[_nCharacterType]) do
            if character : getID() == _nID then
                return character
            end
        end
    end
    return nil
end

--{传入自己.和其他人碰撞}
function CCharacterManager.getCharacterByVertex( self, _lpCharater ,_collider)
    local vX, vY, vZ, vWidth, vHeight, vRange = _lpCharater : getConvertCollider(_collider)
    if vX == nil or vY == nil or vZ == nil or vWidth == nil or vHeight == nil or vRange == nil then
        --print("___________",vX, vY, vZ, vWidth, vHeight, vRange, "id",_lpCharater:getID())
        return nil
    end
    --print("___________",vX, vY, vZ, vWidth, vHeight, vRange, "id",_lpCharater:getID())
    local selfRect =  CCRect(vX, vY+vZ, vWidth, vHeight )
    local selfMaxRange = vY  + vRange
    local selfMinRange = vY  - vRange
    vHeight = math.abs(vHeight)
    local ret = {}
    for _,character in pairs( self.m_lpCharacterArray ) do
        if character ~= _lpCharater then
            local chX, chY, chZ, chWidth, chHeight, chRange = character : getWorldCollider()
            if chX ~= nil and chY ~= nil and chZ ~= nil and chWidth ~= nil and chHeight ~= nil and chRange ~= nil then
                chHeight = math.abs(chHeight)

                local otherRect =  CCRect(chX, chY+chZ, chWidth, chHeight )
                if selfRect : intersectsRect(otherRect) then
                    local otherMaxRange = chY + chRange
                    local otherMinRange = chY - chRange

                    if math.abs(selfMaxRange + selfMinRange - otherMaxRange - otherMinRange) <= selfMaxRange - selfMinRange + otherMaxRange - otherMinRange then
                        table.insert( ret, character )
                    end

                end

            end
        end
    end
    return ret
end

--{传入一个人物.和另一个传入人物  做碰撞}
function CCharacterManager.checkColliderByCharacter( self, _lpCharater, _collider , _lpCharater2, _isFlip)
    local vX, vY, vZ, vWidth, vHeight, vRange = _lpCharater : getConvertCollider(_collider,_isFlip)
    if vX == nil or vY == nil or vZ == nil or vWidth == nil or vHeight == nil or vRange == nil then
        --print("___________",vX, vY, vZ, vWidth, vHeight, vRange, "id",_lpCharater:getID())
        return false
    end
    local selfRect =  CCRect(vX, vY+vZ, vWidth, vHeight )
    local selfMaxRange = vY  + vRange
    local selfMinRange = vY  - vRange
    vHeight = math.abs(vHeight)
    local ret = {}
    if _lpCharater2 ~= _lpCharater then
        local chX, chY, chZ, chWidth, chHeight, chRange = _lpCharater2 : getWorldCollider()
        if chX ~= nil and chY ~= nil and chZ ~= nil and chWidth ~= nil and chHeight ~= nil and chRange ~= nil then
            chHeight = math.abs(chHeight)
            local otherRect =  CCRect(chX, chY+chZ, chWidth, chHeight )
            if selfRect : intersectsRect(otherRect) then
                local otherMaxRange = chY + chRange
                local otherMinRange = chY - chRange
                if math.abs(selfMaxRange + selfMinRange - otherMaxRange - otherMinRange) <= selfMaxRange - selfMinRange + otherMaxRange - otherMinRange then
                        return true
                end
                -- if (selfMaxRange >= otherMinRange and selfMinRange < otherMinRange) or
                --     (selfMaxRange >= otherMaxRange and selfMinRange <= otherMaxRange) then
                --     return true
                -- end
            end

        end
    end
    return false
end

_G.CharacterManager = CCharacterManager()