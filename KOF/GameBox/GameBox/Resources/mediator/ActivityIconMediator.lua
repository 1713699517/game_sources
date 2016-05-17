require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
require "controller/ActivityIconCommand"
--require "controller/DailyTaskCommand"
--08.09 hlc add 
require "controller/DailyTaskCommand"
require "controller/TaskNewDataCommand"


CActivityIconMediator = class( mediator, function( self, _view )
	self.m_name = "CActivityIconMediator"
	self.m_view = _view

	print("CActivityIconMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CActivityIconMediator.getView( self )
	-- body
	return self.m_view
end


function CActivityIconMediator.getName( self )
	return self.m_name
end


function CActivityIconMediator.processCommand( self, _command )
	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()

        --CCLOG("CActivityIconMediator.processCommand")
        --郭俊志 2013.07.26
        if msgID == _G.Protocol["ACK_WEAGOD_REPLY"] then  --接受到招财面板返回 32020
			self : ACK_WEAGOD_REPLY( ackMsg )
		elseif msgID == _G.Protocol["ACK_CARD_SALES_DATA"] then --  24932	 促销活动状态返回
			self : ACK_CARD_SALES_DATA( ackMsg )
		elseif msgID == _G.Protocol["ACK_FLSH_TIMES_REPLY"] then -- 50220  剩余次数返回 - 风林山火
            self : ACK_FLSH_TIMES_REPLY( ackMsg )
        --郭俊志 2013.09.17
        elseif msgID == _G.Protocol["ACK_WRESTLE_AREANK_RANK"] then -- 54802  返回竞技场数据 -- 格斗之王 
            self : ACK_WRESTLE_AREANK_RANK( ackMsg )
        elseif msgID == _G.Protocol["ACK_WRESTLE_APPLY_STATE"] then -- [54804]报名状态 -- 格斗之王 
            self : ACK_WRESTLE_APPLY_STATE( ackMsg )
        elseif msgID == _G.Protocol["ACK_WRESTLE_PLAYER"] then -- [54810]玩家信息块 -- 格斗之王
            self : ACK_WRESTLE_PLAYER( ackMsg )
        --jun 2013.10.21 
        elseif msgID == _G.Protocol["ACK_ACTIVITY_OK_ACTIVE_DATA"] then -- [30520]活动数据返回 -- 活动面板
            self : ACK_ACTIVITY_OK_ACTIVE_DATA( ackMsg )
        elseif msgID == _G.Protocol["ACK_ACTIVITY_ACTIVE_DATA"] then -- [30520]活动数据返回 -- 活动面板
            self : ACK_ACTIVITY_ACTIVE_DATA( ackMsg )
        --jun 2013.11.12
        elseif msgID == _G.Protocol["ACK_CARD_NOTICE"] then -- [24960]领取通知 -- 新手卡 
            self : ACK_CARD_NOTICE( ackMsg )
        -- elseif msgID == _G.Protocol["ACK_SHOOT_REPLY"] then -- [51220]每日一箭返回
        --     self : ACK_SHOOT_REPLY( ackMsg )
        elseif msgID == _G.Protocol["ACK_ACTIVITY_OK_LINK_DATA"] then -- [30620]活跃度数据返回
            self : ACK_ACTIVITY_OK_LINK_DATA( ackMsg )
        elseif msgID == _G.Protocol["ACK_CARD_RECE"] then -- [24970]以领取的活动Id
            self : ACK_CARD_RECE( ackMsg )
            
        end
	end

    if _command :getType() == CFunctionUpdateCommand.TYPE then
        if _command :getData() == CFunctionUpdateCommand.BUFF_TYPE then
            CCLOG("接收buff通知")
            if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
                self :getView() :setRoleBuffIcon()
            end
        end
    end
    
	if _command:getType() == CActivityIconCommand.TYPE then
		if _command:getData() == CActivityIconCommand.REMOVE then
			if type(_command:getOtheData()) == "number" then 
				--领取成功 移除首充礼包 Icon
                print("-----领取成功 移除首充礼包 Icon----",_command:getOtheData())
				self :getView() : removOneActivity( _command:getOtheData() )

                if _command:getOtheData() == _G.Constant.CONST_RECHARGE_SALES_FIRST_PREPAID then
                    self:getView():resetGLBtnPos()
                end
			end 
		end		
	end

    if _command:getType() == CGotoSceneCommand.TYPE then
        print("准备跳场景所以要删除所有的ccbi")
        self :getView() : removeAllIconCCBI()  
    end

    
    --08.15 add 点击功能按钮时，隐藏自动寻路
    if _command :getType() == CActivityIconCommand.TYPE then
        local bValue = nil
        if _G.g_Stage :getScenesType() ~= _G.Constant.CONST_MAP_TYPE_CITY then
            return true
        end
        
        if _command :getData() == CActivityIconCommand.NOHIDE then
            bValue = true
        elseif _command :getData() == CActivityIconCommand.HIDE then
            bValue = false
        end
        
        if bValue ~= nil then
            local curScenesType = _G.g_Stage :getScenesType()
            if curScenesType== _G.Constant.CONST_MAP_TYPE_CITY then
                self :getView() :HideGuiderBtn( bValue)
            end
        end
    end
    
    if _command :getType() == CDailyUpdateCommand.TYPE then
        print("更新图表数字 ", _command :getData())
        local curScenesType = _G.g_Stage :getScenesType()
        if curScenesType== _G.Constant.CONST_MAP_TYPE_CITY then
            if _command :getData() == CDailyUpdateCommand.UPDATE then
                self :getView() :setDailyTaskTimes( )
            end
        end
        print(".....sdfssd", curScenesType)
    end
    
    if _command :getType() == CFunctionOpenCommand.TYPE then
        CCLOG("打开右下角的功能按钮")
        if _command :getData() == CFunctionOpenCommand.UPDATE then
            if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
                if _command :getData() == CFunctionOpenCommand.UPDATE then
                    self :getView() :setUpdateView()
                end
            end
        end
    --[[
    elseif _command :getType() == CDailyTaskCommand.TYPE then
        if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
            if _command :getData() == CDailyTaskCommand.OPEN then
                self :getView() :openDailyTaskView()  onGuiderTask()
            end
        end
    --]]
    end
    
    --自动寻路
    if _command :getType() == CTaskDialogUpdateCommand.TYPE then
        if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
            if CTaskDialogUpdateCommand.GOTO_TASK == _command :getData() then
                self :getView() :onGuiderTask()
            end
        end
    end
    
    if _command :getType() == CDailyUpdateCommand.TYPE then
        if _command :getData() == CDailyUpdateCommand.SHINNING then
            -- ccbi亮起来
            self :getView() :setDailyCCBIView()
        end
    end
    
    if _command :getType() == CTaskDataUpdataCommand.TYPE then
        if _command :getData() == CTaskDataUpdataCommand.UPDATEGUIDER then
            if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
                self :getView() :addTaskGuideBtn()
            end
        end
    end
                                 
    return false
	--判断需要处理的type self:getView()
end

function CActivityIconMediator.ACK_WEAGOD_REPLY(self, ackMsg)   --接受到招财面板返回 32020
	print("CLuckyLayerMediator 43 ackMsg : getTimes() ==",ackMsg : getTimes())
	self:getView() : addSmallSpr(_G.Constant.CONST_FUNC_OPEN_MONEYTREE,ackMsg : getTimes())
	--require "proxy/LuckyDataProxy"
    --_G.g_LuckyDataProxy = CLuckyDataProxy()
    --_G.g_LuckyDataProxy : setLuckyTimes(ackMsg : getTimes())
	print("CLuckyLayerMediator招财协议处理方法处理完毕～～")
end

function CActivityIconMediator.ACK_CARD_SALES_DATA(self, ackMsg)   --24932	 促销活动状态返回
	local idData = ackMsg : getIdDate()
	self :getView() : activityDataResponse(idData)
end

function CActivityIconMediator.ACK_DAILY_TASK_DATA( self, ackMsg)
    print("CActivityIconMediator.ACK_DAILY_TASK_DATA", ackMsg)
    if ackMsg then
        if ackMsg :getLeft() then
            self :getView() :setDailyTaskTimes( ackMsg :getLeft())
        end
    end
end

function CActivityIconMediator.ACK_FLSH_TIMES_REPLY( self, ackMsg )
    --50220    剩余次数返回 - 风林山火
    local curScenesType = _G.g_Stage :getScenesType()
    if curScenesType == _G.Constant.CONST_MAP_TYPE_CITY and self :getView() ~= nil and ackMsg ~= nil then
        if ackMsg :getTimes() == 0 then
            --没有次数了  删除图标
            self :getView():addSmallSpr(_G.Constant.CONST_FUNC_OPEN_GAMBLE)
        else
            self :getView() :FurinkazanCallBack( tonumber(ackMsg :getTimes()), tonumber(ackMsg :getIsGet()) )
        end
    end
end
--[[
function CActivityIconMediator.ACK_SIGN_DAYS(self, ackMsg)   --40020     连续登陆的天数
    local data = ackMsg : getGetInfo()
    self :getView() : signInResponse(data)
end
]]

--jun 2013.09.17
function CActivityIconMediator.ACK_WRESTLE_AREANK_RANK( self, ackMsg )
    -- 54802  返回竞技场数据 -- 格斗之王
    local Rank =tonumber(ackMsg :getRank())  --竞技场排名
    print("CActivityIconMediator 返回竞技场数据 -- 格斗之王",Rank)
    self :getView() : NetWorkReturn_WRESTLE_AREANK_RANK(Rank)
end
function CActivityIconMediator.ACK_WRESTLE_APPLY_STATE( self, ackMsg )
    -- [54804]报名状态 -- 格斗之王
    print("CActivityIconMediator 报名状态 -- 格斗之王")
    self :getView() : NetWorkReturn_WRESTLE_APPLY_STATE()
end
function CActivityIconMediator.ACK_WRESTLE_PLAYER( self, ackMsg )
    -- [54810]玩家信息块 -- 格斗之王
    print("CActivityIconMediator 玩家信息块 -- 格斗之王")
    local Uid       = ackMsg : getUid()       -- {玩家的uid}
    local Name      = ackMsg : getName()      -- {玩家姓名}
    local NameColor = ackMsg : getNameColor() -- {玩家名字颜色}
    local Lv        = ackMsg : getLv()        -- {玩家等级}
    local Powerful  = ackMsg : getPowerful()  -- {玩家战斗力}
    local Score     = ackMsg : getScore()     -- {玩家积分}
    local NowCount  = ackMsg : getNowCount()  -- {当前的次数}
    local AllCount  = ackMsg : getAllCount()  -- {当前总次数}
    local Uname     = ackMsg : getUname()     -- {下一个对手名字}
    local Success   = ackMsg : getSuccess()   -- {胜场次}
    local Fail      = ackMsg : getFail()      -- {输场次}

    self :getView() : NetWorkReturn_WRESTLE_PLAYER(Uid,Name,NameColor,Lv,Powerful,Score,NowCount,AllCount,Uname,Success,Fail)
end

--jun 2013.10.21
function CActivityIconMediator.ACK_ACTIVITY_OK_ACTIVE_DATA( self, ackMsg )
    print("CActivityIconMediator 的活动面板数据返回")
    -- [30520]活动数据返回 -- 活动面板 
    local count       = tonumber(ackMsg :getCount()) 
    local activeData  = ackMsg :getActiveMsg()
    self :getView() : NetWorkReturn_ACTIVITY_OK_ACTIVE_DATA( count, activeData)
end
function CActivityIconMediator.ACK_ACTIVITY_ACTIVE_DATA( self, ackMsg )
    print("CActivityIconMediator 的活动面板数据返回")
    -- [30520]活动数据返回 -- 活动面板 

    local IsNew      = tonumber(ackMsg :getIsNew()) 
    local StartTime  = tonumber(ackMsg :getStartTime()) 
    local EndTime    = tonumber(ackMsg :getEndTime()) 
    local State      = tonumber(ackMsg :getState()) 

    self :getView() : NetWorkReturn_ACTIVITY_ACTIVE_DATA( State )
end

--jun 2013.11.12
function CActivityIconMediator.ACK_CARD_NOTICE( self, ackMsg )
    print("CActivityIconMediator 精彩活动的领取")
    -- [24960]领取通知 -- 新手卡 

    self :getView() : NetWorkReturn_CARD_NOTICE()
    
    _G.g_GameDataProxy : setIsActivityIconCCBIcreate(0) --精彩活动特效
end


--[51220]每日一箭返回
function CActivityIconMediator.ACK_SHOOT_REPLY( self, ackMsg )
    if ackMsg:getFreeTime() == 0 and ackMsg:getPurchaseTime() == 0 then
        --已经没有次数玩了   删除图标
        self :getView():addSmallSpr(_G.Constant.CONST_FUNC_OPEN_WEAPON)
    end
end

function CActivityIconMediator.ACK_ACTIVITY_OK_LINK_DATA( self, ackMsg )
    local rewardList = ackMsg :getRewards()
    local value      = ackMsg :getVitality()

    print("CActivityIconMediator.ACK_ACTIVITY_OK_LINK_DATA    ",value, #rewardList)
    if #rewardList > 0 then
        local count = math.floor(value/25)
        -- if value%25 > 0 then
        --     count = count + 1
        -- end
        print("CActivityIconMediator.ACK_ACTIVITY_OK_LINK_DATA  11  -->",count)
        if count ~= #rewardList then
            _G.g_GameDataProxy : setIsActivenessCCBIHere( true )
            self:getView():createActivenessCCBI()
        end
    elseif value >= 25 then
        _G.g_GameDataProxy : setIsActivenessCCBIHere( true )
        self:getView():createActivenessCCBI()
    end
end


--[24970]以领取的活动Id
function CActivityIconMediator.ACK_CARD_RECE( self, ackMsg )

    local list = ackMsg:getData()
    print("ACK_CARD_RECE   1111 ",#list)

    if _G.pCFunctionOpenProxy ~= nil then
        print("ACK_CARD_RECE   2222 ",#list)
        _G.pCFunctionOpenProxy : resetSubIdList( list )
    end
end



