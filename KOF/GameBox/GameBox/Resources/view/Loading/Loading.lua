require "view/view"
require "view/Map/Maptable"
require "common/PathCheck"

--功能开放
require "proxy/FunctionOpenProxy"

CLoadingScenes = class(  )

function CLoadingScenes.create( self, _mapID,  _func )

    local winSize = CCDirector :sharedDirector() : getWinSize()

    self.m_nMapID = _mapID
    local scenec = CCScene : create()
    self.m_lpResourcesLoader = CResourceLoader:sharedResourceLoader()
    --self.m_lpResourcesLoader : clearUnusedResources()
    self : resourcesLoad()
    --self : initSiler()


    PathCheck : pathExists("Loading/ProgressBack.png")
    PathCheck : pathExists("Loading/ProgressF.png")
    PathCheck : pathExists("Loading/transparent.png")

    self.m_lpBackground = CCSprite:create("Loading/loading2_underframe.jpg")
    self.m_lpBackground : setPosition( ccp( winSize.width / 2, winSize.height / 2) )
    scenec : addChild(self.m_lpBackground)

    self.m_pProgressBackground = CCScale9Sprite:create("Loading/loading2_strip_frame.png")
    self.m_pProgressBackground:setPreferredSize(CCSizeMake(547, 12))
    self.m_pProgressBackground:setPosition(ccp(winSize.width/2, 70))
    scenec : addChild( self.m_pProgressBackground )

    self.m_pProgressTransparentBackground = CCSprite:create("transparent.png")
    self.m_pProgressTransparentBackground:setContentSize(CCSizeMake(self.m_pProgressBackground:getPreferredSize().width - 20.0,1.0))
    self.m_pProgressProcess    = CCSprite:create("Loading/loading2_strip.png")
    self.m_pProgressThumb      = CCSprite:create()
    self.m_pProgressThumbCCBI      = CMovieClip:create("CharacterMovieClip/effects_loading.ccbi")
    if self.m_pProgressThumbCCBI ~= nil then
        self.m_pProgressThumbCCBI:play("effects_loading")
        self.m_pProgressThumb:addChild(self.m_pProgressThumbCCBI)
    end

    self.m_lpSlider = CSliderControl:createWithCCSprite(self.m_pProgressTransparentBackground, self.m_pProgressProcess, self.m_pProgressThumb)

    --self.m_lpSlider = CSliderControl:create( "Loading/ProgressBack.png",
    --                                        "Loading/ProgressF.png",
    --                                        "Loading/transparent.png")

    self.m_lpSlider : setSliderValue(0)
    self.m_lpSlider : setPosition(ccp(winSize.width/2,70))
    self.m_lpSlider : setTouchesEnabled(false)
    scenec : addChild(self.m_lpSlider)

    local function onLoadComplete(evenType, _schedule, _allSchedule)
        if self.m_pProgressThumbCCBI ~= nil then
            self.m_pProgressThumb:removeChild(self.m_pProgressThumbCCBI, true)
        end
        _func(evenType, _schedule, _allSchedule)
    end

    self.m_lpResourcesLoader : addLuaEventListener("LoadComplete",onLoadComplete)
    self.m_lpResourcesLoader : addLuaEventListener("LoadProgress",_func)
    self.m_lpResourcesLoader : startLoad()
    return scenec
end

function CLoadingScenes.setPercentage( self, _value )
    self.m_lpSlider : setSliderValue(_value)
end


function CLoadingScenes.initSiler( self )
end

function CLoadingScenes.resourcesLoad( self )
    self : loadMapResources()
    self : loadNPCResources()
    self : loadPlayResources()
    self : loadCommomResources()
    self : loadJoyStickKeyBoardResources()
    self : loadXML()
end

function CLoadingScenes.loadMapResources( self )
    if self.m_nMapID == nil then
        return
    end
    mapTable : unload()
    mapTable : load(self.m_nMapID)
    self.m_lpMapData = mapTable : getClone()
    local pathlist = self.m_lpMapData:getMapPath()
    for k,v in pairs( pathlist ) do
        if PathCheck : pathExists( v ) then
            self.m_lpResourcesLoader : appendFile( v )
        end
    end
    local piecePathList = self.m_lpMapData : getMapPiece()
    for k,v in pairs(piecePathList) do
        if PathCheck : pathExists( v ) then

        else
            --CCMessageBox("Loading Piece","ERROR")
            CCLOG("codeError!!!! Loading Piece")
        end
    end
end

function CLoadingScenes.loadNPCResources( self )
    local resourcesPath = {

    }
    self : appendFile( resourcesPath )
end

function CLoadingScenes.loadPlayResources( self )
    local resourcesPath = {
    --"CharacterMovieClip/50001_normal.ccbi",
    }

    --CMovieClip:create("CharacterMovieClip/Player/charmv.ccbi")

    self : appendFile( resourcesPath, false )
end

function CLoadingScenes.loadCommomResources( self )
    local resourcesPath = {
    "UniversalScenes/UniversalScenes.plist", -- 影子..等等 通用的
    "General_battle.plist",--战斗通用界面
    --"ImageBackpack/backpackUI.plist" --按钮和底图通用界面
    }
    self : appendFile( resourcesPath )
end

function CLoadingScenes.loadJoyStickKeyBoardResources( self )
    local resourcesPath = {
    "Joystick/joystick.plist", --手柄
    "skillsResources/skillResources.plist" --手柄按钮
    }
    self : appendFile( resourcesPath )
end

function CLoadingScenes.loadXML( self )
    local resourcesPath = {
    -- "config/skill_effect.xml", --技能效果
    -- "config/skill_collider.xml", --技能碰撞
    -- "config/buff_effect.xml", --buff效果
    -- "config/battle_ai.xml",  --怪物AI
    -- "config/character.xml", --角色状态碰撞
    -- "config/goods.xml", --物品
    -- "config/vitro.xml", --

    -- --------2013.07.31 郭俊志 强化系统xml----------------------
    -- "config/equip_enchant.xml"
    -- ,"config/pearl_com.xml"
    -- ,"config/equip_stren.xml"
    -- ,"config/equip_make.xml"
    -- ,"config/equip_enchant.xml"


    -- ,"config/battle_speed.xml"
    }
    self : appendFile( resourcesPath )

end

function CLoadingScenes.appendFile( self, _resourcesPath, isAdd )
    for k,path in pairs(_resourcesPath) do
        if PathCheck : pathExists(path) and isAdd ~= false then
            self.m_lpResourcesLoader : appendFile( path )
        end
    end
end