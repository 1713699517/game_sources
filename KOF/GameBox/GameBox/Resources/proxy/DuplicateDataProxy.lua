--DuplicateDataProxy
require "view/view"
require "mediator/mediator"


CDuplicateDataProxy = class( view , function( self )
    self.m_bInitialized         = false
    self.m_currentchapter       = 0
    self.m_prevchapter          = 0
    self.m_nextchapter          = 0
    self.m_nextchapterisgoing   = 0
    self.m_times                = 0
    self.m_isreward             = 0
    self.m_buytimes             = 0
    self.m_freetimes            = 0
    self.m_duplicatecount       = 0
    self.m_duplicatelist        = {}
    self.m_chaptercopylist      = {}

end)

_G.g_DuplicateDataProxy = CDuplicateDataProxy()

--缓存存放
function CDuplicateDataProxy.setInitialized( self, bValue)
    self.m_bInitialized = bValue
end
function CDuplicateDataProxy.getInitialized( self)
    return self.m_bInitialized
end

--当前章节ID   belong_id
function CDuplicateDataProxy.setCurrentChapter( self, _data, _type)
    self.m_currentchapter = _data

    local isload = _G.Config:load( "config/copy_chap.xml")
    print( "setCurrentChapter",isload)

    --通过XML查找章节名字，前一章ID和后一章ID
    local chaptype = _type-100
    local str = "copy_chap[@id="..tostring( tostring(chaptype).."_"..tostring(self.m_currentchapter)).."]"
    local chapnode = _G.Config.copy_chaps :selectSingleNode( str )

    self.m_currentchaptername = chapnode:getAttribute("chap_name")
    self.m_prevchapter        = tonumber( chapnode:getAttribute("per_chap_id"))
    self.m_nextchapter        = tonumber( chapnode:getAttribute("next_chap_id"))
    self.m_nextchapteropenlv  = tonumber( chapnode:getAttribute("chap_lv"))
    self.m_chaptercopylist    = chapnode:children():get(0,"cids")
    self.m_chapterrewardlist  = chapnode:children():get(0,"rewards")
    print( self.m_currentchaptername, self.m_prevchapter, self.m_nextchapter)
    end

function CDuplicateDataProxy.getCurrentChapter( self)
    return self.m_currentchapter
end

--当前章名字    XML中获取
function CDuplicateDataProxy.getCurrentChapterName( self)
    return self.m_currentchaptername
end
--前一章chapid  XML中获取
function CDuplicateDataProxy.getPrevChapter( self)
    return self.m_prevchapter
end
--下一章chapid XML中获取
function CDuplicateDataProxy.getNextChapter( self)
    return self.m_nextchapter
end

--下一章开启等级 XML中获取
function CDuplicateDataProxy.getNextChapterOpenLv( self)
    return self.m_nextchapteropenlv
end

--下一章是否可去  1：可去   0：不可去
function CDuplicateDataProxy.setNextChapterIsGoing( self, _data)
    self.m_nextchapterisgoing = _data
end
function CDuplicateDataProxy.getNextChapterIsGoing( self)
    return self.m_nextchapterisgoing
end

function CDuplicateDataProxy.setChapterReward( self, _data)
    self.m_isreward = _data
end
function CDuplicateDataProxy.getChapterReward( self)
    return tonumber(self.m_isreward)
end

--英雄副本的可进入次数
--魔王副本的可刷新次数
function CDuplicateDataProxy.setTimes( self, _data)
    self.m_times = _data
end
function CDuplicateDataProxy.getTimes( self)
    return self.m_times
end


function CDuplicateDataProxy.setBuyAndFreeTimes( self, _buytimes, _freetimes)
    self.m_buytimes  = _buytimes
    self.m_freetimes = _freetimes
end
function CDuplicateDataProxy.getBuyAndFreeTimes( self)
    return self.m_buytimes, self.m_freetimes
end

--副本数量
function CDuplicateDataProxy.setDuplicateCount( self, _data)
    self.m_duplicatecount = _data
end
function CDuplicateDataProxy.getDuplicateCount( self)
    return self.m_duplicatecount
end
--table
--副本界面的副本信息
function CDuplicateDataProxy.setDuplicateList( self, _data)
    -- body

    self.m_duplicatelist = _data

    --[[
    self.m_duplicatelist[1]= {}
    self.m_duplicatelist[1].copy_id = 11101
    self.m_duplicatelist[1].is_pass = 1
    self.m_duplicatelist[2]={}
    self.m_duplicatelist[2].copy_id = 11102
    self.m_duplicatelist[2].is_pass = 1
    --]]

end
function CDuplicateDataProxy.getDuplicateList( self)
    -- body
    return self.m_duplicatelist
end

function CDuplicateDataProxy.setChapterCopyList( self, _data)
    self.m_chaptercopylist = _data
end

function CDuplicateDataProxy.getChapterCopyList( self)
    return self.m_chaptercopylist
end

function CDuplicateDataProxy.setChapterRewardList( self, _data)
    self.m_chapterrewardlist = _data
end

function CDuplicateDataProxy.getChapterRewardList( self)
    return self.m_chapterrewardlist
end

function CDuplicateDataProxy.getDuplicateNameByCopyId( self, _data)
    local copy_id = tostring( _data)
    _G.Config :load( "config/scene_copy.xml")
    local charpter_node = _G.Config.scene_copys :selectSingleNode( "scene_copy[@copy_id="..copy_id.."]")
    return charpter_node
end


--请求副本章节
--参数   chapID  章节ID
function CDuplicateDataProxy.REQ_COPY_REQUEST( self, _chapID )
    -- body
    -- (手动) -- [7010]请求普通副本 -- 副本
    require "common/protocol/auto/REQ_COPY_REQUEST"
    local msg = REQ_COPY_REQUEST()
    print("请求普通副本\n章节ID:".._chapID.."\nREQ_COPY_REQUEST:".._G.Protocol.REQ_COPY_REQUEST)
    msg :setArguments( _chapID)
    CNetwork :send( msg)
end

function CDuplicateDataProxy.REQ_HERO_REQUEST( self, _chapID)
    -- body
    -- (手动) -- [39010]请求英雄副本 -- 英雄副本
    require "common/protocol/auto/REQ_HERO_REQUEST"
    local msg = REQ_HERO_REQUEST()
    print("请求英雄副本\n章节ID:".._chapID.."\nREQ_HERO_REQUEST:".._G.Protocol.REQ_HERO_REQUEST)
    msg :setArguments( _chapID)
    CNetwork :send( msg)
end

function CDuplicateDataProxy.REQ_FIEND_REQUEST( self, _chapID)
    -- body
    -- (手动) -- [46210]请求魔王副本 -- 魔王副本
    require "common/protocol/auto/REQ_FIEND_REQUEST"
    local msg = REQ_FIEND_REQUEST()
    print("请求魔王副本\n章节ID:".._chapID.."\nREQ_FIEND_REQUEST:".._G.Protocol.REQ_FIEND_REQUEST)
    msg :setArguments( _chapID)
    CNetwork :send( msg)

end

function CDuplicateDataProxy.REQ_HERO_BUY_TIMES( self, _times)
    -- body
    -- (手动) -- [39050]购买英雄副本次数 -- 英雄副本
    require "common/protocol/auto/REQ_HERO_BUY_TIMES"
    local msg = REQ_HERO_BUY_TIMES()
    print("购买英雄副本次数\nREQ_HERO_BUY_TIMES:".._G.Protocol.REQ_HERO_BUY_TIMES)
    msg :setArguments( _times)
    CNetwork :send( msg)
end

function CDuplicateDataProxy.REQ_FIEND_FRESH_COPY( self, _times)
    -- body
    -- (手动) -- [46250]刷新魔王副本 -- 魔王副本
    require "common/protocol/auto/REQ_FIEND_FRESH_COPY"
    local msg = REQ_FIEND_FRESH_COPY()
    print("刷新魔王副本次数\nREQ_FIEND_FRESH_COPY:".._G.Protocol.REQ_FIEND_FRESH_COPY)
    msg :setArguments( _times)
    CNetwork :send( msg)
end





