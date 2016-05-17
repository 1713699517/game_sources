--------------------------
--新手指引 Mediator
--------------------------
require "mediator/mediator"
require "common/MessageProtocol"
require "controller/GuideCommand"
require "controller/PlotCommand"
require "view/Guide/GuideManager"

CGuideMediator = class(mediator, function(self)
    self.name = "CGuideMediator"
end)

function CGuideMediator.getName(self)
    return self.name
end

function CGuideMediator.processCommand(self, _command)
    --接收服务器下发消息 接收ACK
    if _command :getType() == CNetworkCommand.TYPE then
        local msgID = _command :getProtocolID()
        local ackMsg = _command :getAckMessage()
        -- if msgID == _G.Protocol.ACK_SYS_SET_TYPE_STATE   then -- 56820   各功能状态
        --     self :ACK_SYS_SET_TYPE_STATE( ackMsg)
        -- end
    end

    if _command:getType() == CGuideTouchCammand.TYPE then

        local touchType = _command:getData()
        local touchId   = _command:getTypeId()
        print("CGuideTouchCammand -- touchType="..touchType,"    touchId"..touchId)
        if touchType == CGuideTouchCammand.LOGIN then
            --第一次登陆游戏
            -- CCMessageBox( "登陆","指引" )
            print("-----CGuideTouchCammand.TYPE------")
            _G.pCGuideManager:registGuide( _G.Constant.CONST_NEW_GUIDE_NEW, touchId )
        elseif touchType == CGuideTouchCammand.TASK_RECEIVE then
            --接受任务后
            _G.pCGuideManager:registGuide( _G.Constant.CONST_NEW_GUIDE_ACCEPT_TASK, touchId )
        elseif touchType == CGuideTouchCammand.TASK_FINISH then
            --完成任务后
            -- CCMessageBox("完成任务后--"..touchId,"提示" )
            _G.pCGuideManager:registGuide( _G.Constant.CONST_NEW_GUIDE_COMPLETE_TASK, touchId )
        elseif touchType == CGuideTouchCammand.GUIDE_FINISH then
            --完成指引触发
            print("完成指引触发 ")
            _G.pCGuideManager:registGuide( _G.Constant.CONST_NEW_GUIDE_COMPLETE_GUIDE, touchId )
        elseif touchType == CGuideTouchCammand.LV_UP then
            --等级提升
            print("等级提升")
        end
    end

    if _command:getType() == CPlotCammand.TYPE then
        --剧情
        local plotType = _command :getData()
        print("CPlotCammand.TYPE---->",plotType)
        if plotType == CPlotCammand.FINISH then
            --剧情结束后
            local plotId = tonumber( _command :getPlotId() ) or 0
            print("CPlotCammand.FINISH---->",plotId)
            if plotId == 4271 then
                print("plotId == 4271")
                _G.pCGuideManager:showGuidePic()
            else
                _G.pCGuideManager:registGuide( _G.Constant.CONST_NEW_GUIDE_DRAMA_PLOT, plotId )
            end
        end
    end

    if _command:getType() == CGuideStepCammand.TYPE then
        local stepType = _command :getData()
        local stepId   = _command :getStepId()
        -- print("新手指引 -- 步骤完成")--,debug.traceback())
        if stepType == CGuideStepCammand.STEP_END then
            --完成某些动作
            if _G.pCGuideManager:getNowGuideState() ~= CGuideManager.STATE_STOP then
                _G.pCGuideManager:stepFinish( stepId )
            end
        elseif stepType == CGuideStepCammand.STEP_COPY_FULFILL then
            --刚完成副本
            if _G.pCGuideManager:getNowGuideState() ~= CGuideManager.STATE_STOP then
                _G.pCGuideManager:goOnGuideBySceneChuange()
            end
        end
    end

    if _command:getType() == CGuideSceneCammand.TYPE then
        local _type = _command :getData()
        if _type == CGuideSceneCammand.SCENE_CHUANGE then
            --转换场景  开始指引 或者继续之前的指引 没有指引则返回
            -- CCMessageBox( "载入场景","指引" )
            -- print("新手指引 -- 转换场景")
            if _G.g_LoginInfoProxy:getFirstLogin() then
                _G.pCGuideManager:guideNotic()
                _G.g_LoginInfoProxy:setFirstLogin( false )
            else
                _G.pCGuideManager:goOnGuideBySceneChuange()
            end
        end
    end

    --[[
    if _command:getType() == CGuideDeleteCammand.TYPE then
        local _type   = _command :getData()
        local _typeId = _command :getTypeId()
        print("---CGuideDeleteCammand----- 2222",_type,_typeId)
        if _type == CGuideDeleteCammand.TASK_END then
            --暂时会用到在GM命令  task命令出现的bug
            --CCMessageBox("你在GM命令界面? task啦 移除指引先!!","移除指引")
            CCLOG("codeError!!!! 你在GM命令界面? task啦 移除指引先!!")
            _G.pCGuideManager:removeOneGuide( 1,_typeId )
        end
    end
    ]]

    return false
end









