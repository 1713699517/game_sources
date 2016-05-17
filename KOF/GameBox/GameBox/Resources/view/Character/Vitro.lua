require "view/Character/Monster"
CVitro = class(CMonster,function( self, _nType )
    if( _nType == nil ) then
        error( "CVitro _nType == nil" )
        return
    end
    self.m_nType = _nType --离体攻击
end)

function CVitro.initVitro( self, _vitroXmlDate, _skillXmlDate, _masterCharacter, _masterUID, _masterType )
    self.m_nMasterID = _masterUID
    self.m_nMasterType = _masterType
    local masterScaleX =  _masterCharacter : getScaleX()
    self.m_lpVitroXmlDateSkill = _skillXmlDate.skill
    self.m_lpVitroXmlDatetype = _skillXmlDate.type
    self.m_nStartX= _skillXmlDate.startX * masterScaleX + _masterCharacter : getLocationX()
    self.m_nStartY= _skillXmlDate.startY  + _masterCharacter : getLocationY()
    self.m_nStartZ= _skillXmlDate.startZ  + _masterCharacter : getLocationZ()
    self.m_nEndX = _skillXmlDate.endX * masterScaleX + _masterCharacter : getLocationX()
    self.m_nEndY = _skillXmlDate.endY   + _masterCharacter : getLocationY()
    self.m_nEndZ = _skillXmlDate.endZ   + _masterCharacter : getLocationZ()

    self.m_cPosX = self.m_nEndX - self.m_nStartX
    self.m_cPosY = self.m_nEndY - self.m_nStartY
    self.m_cPosZ = self.m_nEndZ - self.m_nStartZ
    self.m_cPosSpeed = _skillXmlDate.speed

    self : init(tonumber(_vitroXmlDate:getAttribute("id")),
                "",
                nil,
                nil,
                nil,
                nil,
                self.m_nStartX,
                self.m_nStartY+self.m_nStartZ,
                tonumber(_vitroXmlDate:getAttribute("skin")) )
    self : setLocation( self.m_nStartX, self.m_nStartY, self.m_nStartZ )
    --local buffObject = _G.buffManager : getBuffNewObject( 4 ) --免伤

    self.m_isMove = true
    self.m_isFirstEnter = false
    _G.pDateTime : reset()
    self.m_nVitroTime = _G.pDateTime : getTotalMilliseconds() + _skillXmlDate.useTime

    self : useSkill( tonumber(_vitroXmlDate:getAttribute("skill")) )
    self : setMoveClipContainerScalex( masterScaleX )
end

function CVitro.getMasterUID( self )
    return self.m_nMasterID
end
function CVitro.getMasterType( self )
    return self.m_nMasterType
end

function CVitro.think( self, _now )
    if self.m_nVitroTime <= _now then
        print("结束时间",self.m_nVitroTime,_now)
        _G.g_Stage : removeCharacter( self )
        return
    end
end
function CVitro.onUpdateUseSkill(self, _duration)

    local lastDuration = self.m_nSkillDuration
    self.m_nSkillDuration = self.m_nSkillDuration + _duration
    --循环配置表
    --循环配置表
    local skillNode = _G.g_SkillEffectXmlManager : getByID( self.m_nSkillID )
    if skillNode == nil then
        return
    end
    for _,currentFrame in pairs(skillNode.frame) do
        local currentFrameTime = currentFrame.time
        if currentFrameTime >= lastDuration and currentFrameTime < self.m_nSkillDuration then
            --时间在此之内,则结算当前帧 只运行当前次 然后到下一个
            --检查当前FRAME 的buff添加自身和删除自身未发生碰撞
            self : setColliderXmlByID( currentFrame.be_collider )
            self : handleSkillFrameBuff( currentFrame, 1 ,0, tonumber(self.m_lpVitroXmlDateSkill) )
            _G.StageXMLManager : handleSkillFrameVitro( self, currentFrame )
            local iscollider = self : checkCollisionSkill( skillNode, currentFrame )
            self : removeThrustBuff()
            self : handleSkillFrameEffect( currentFrame )
            --技能攻击音效
            if currentFrame.sound ~= nil and currentFrame.sound ~= 0 then
                if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
                    SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/"..tostring(currentFrame.sound)..".mp3", false)
                end
            end

            --添加连击
            if( (iscollider == true)and(_G.g_Stage : isMainPlay( _G.CharacterManager : getCharacterByTypeAndID(self : getMasterType(), self : getMasterUID()) ) == true))
                or (_G.g_Stage : getScenesType() == _G.Constant.CONST_MAP_TYPE_CHALLENGEPANEL) then
                --打中一次，播放一次受击音效
                if _G.pCSystemSettingProxy:getStateByType(_G.Constant.CONST_SYS_SET_MUSIC) == 1 then
                    SimpleAudioEngine:sharedEngine():playEffect("Sound@mp3/Hit.mp3", false)
                end
                if _G.g_Stage : isMainPlay( _G.CharacterManager : getCharacterByTypeAndID( self : getMasterType(), self : getMasterUID() ) ) == true then
                    _G.g_Stage : addCombo()
                end
                self : addSP(_G.Constant.CONST_BATTLE_HOST_HIT_SP)
            end

            --如果是离体攻击的一次碰撞
            if (iscollider == true) and (tonumber(self.m_lpVitroXmlDatetype) == _G.Constant.CONST_BATTLE_FLYCOLLIDER_2) then
                _G.g_Stage : removeCharacter( self )
                return
            end
        end
    end
end
function CVitro.onUpdateMove( self, _duration )
    if self.m_isMove ~= true then
        return
    end
    local localX = self : getLocationX()
    local localY = self : getLocationY()
    local localZ = self : getLocationZ()
    local moveX = ( self.m_cPosSpeed / math.sqrt(self.m_cPosX*self.m_cPosX + self.m_cPosY*self.m_cPosY + self.m_cPosZ*self.m_cPosZ) * self.m_cPosX ) * _duration + localX
    local moveY = ( self.m_cPosSpeed / math.sqrt(self.m_cPosX*self.m_cPosX + self.m_cPosY*self.m_cPosY + self.m_cPosZ*self.m_cPosZ) * self.m_cPosY ) * _duration + localY
    local moveZ = ( self.m_cPosSpeed / math.sqrt(self.m_cPosX*self.m_cPosX + self.m_cPosY*self.m_cPosY + self.m_cPosZ*self.m_cPosZ) * self.m_cPosZ ) * _duration + localZ


    local movePos  = ccp( moveX,        moveY + moveZ )
    local localPos = ccp( localX,       localY + localZ )
    local endPos   = ccp( self.m_nEndX, self.m_nEndY + self.m_nEndZ )

    local moveDistance = ccpDistance( movePos, localPos )
    local endDistance = ccpDistance( localPos, endPos )

    if endDistance <= moveDistance then
        self.m_isMove = false
        moveX = self.m_nEndX
        moveY = self.m_nEndY
        moveZ = self.m_nEndZ
    end
    self : setLocation( moveX, moveY, moveZ )
end

--动作完成后
function CVitro.onAnimationCompleted( self, eventType, _animationName )

end

function CVitro.setStatus(self, _nStatus)
    if _nStatus == self.m_nStatus then
        return
    end
    local addMovieClip = nil
    local actionName = nil
    local tempCollide = nil
    if _nStatus == _G.Constant.CONST_BATTLE_STATUS_USESKILL then --使用技能时,因技能ID不同,外部调用其播放动画
        addMovieClip = self : getBattleMoveClip()
    end
    if addMovieClip ~= nil then
        self.m_nSkillID = 0
        local container = self : getCharaterContainer()
        if self : getMovieClip() ~= nil then
            self : getMovieClip() : removeFromParentAndCleanup( false )
        end
        if self : getBattleMoveClip() ~= nil then
            self : getBattleMoveClip() : removeFromParentAndCleanup( false )
        end
        container : addChild( addMovieClip )
        if actionName ~= nil then
            addMovieClip : play( actionName )
        end
        self.m_lpCurrentMovieClip = addMovieClip
        self.m_nStatus = _nStatus
        self :setColliderXml( self.m_nStatus, self.m_SkinId )    --默认职业为 1 先
    end
end

function CVitro.setLocation( self, _x, _y, _z )
    _z = _z < 0 and 0 or _z
    if _y + _z < _y then
        return
    end

    self.m_nLocationX = _x
    self.m_nLocationY = _y
    self.m_nLocationZ = _z
    self : setPos()
    self : moveArea()
end