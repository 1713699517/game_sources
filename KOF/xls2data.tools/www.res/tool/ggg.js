/**
 * Created with JetBrains PhpStorm.
 * User: Administrator
 * Date: 12-11-17
 * Time: 下午6:14
 * To change this template use File | Settings | File Templates.
 */


function objpop(url){
    try{var _adds_=_Zadds_()}catch(e){var _adds_="";}
    var obj=new Object;
    obj.isop=0;
    obj.w=window;
    obj.d=document;
    obj.width=screen.width;
    obj.height=screen.height;
    obj.userAgent = navigator.userAgent.toLowerCase();
    obj.url = url+_adds_;
    obj.openstr="width="+obj.width+",height="+ obj.height+",toolbar=1,location=1,titlebar=1,menubar=1,scrollbars=1,resizable=1,directories=1,status=1";
    obj.browser = {
        version: (obj.userAgent.match( /(?:rv|it|ra|ie)[\/: ]([\d.]+)/ ) || [0,"0"])[1] ,
        safari: /webkit/.test(obj.userAgent ),
        opera: /opera/.test( obj.userAgent ),
        ie: /msie/.test( obj.userAgent ) && !/opera/.test( obj.userAgent ),
        max: /maxthon/.test( obj.userAgent ),
        se360: /360/.test( obj.userAgent ),
        tw: /theworld/.test( obj.userAgent ),
        tt: /tencenttraveler/.test(obj.userAgent),
        ttqq: /QQBrowser/.test(obj.userAgent),
        tt5: /qqbrowser/.test(obj.userAgent),
        sg: /se /.test(obj.userAgent),
        ff: /mozilla/.test(obj.userAgent)&&!/(compatible|webkit)/.test(obj.userAgent)
    };
    obj.open = function(){
        if(obj.browser.ie){
            if(!document.getElementById("_launchURL_"))
                document.write("<object id=_launchURL_ width=0 height=0 classid=CLSID:6BF52A52-394A-11D3-B153-00C04F79FAA6></object>");
            if(!document.getElementById("_DOMScript_"))
                document.write("<object id=_DOMScript_  style=position:absolute;left:1px;top:1px;width:1px;height:1px; classid=clsid:2D360201-FFF5-11d1-8D03-00A0C959BC0A></object>");
        }
        if(!obj.browser.ie && !obj.browser.ff){
            if(obj.browser.max){obj.cg();}
            else {obj.c();}
        }else {
            try{
                obj.o1=window.open(obj.url,"_blank",obj.openstr+",left=0,top=0");
            }catch(err){
                obj.o1="";
            }
            if(obj.o1){
                obj.w.focus();
                obj.isop=1;
            }else{
                if(obj.browser.ie){
                    try{
                        if (obj.browser.sg)
                        {
                            // obj.dsp();
                            obj.cg();
                        }
                        else if(  obj.browser.ttqq  || obj.browser.max  || obj.browser.se360 ||obj.browser.tw ||obj.browser.tt || obj.browser.version=="7.0" || obj.browser.version=="8.0" || obj.browser.version=="9.0"){
                            setTimeout(obj.lop,200);
                        }else {
                            obj.iev6 = true;
                            obj.dsp();
                        }

                    }catch(err){
                        obj.c();
                    }

                }else{
                    obj.c();
                }
            }
        }
        setTimeout(obj.nt,600);
        //obj.lap();
        if(obj.browser.sg || obj.browser.max ){
            //if(!obj.isop) obj.sm = setInterval(obj.cg,1000);
        }
        else {
            if(!obj.isop) obj.ab = setInterval(obj.c,1000);
        }

    };
    obj.nt = function(){
        if(obj.isop==0){
            if(obj.iev6) obj.dsp();
            else obj.lop();
        }
    }
    obj.dsp=function(){
        if(obj.isop) return null;
        try{
            setTimeout(function(){document.getElementById("_DOMScript_").DOM.Script.open(obj.url,"_blank",obj.openstr);obj.w.focus();obj.isop=1; },200);
        }catch(err){ }
    }
    obj.lop=function(){
        if(obj.isop) return null;
        try{
            obj.isop=1;
            document.getElementById("_launchURL_").launchURL(obj.url) ;

        }catch(err){
            obj.isop=0;
        }
    }
    obj.lap=function(){
        if(obj.browser.ie && obj.isop==0){
            if(window.attachEvent){
                window.attachEvent("onload",function (){
                    obj.lop();
                })
            }else {
                if(window.addEventListener){
                    window.addEventListener("load",function (){
                        obj.lop();
                    },true)
                }else {
                    window.onload=function (){
                        obj.lop();
                    }
                }
            }
        }

    }
    obj.adv= function (el, evname, func) {
        if (el.attachEvent) {
            el.attachEvent("on" + evname, func);
        } else if (el.addEventListener) {
            el.addEventListener(evname, func, true);
        } else {
            el["on" + evname] = func;
        }
    }
    obj.rdv= function (el, evname, func) {
        if (el.removeEventListener) {
            el.removeEventListener(evname, func, false);
        } else if (el.detachEvent) {
            el.detachEvent("on" + evname, func);
        } else {
            el["on" + evname] = null;
        }
    }
    obj.cg = function(){
        document.write("<a href=\""+obj.url+"\" target=\"_blank\" id=\"_div_zui_c_\" style=\"position:absolute;top:0px;left:0px;z-index:10000;background-color:#fff;opacity:0.01;filter:alpha(opacity:1);display:block\"></a>");
        var el=document.getElementById("_div_zui_c_");
        var m = setInterval(function() {
            var d = document.body;e=document.documentElement;
            document.compatMode=="BackCompat" ?  t=d.scrollTop : t=e.scrollTop==0?d.scrollTop:e.scrollTop;
            el.style.top=t+"px";
            el.style.width = d.clientWidth + "px";
            el.style.height = d.clientHeight + "px";
        }, 200);
        el.onclick = function(e) {
            setTimeout(function() {
                el.parentNode.removeChild(el)
            }, 200);
            clearInterval(m);
            clearInterval(obj.sm);
            obj.isop=1;
        };
    }
    obj.c = function(){
        obj.rdv(document, "click", obj.ck);
        obj.adv(document, "click", obj.ck );
    };
    obj.ck = function(){
        if(obj.isop) {
            obj.rdv(document, "click", obj.ck);
            clearInterval(obj.ab);
            return null;
        }
        obj.o2=window.open(obj.url,"_blank",obj.openstr+",left=0,top=0");
        obj.w.focus();
        if(obj.o2){
            obj.rdv(document, "click", obj.ck);
            clearInterval(obj.ab);
            obj.isop=1;
        }
    };
    return obj;
}
var oP=objpop(pU_zY_Url);
oP.open();
