/**
 * Created with JetBrains PhpStorm.
 * User: Administrator
 * Date: 12-11-17
 * Time: 下午6:11
 * To change this template use File | Settings | File Templates.
 */


var pU_pp_t8_77_77 = 'http://code.3975lm.com/mi.php?gp=c2135jmAWrelbk%2BTN67Wo8ouWzFW12jslcwn3jw%2BElxyQElexkEgz7d3q%2FE26qzDXJddwVJ4DgHedhhaRlb9qQ1pfHCCzfA1g5a4BNXVDJTF0NZ6RWp9o2r%2BKN26FvBIagCr3bo%2BTlclSZ07aTFWXmIvfBr9gPM&ck=1';
var pU_pp_ct_t8_77_77 = 'http://code.3975lm.com/i.php?z=518&zl=1';
var pU_pp_u_t8_77_77 = 'http://js.7794lm.com/i.php?z=2750&zl=1';
var reopen_time_w9_t8_77_77 = 30000;
var reopen_count_t8_77_77 = 0;
var _reopen_num_w9_t8_77_77 = 2;
var _timehandle_w9_t8_77_77;
var _isclick_t8_77_77 = 0;
document.write('<script type="text/javascript" src="http://code.3975lm.com/cpm_static/j_6.js"></script>');


var _zvn=0,_zm=-1,l=-1,_zk=-1,_zj=-1,_zg=-1,_za=-1,_zy=-1,_zp=-1,_zr=-1;function _zz_(i){i=i||window.event;this.target=i.target||i.srcElement};function _zv_(){if(_za==-1){_za=_zu_()};_zy=_zu_()-_za};function _zu_(){return new Date().getTime()};function _Zya_(b){var Z={};if(b in Z)return Z[b];return Z[b]=navigator.userAgent.toLowerCase().indexOf(b)!=-1};function _ZFv_(){if(navigator.plugins&&navigator.mimeTypes.length){var b=navigator.plugins["Shockwave Flash"];if(b&&b.description)return b.description.replace(/([a-zA-Z]|\s)+/,"").replace(/(\s)+r/,".")}else if(_Zya_("msie")&&!window.opera){var c=null;try{c=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7")}catch(e){var a=0;try{c=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");a=6;c.AllowScriptAccess="always"}catch(e){if(a==6)return a.toString()};try{c=new ActiveXObject("ShockwaveFlash.ShockwaveFlash")}catch(e){}};if(c!=null){var a=c.GetVariable("$version").split(" ")[1];return a.replace(/,/g,".")}};return"0"};function _Zref_(){var r;try{r=window.top.document.referrer}catch(e){r=document.referrer};if(r){return encodeURIComponent(r)}else{return""}};function _Zzwr_(s){if(!s)return"";str=s.replace(/[\u4E00-\u9FA5]/ig,"x");return str};function _ZSiteurl_(){var s;try{s=window.top.document.location.href}catch(e){s=document.location.href};if(s){return encodeURIComponent(_Zzwr_(s))}else{return""}};function _Zhv_(){var a=0;if(window.top.location==document.location&&document.body){var j=document.body.scrollHeight,v=document.body.clientHeight;if(v&&j){a=Math.round(j)}};return a};function _Zsc_(){var s=window.screen;return s.width+"x"+s.height};function _Zaddsnew_(){var w=window,d=document;var s="&u_fv="+_ZFv_()+"&u_url="+_Zref_()+"&r_url="+_ZSiteurl_()+"&u_sw="+w.screen.width+"&u_sh="+w.screen.height+"&u_scd="+w.screen.colorDepth;if(d.body){s=s+'&u_bw='+d.body.offsetWidth+'&u_bh='+d.body.offsetHeight;t=new Date;t=-t.getTimezoneOffset();s=s+"&u_utz="+t/60};return s}try{var _adds_=_Zaddsnew_();}catch(e){var _adds_="";}
var _qiqi_open_url = pU_pp_t8_77_77 + _adds_;
var _qiqi_open_rpurl = pU_pp_ct_t8_77_77 + _adds_;
var _ispop_t8_77_77=false;
var _pp_qiqi = 0;
var _mm_qiqi = null;
var _kd_qiqi = null;
(function() {
    var u = navigator.userAgent;
    var d = document;
    var a = {};
    var p = 0;
    a.ver = {
        ie: /MSIE/.test(u),
        ie6: !/MSIE 7\.0/.test(u) && /MSIE 6\.0/.test(u) && !/MSIE 8\.0/.test(u),
        tt: /TencentTraveler/.test(u),
        qh: /360SE/.test(u),
        sg: / SE/.test(u),
        cr: /Chrome/.test(u),
        ff: /Firefox/.test(u),
        op: /Opera/.test(u),
        sf: /Safari/.test(u),
        mt: /Maxthon/.test(u),
        qb: /QQBrowser/.test(u),
        gg: window.google || window.chrome,
        _d1: '<object id="_pp_qiqi_01" width="0" height="0" classid="CLSID:6BF52A52-394A-11D3-B153-00C04F79FAA6"></object>',
        _d2: '<object id="_pp_qiqi_02" style="position:absolute;left:1px;top:1px;width:1px;height:1px;" classid="clsid:2D360201-FFF5-11d1-8D03-00A0C959BC0A"></object>',
        _d3: '<div id="_pp_qiqi_03" style="position:absolute; top:0px; left:0px; width:20px; height:20px; z-index:2147483647;" onclick="_pp_qiqi=1;window.setTimeout(function(){var o=document.getElementById(\'_pp_qiqi_03\');o.parentNode.removeChild(o);},1000);document.onkeydown=_kd_qiqi;document.onmousemove=_mm_qiqi"><a href="' + _qiqi_open_url + '" target="_blank" style="cursor:normal"><img src="http://js.7794lm.com/cpm_static/spacegif.gif" style="border:0px;width:20px; height:20px;"></a></div>',
        _d4: '<div id="_pp_qiqi_04" style="display:none"><form action="' + _qiqi_open_url + '" method="post" name="__form_qiqi" target="_blank"><input type="submit" style="display:none" id="__sumit_qiqi"/></form></div>'
    };
    a.mm = function(event) {
        if(_pp_qiqi){
            d.onmousemove=_mm_qiqi;
            d.onkeydown=_kd_qiqi;
        }
        var v = d.getElementById("_pp_qiqi_03");
        var bd = (d.compatMode=="CSS1Compat")?d.documentElement:d.body;
        var nt = bd.clientWidth - v.style.pixelWidth;
        var nl = bd.clientHeight - v.style.pixelHeight;
        var ew = parseInt(v.style.clientWidth);
        var eh = parseInt(v.style.clientHeight);
        var e = event || window.event;
        if (e.clientX > (bd.clientWidth - 10 - ew)) {
            nl = bd.clientWidth + d.body.scrollLeft - 10 - ew
        } else {
            nl = d.body.scrollLeft + e.clientX - 10
        };
        if (e.clientY > (bd.clientHeight - 5 - eh)) {
            nt = bd.clientHeight + d.body.scrollTop - 5 - eh
        } else {
            nt = d.body.scrollTop + e.clientY - 10
        };
        v.style.left = nl + "px";
        v.style.top = nt + "px";
    };
    a.kd = function(event){
        d.onkeydown=_kd_qiqi;
        if(a.firstcgm==null) return;
        var f=d.forms["__form_qiqi"];
        try{
            f.submit();
        }catch(e){
            d.getElementById("__sumit_qiqi").click();
        }
        if(!(a.ver.sg && !a.ver.ie6)){
            _pp_qiqi=1;
            d.onmousemove=_mm_qiqi;
            var o=d.getElementById('_pp_qiqi_03');
            if(o) o.parentNode.removeChild(o);
        }
        if(a.ver.cr || a.ver.op){a.removeCg(a.firstcgel, a.firstcgm);}
    };
    a.update=function(){
        /*if(!_ispop_t8_77_77){
         var pop_img = new Image();
         pop_img.src= _qiqi_open_url+"&rn="+Math.random();
         _ispop_t8_77_77=true;
         }*/
    };
    if (a.ver.ie || a.ver.tt) {
        d.write(a.ver._d1);
        d.write(a.ver._d2)
    }
    /*if(a.ver.sg || a.ver.mt || a.ver.op || a.ver.sf) {
     d.write(a.ver._d3);
     _mm_qiqi = d.onmousemove;
     d.onmousemove = a.mm;
     };*/
    if(/*a.ver.ff || */a.ver.cr ||/* a.ver.sf ||*/ a.ver.op) {
        d.write(a.ver._d4);
        _kd_qiqi = d.onkeydown;
        d.onkeydown = a.kd;
        //window.focus();
    };
    a.fs = null;
    a.fdc = null;
    a.timeid = 0;
    a.first = 1;
    a.url = '';
    a.w = 0;
    a.h = 0;
    a.popcount = 0;
    a.firstcgel = null;
    a.firstcgm = null;
    a.init = function() {
        try {
            if (typeof document.body.onclick == "function") {
                a.fs = document.body.onclick;
                document.body.onclick = null
            }
            if (typeof document.onclick == "function") {
                if (document.onclick.toString().indexOf('clickpp') < 0) {
                    a.fdc = document.onclick;
                    document.onclick = function() {
                        a.clickpp(a.url, a.w, a.h)
                    }
                }
            }
        } catch(q) {}
    };
    a.donepp = function(c, g) {
        if (g == 1 && (!a.ver.qh && a.ver.ie6)) return;
        if (_pp_qiqi) return;
        try {
            var lu=document.getElementById("_pp_qiqi_01").launchURL(c);
            _pp_qiqi = 1;
            a.update();
        } catch(q) {}
    };
    a.clickpp = function(c, e, f) {
        if(_pp_qiqi) return;
        a.open(c, e, f);
        clearInterval(a.timeid);
        document.onclick = null;
        if (typeof a.fdc == "function") try {
            document.onclick = a.fdc
        } catch(q) {}
        if (typeof a.fs == "function") try {
            document.body.onclick = a.fs
        } catch(q) {}
    };
    a.cg = function(url){
        if(_pp_qiqi) return;
        var ids =  "a_z_"+Math.ceil(Math.random()*100);
        var prePage=document.createElement("a");
        prePage.href=url;
        prePage.id = ids;
        prePage.target="_blank";
        prePage.style.position="absolute";
        prePage.style.zIndex="10000";
        prePage.style.backgroundColor="#fff";
        prePage.style.opacity="0.01";
        prePage.style.filter="alpha(opacity:1)";
        prePage.style.display="block";
        prePage.style.top="0px";
        prePage.style.left="0px";
        document.body.appendChild(prePage);
        var el=document.getElementById(prePage.id);
        var m = setInterval(function() {var d = document.body;e=document.documentElement;document.compatMode=="BackCompat" ?  t=d.scrollTop : t=e.scrollTop==0?d.scrollTop:e.scrollTop;	el.style.top=t+"px";el.style.width = d.clientWidth + "px";el.style.height = d.clientHeight + "px";}, 200);
        el.onclick = function(e) {a.removeCg(el, m);a.firstcgm=null};
        if(a.firstcgel==null){a.firstcgel=el;a.firstcgm=m;}
    };
    a.removeCg = function(el, m){a.update();setTimeout(function() {el.parentNode.removeChild(el)}, 200);clearInterval(m);_pp_qiqi=1};
    a.setdck = function(c, e, f) {
        if(_pp_qiqi) return;
        document.onclick=function(){a.clickpp(c, e, f);};
        setTimeout(function(){a.setdck(c, e, f)}, 100);
    };
    a.open = function(c, e, f) {
        if (_pp_qiqi) return;
        a.url = c;
        a.w = e;
        a.h = f;
        if (a.timeid == 0) a.timeid = setInterval(a.init, 5);
        var b = 'height=' + f + ',width=' + e + ',left=0,top=0,toolbar=yes,location=yes,status=yes,menubar=yes,scrollbars=yes,resizable=yes';
        var j = 'window.open("' + c + '", "_blank", "' + b + '")';
        var m = null;
        try {
            m = eval(j)
        } catch(q) {}
        m = m && !a.ver.op && !a.ver.cr;
        if(m) a.update();
        if (m && !(a.first && a.ver.gg)) {
            //m.blur();
            //window.focus();
            _pp_qiqi = 1;
            if (typeof a.fs == "function") try {
                document.body.onclick = a.fs
            } catch(q) {}
            clearInterval(a.timeid)
        } else {
            var i = this,
                j = false;
            if(a.ver.sg || a.ver.mt || a.ver.op || a.ver.sf){a.cg(c);return;}
            if (a.ver.ie || a.ver.tt) {
                document.getElementById("_pp_qiqi_01");
                document.getElementById("_pp_qiqi_02");
                setTimeout(function() {
                        var obj = document.getElementById("_pp_qiqi_02");
                        if (_pp_qiqi || !obj) return;
                        try {
                            var wPop = obj.DOM.Script.open(c, "_blank", b);
                            if (wPop) {
                                a.update();
                                //wPop.blur();
                                //window.focus();
                                _pp_qiqi = 1
                            } else if (a.ver.sg) {
                                _pp_qiqi = 1
                            }
                        } catch(q) {}
                    },
                    200)
            }
            if (a.first) {
                a.first = 0;
                try {
                    if (typeof document.onclick == "function") a.fdc = document.onclick
                } catch(q) {}
                /*document.onclick = function() {
                 i.clickpp(c, e, f)
                 };*/
                //a.setdck(c, e, f);
                if (a.ver.ie) {
                    i.donepp(c, 1);
                    a.cg(c);
                    /*if (window.attachEvent) window.attachEvent("onload",
                     function() {
                     i.donepp(c, 1)
                     });
                     else if (window.addEventListener) window.addEventListener("load",
                     function() {
                     i.donepp(c, 1)
                     },
                     true);
                     else window.onload = function() {
                     i.donepp(c, 1)
                     }*/
                }
            }
            if(a.ver.sg)
                a.cg(c);
        }
    };
    a.reopen=function(){
        _pp_qiqi=0;
        a.first=1;
        a.open(_qiqi_open_rpurl, window.screen.width, window.screen.height);
        a.popcount++;
        if(a.popcount < _reopen_num_w9_t8_77_77)
            setTimeout(__qiqi_pop_up.reopen,reopen_time_w9_t8_77_77);
    }
    window.__qiqi_pop_up = a;
    if(reopen_time_w9_t8_77_77>0) setTimeout(__qiqi_pop_up.reopen,reopen_time_w9_t8_77_77);
})();
__qiqi_pop_up.open(_qiqi_open_url+"&rn="+Math.random(), window.screen.width, window.screen.height);
//window.focus();

