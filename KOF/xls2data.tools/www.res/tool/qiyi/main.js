/**
 * Created with JetBrains PhpStorm.
 * User: Administrator
 * Date: 12-11-25
 * Time: 下午9:13
 * To change this template use File | Settings | File Templates.
 */


var info = {
    "url":"http://www.iqiyi.com/jilupian/20121119/d1156a617757f97c.html",
    "title":"有价星球",
    "pid":"53585",
    "ptype":"2",
    "navigation":"&lt;a href=&quot;http://www.iqiyi.com/index.html&quot;&gt;首页&lt;/a&gt; &gt; &lt;a href=&quot;http://www.iqiyi.com/jilupian/index.html&quot;&gt;纪录片&lt;/a&gt; &gt; &lt;a href=&quot;http://www.iqiyi.com/jilupian/huobi.html&quot;&gt;货币&lt;/a&gt; &gt; &lt;strong&gt;有价星球&lt;/strong&gt;",
    "videoId":"e6125a975377402493fac11556a3d1ce",
    "albumId":"264745",
    "catalogId":"262943",
    "tvId":"313699",
    "data":{"categoryId":"3", "category":"纪录片 社会 历史",
        "flashWidth":"640", "flashHeight":"395",
        "videoDesc":"自从货币诞生之后，地球上的每一个物件都可以货币化，货币让我们的生活变得更加的便利和丰富，同时也让我们的生活失去温暖变得冰冷。那么，货币究竟以何种方式影响了整个地球的转动？她又如何决定我们的未来？",
        "playLength":"00:46:36", "albumName":"货币",
        "qitanId":0, "isShare":1, "subTitle":"",
        "playTime":"00:46:36", "catalogId":"262943", "playerType":"1"}
};
////////////////////////////////////////////////////////
var __LT__ = {
    j:{},
    c:{},
    f:{},
    l:{},
    i:{},
    s:{}
};
__LT__.c['qiyi_play_page'] = new Date();
__LT__.l['begin'] = __LT__.c['qiyi_play_page'];

///////////////////////////////////////////////////
__LT__.c['qiyi_play_page'] = new Date() - __LT__.c['qiyi_play_page'];
var _ua = navigator.userAgent.toLowerCase();
var _iphone4 = /iphone os 4_/.test(_ua);
var _realIpad = /ipad/.test(_ua);
var _ipad = _realIpad || _iphone4 ;
if(_ipad)
{
    document.write('<link type="text/css" rel="stylesheet" href="http://static.qiyi.com/css/common/play_css/qiyi_play_ipad.css" />');
}


///////////////////////////////////////////////////////
var info = info || {};
var _PG_STIME = new Date();

///////////////////////////////////////////////////////
// http://static.qiyi.com/js/qiyi/config.js

var flashUrl = 'http://www.iqiyi.com/player/20120911133726/Player.swf';
var flash4Url = 'http://www.iqiyi.com/player/20121115104829/Player.swf'; //4.0播放器地址
var flashUrl_old = flashUrl;
var flashUrlMusic = 'http://www.iqiyi.com/player/20121018152455/Player.swf'; //音乐播放器地址
var playerCore = 'http://www.qiyipic.com/1000/fix/cp_2028.jpg'; //内核地址
var playerCoreP2P = 'http://www.qiyipic.com/1000/fix/cp_2028_pp.jpg'; //P2P内核
var playerCoreMusic = 'http://www.qiyipic.com/1000/fix/cp_210.jpg';//音乐播放器内核
var tipdataurl = 'http://static.qiyi.com/ext/1020/tipdata.xml'; //tip xml地址
var newWindowPlayer = ''; //小窗口播放器地址
var cupid = "http://www.iqiyi.com/player/cupid/20121119160601/adplayer.swf";
var flashUrlFms = flashUrl;
var preLoaderUrl = 'http://www.iqiyi.com/player/20120911131744/preloader.swf';
if(window.DetectFlashVer && !window.DetectFlashVer(10, 1)) {
    flashUrl = flashUrl_old;
} else {
    flashUrl = flash4Url;
}
//动漫、旅游、电影、纪录片、综艺、电视剧、体育、音乐
if((window.info && info.data && (info.data.categoryId == '2' || info.data.categoryId == '4' || info.data.categoryId == '9' || info.data.categoryId == '1' || info.data.categoryId == '5' || info.data.categoryId == '17' || info.data.categoryId == '6' || info.data.categoryId == '3')) || /yule.iqiyi.com\/\d{8}\//.test(window.location)) {
    playerCore = playerCoreP2P;
    if(info.data.categoryId == '3' || info.data.categoryId == '1')
    {
        //flashUrl = "http://www.iqiyi.com/player/20121115104829/Player.swf";
        //playerCore = "http://www.qiyipic.com/1000/fix/cp_2027_pp.jpg";
    }
    if(info.data.categoryId == '1')
    {
        //playerCore = "http://www.qiyipic.com/p201211151037/fix/coreplayer.jpg";
    }
}
playerCore = playerCoreP2P;



lib.ad = [
    [
        {
            id:'j-ad-flag',
            wrapper:'j-ad'
        }
    ]
];
window.flagRun = function(vid) {
    var monitor = new lib.kit.Monitor(function()
    {
        var adForward = $("#adForward");
        if(!adForward)return false;
        var _src = "http://afp.qiyi.com/main/s?user=qiyiafp|jilupian|qiyijlp_banner&db=qiyiafp&border=0&local=yes&kv=qiyi|";
        adForward.attr("src", _src + encodeURIComponent(vid));
    });
    monitor.start();
};



lib.temp.iPadAdResource = {
    interval:5000,
    resources:[],
    tpl:'<a href="${url}" target="${target}" data-elem="ipadaditem" style="display:${display}"><img src="${img}" width="300" height="50" border="0"></a>'
};
//安卓客户端
if(lib.android){
    lib.temp.iPadAdResource.resources.push({
        img:'http://app.qiyi.com/common/fix/yingyong.jpg',
        url:'http://ex.mobmore.com/api/wap?slot_id=40462&skin=3',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
    lib.temp.iPadAdResource.resources.push({
        img:'http://app.qiyi.com/common/fix/ao_you.jpg',
        url:'http://app.qiyi.com/common/aoyou_explorer.apk',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
    lib.temp.iPadAdResource.resources.push({
        img:'http://ota.iqiyi.com/t.jsp?cid=406',
        url:'http://ota.iqiyi.com/t.jsp?cid=410',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
    lib.temp.iPadAdResource.resources.push({
        img:'http://pic7.qiyipic.com/common/20121008/68020b2766d74b07ab0c7e9d3d08f045.jpg',
        url:'http://ota.iqiyi.com/t.jsp?cid=385',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
    lib.temp.iPadAdResource.resources.push({
        img:'http://pic0.qiyipic.com/common/20120824/01955cecb28346d58cde8ae50324a506.gif',
        url:'http://ex.mobmore.com/api/wap?slot_id=40462&skin=3',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
    lib.temp.iPadAdResource.resources.push({
        img:'http://pic2.qiyipic.com/common/20120911/784d54f900194d998c58585cf608ee7a.gif',
        url:'http://app.qiyi.com/common/Tencent.apk',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
}
//iPhone客户端
else if(lib.iphone){
    lib.temp.iPadAdResource.resources.push({
        img:'http://pic1.qiyipic.com/common/20120531/f89fe2deed534751803af9eeffd921d0.jpg',
        url:'http://ota.iqiyi.com/t.jsp?cid=284',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
    lib.temp.iPadAdResource.resources.push({
        img:'http://pic1.qiyipic.com/common/20120904/755f9c0723354936a8e17dc28a99acec.gif',
        url:'http://m.iclick.cn/m/index.aspx?f=iqiyi_iphone_2_2',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
    lib.temp.iPadAdResource.resources.push({
        img:'http://pic5.qiyipic.com/common/20121123/912986b9400d4cfa86f0a5af9c56161d.jpg',
        url:'http://ota.iqiyi.com/t.jsp?cid=376',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });
}
//iPad
else if(lib.realIpad){
    lib.temp.iPadAdResource.resources.push({
        img:'http://pic5.qiyipic.com/common/20120713/c9f60223399d431aa0c072b74ac91cfa.gif',
        url:'http://afp.qiyi.com/main/c?db=qiyiafp&bid=9556,8327,1615&cid=1679,45,1&sid=38840&advid=335&camid=1638&show=ignore&url=http://ota.iqiyi.com/t.jsp?cid=286',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl
    });

    lib.temp.iPadAdResource.resources.push({
        img:'http://app.qiyi.com/common/fix/qiyi_30050.jpg',
        url:'http://ota.iqiyi.com/t.jsp?cid=400',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl + '<img src="http://afp.qiyi.com/main/s?user=qiyiafp|jiance|ipad_safari_qz&db=qiyiafp&AFP_Ad=shouye_beijing_dd.jpg" width="0" height="0" border="0">'
    });
    lib.temp.iPadAdResource.resources.push({
        img:'http://pic5.qiyipic.com/common/20121123/912986b9400d4cfa86f0a5af9c56161d.jpg',
        url:'http://ota.iqiyi.com/t.jsp?cid=376',
        target:'_blank',
        tpl:lib.temp.iPadAdResource.tpl + '<img src="http://afp.qiyi.com/main/s?user=qiyiafp|jiance|ipad_safari_qz&db=qiyiafp&AFP_Ad=shouye_beijing_dd.jpg" width="0" height="0" border="0">'
    });
}


window.info = window.info || {};
info.data = info.data || {};
info.data.isDown = true;



var cid = "qc_100001_100002";


var albumInfo = window.albumInfo || {};
var _url = new lib.kit.Url(location.href),hideZoomBtn,hideSharepanel,playerType;
info.vrsServer='http://data.video.qiyi.com';
info.adDataXML=encodeURIComponent('http://afp.qiyi.com/main/s?user=qiyiafp||dianying_tiepianzu&db=qiyiafp&border=0&local=list&kv=qiyi|'+encodeURIComponent(info.title));
info.bgcolor = '#000000';
info.screenSize = '4-3';
function postWebEventID(weid){webEventID = weid;}
var scale = 0.75;
if (info.data.flashHeight <= 400) {
    info.data.flashW = info.data.flashWidth;
    info.data.flashH = info.data.flashHeight;
    info.data.flashWidth = 970;
    info.data.flashHeight = 520;
    info.screenSize = '16-9';
    scale = 0.5;
    //显示放大缩小按钮
    hideZoomBtn = '0';
}
if(info.data.isShare != '1' && albumInfo.isShare != '1')
{
    hideSharepanel = '1';
}
if(info.data.playerType == 2)
{
    playerType = info.data.playerType;
}
lib.swf.playerParam = {
    quality : _url.getHrParam("quality"),
    caption : _url.getHrParam("caption"),
    track   : _url.getHrParam("track"),
    tg      : _url.getHrParam("tg"),
    share_sTime : _url.getHrParam("share_sTime") || _url.getHrParam("s"),
    share_eTime : _url.getHrParam("share_eTime") || _url.getHrParam("e"),
    flashW : info.data.flashW,
    flashH : info.data.flashH,
    hideZoomBtn : hideZoomBtn,
    webEventID : window.webEventID,
    preLoaderUrl : window.preLoaderUrl,
    preloader:window.preLoaderUrl,
    coreUrl:window.playerCore,
    tipdataurl:window.tipdataurl,
    components:'ffffffe6',
    vid:info.videoId,
    pid:info.pid,
    ptype:info.ptype,
    albumId:info.albumId,
    tvId:info.tvId,
    hideSharepanel:hideSharepanel,
    playerType:playerType,
    ppuid:lib.cookie.get('P00003'),
    UUIDDuration:'3000',
    cid:window.cid,
    disableDownload:((info.data && info.data.isDown) || albumInfo.isDownLoad) ? 0 : 1,
    browser:lib.swf.browserVer()
};



var _param = [];
for(var key in lib.swf.playerParam)
{
    if(lib.swf.playerParam[key])
    {
        _param.push(key + '=' + lib.swf.playerParam[key]);
    }
}
var _wmodetype = lib.WMODE;
document.getElementById("flashbox").style.width = info.data.flashWidth + "px";
lib.kit.video.render(
    'width', info.data.flashWidth,
    'height', info.data.flashHeight,
    'src', flashUrl,
    'id', 'flash',
    'bgcolor', info.bgcolor,
    'flashVars', _param.join('&'),
    'align', 'middle',
    'ipad', true,
    'wmode', _wmodetype,
    'hint', true
); //end AC code