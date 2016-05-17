window.lib = {version:"1.0", update:"2011/4/12"};
window.qiyi = {};
lib.swf = lib.swf || {};
lib.getDomain = function () {
    var a = window.location.hostname.split("."), a = a.slice(a.length - 2);
    return a.join(".")
};
lib.SITE_DOMAIN = lib.getDomain();
lib.PROJECT_NAME = "qiyi";
lib.PROJECT_LOGIN_COMPONENT = function () {
};
lib.TIPS_ICON_NOTICE = "http://www.qiyipic.com/common/fix/passport_images/success.gif";
lib.TIPS_ICON_ALERT = "";
lib.TIPS_ICON_CONFIRM = "http://www.qiyipic.com/common/fix/passport_images/warning.gif";
lib.swf.canComment = function () {
    return info && info.data && !!info.data.qitanId
};
lib.swf.scroll2qitan = function () {
    if ($("#j-gui-qitan"))try {
        lib.component.scrollTo($("#j-gui-qitan")[0], 0)
    } catch (a) {
    } else info && info.data && info.data.qitanId && function () {
        var a = "";
        switch (info.data.qitanId.charAt(0)) {
            case "1":
                a = "m/";
                break;
            case "2":
                a = "s/";
                break;
            case "3":
                a = "t/";
                break;
            case "6":
                a = "r/"
        }
        a && window.open("http://t.qiyi.com/" + a + info.data.qitanId)
    }();
    return!0
};
if (window.location.hostname == "search.video.qiyi.com")window.location.href = "http://search.video.iqiyi.com" + window.location.pathname;
window.lib = window.lib || {version:"1.0", update:"2011/4/12"};
lib.kit = {util:{}};
lib.swf = lib.swf || {};
lib.flash = {};
lib.ad = {};
lib.action = {};
lib.model = {};
lib.view = {};
lib.tpl = {};
lib.msg = {};
lib.temp = {};
lib.PROJECT_DEBUG = !1;
lib.PROJECT_VERSION = "20121123172155317";
lib.PROJECT_BASE_PATH = "http://static.qiyipic.com/js/l/" + lib.PROJECT_NAME + "/";
lib._PAGE_START_TIME = (new Date).getTime();
lib.WMODE = lib.SAFARI || lib.IE || lib.CHROME && lib.winXP ? "Opaque" : "window";
(function (a) {
    var b = lib.PROJECT_VERSION, c = lib.PROJECT_DEBUG;
    if (c) {
        if (a.console)console.noADLog = console.log, console.log = function () {
        };
        lib.log = function (b) {
            a.console ? console.noADLog(b) : lib.kit.$trace && lib.kit.$trace("" + b)
        }
    } else lib.log = function () {
    };
    lib.clearLog = function (a, b, c) {
        var d, a = a || "", b = b || "0xffffff", c = c || "8BFGU1Q6CKK";
        try {
            d = lib.action.ClearSwf.get()
        } catch (h) {
        }
        d && d.writeLog && d.writeLog(c, a, b)
    };
    __loadMainJs = function (d) {
        if (a.__LT__)__LT__.j.base = new Date, __LT__.j.job = __LT__.j.base;
        c ? (lib.PROJECT_BASE_PATH =
            lib.PROJECT_BASE_PATH.replace(/js\/l/gi, "js"), document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + 'base.js"><\/script>'), d && document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + "jobs/" + d.toLowerCase() + '.js"><\/script>')) : (document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + b + '/base.js"><\/script>'), d && (document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + b + "/jobs/" + d.toLowerCase() + '.js"><\/script>'), lib.kit.slog &&
            setTimeout(function () {
                parseInt(Math.random() * 1E3) == 777 && lib.kit.slog.log({flag:"page_trace", job:d})
            }, 1E4)))
    };
    __loadNewMainJs = function (d) {
        if (a.__LT__)__LT__.j.newbase = new Date, __LT__.j.job = __LT__.j.newbase;
        c ? (lib.PROJECT_BASE_PATH = lib.PROJECT_BASE_PATH.replace(/js\/l/gi, "js"), document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + 'newbase.js"><\/script>'), d && document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + "jobs/" + d.toLowerCase() + '.js"><\/script>')) :
            (document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + b + '/newbase.js"><\/script>'), d && (document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + b + "/jobs/" + d.toLowerCase() + '.js"><\/script>'), lib.kit.slog && setTimeout(function () {
                parseInt(Math.random() * 1E3) == 777 && lib.kit.slog.log({flag:"page_trace", job:d})
            }, 1E4)))
    };
    __loadSingleJs = function (a) {
        c ? (lib.PROJECT_BASE_PATH = lib.PROJECT_BASE_PATH.replace(/js\/l/gi, "js"), a && document.write('<script type="text/javascript" src="' +
            lib.PROJECT_BASE_PATH + "/jobs/" + a.toLowerCase() + '.js"><\/script>')) : a && (document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + b + "/jobs/" + a.toLowerCase() + '.js"><\/script>'), lib.kit.slog && setTimeout(function () {
            parseInt(Math.random() * 1E3) == 777 && lib.kit.slog.log({flag:"page_trace", job:a, prj:lib.PROJECT_NAME})
        }, 1E4))
    };
    __loadCompatibleMainJs = function (d) {
        if (a.__LT__)__LT__.j.base = new Date, __LT__.j.job = __LT__.j.base;
        c ? (lib.PROJECT_BASE_PATH = lib.PROJECT_BASE_PATH.replace(/js\/l/gi, "js"),
            document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + 'compatiblebase.js"><\/script>'), d && document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + "jobs/" + d.toLowerCase() + '.js"><\/script>')) : (document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + b + '/compatiblebase.js"><\/script>'), d && (document.write('<script type="text/javascript" src="' + lib.PROJECT_BASE_PATH + b + "/jobs/" + d.toLowerCase() + '.js"><\/script>'), lib.kit.slog && setTimeout(function () {
            parseInt(Math.random() *
                1E3) == 777 && lib.kit.slog.log({flag:"page_trace", job:d})
        }, 1E4)))
    };
    if (lib.SITE_DOMAIN && (lib.SITE_DOMAIN == "qiyi.com" || lib.SITE_DOMAIN == "iqiyi.com"))try {
        document.domain = lib.SITE_DOMAIN
    } catch (d) {
    }
})(this);
Object.extend = function (a, b) {
    for (var c in b)a[c] = b[c];
    return a
};
$reg = function (a, b) {
    for (var c = a.split("."), d = window; c.length > 0;) {
        var e = c.shift();
        typeof d[e] == "undefined" && (d[e] = {});
        d = d[e]
    }
    b()
};
var Class = {create:function () {
    for (var a = function () {
        this.initialize.apply(this, arguments)
    }, b = 0, c = arguments.length, d; b < c; b++)d = arguments[b], d != null && Object.extend(a.prototype, d);
    return a
}};
Object.extend(lib, {guid:1, each:function (a, b) {
    if (a.constructor == Array)for (var c = 0, d = a.length; c < d; c++) {
        if (b(a[c], c) === !1)break
    } else if (a.constructor == Object)for (c in a)if (b(a[c], c) === !1)break
}, fixEvent:function (a) {
    for (var a = window.event || a, b = "altKey attrChange attrName bubbles button cancelable charCode clientX clientY ctrlKey currentTarget data detail eventPhase fromElement handler keyCode layerX layerY metaKey newValue offsetX offsetY originalTarget pageX pageY prevValue relatedNode relatedTarget screenX screenY shiftKey srcElement target toElement view wheelDelta which type".split(" "), c =
        a, d = {}, e = b.length, f; e;)f = b[--e], d[f] = c[f];
    if (!d.target)d.target = d.srcElement || document;
    if (d.target.nodeType === 3)d.target = d.target.parentNode;
    d.clientX = a.clientX - document.documentElement.clientLeft - document.body.clientLeft;
    d.clientY = a.clientY - document.documentElement.clientTop - document.body.clientTop;
    if (d.pageX == null && d.clientX != null)a = document.documentElement, b = document.body, d.pageX = d.clientX + (a && a.scrollLeft || b && b.scrollLeft || 0) - (a && a.clientLeft || b && b.clientLeft || 0), d.pageY = d.clientY + (a && a.scrollTop ||
        b && b.scrollTop || 0) - (a && a.clientTop || b && b.clientTop || 0);
    if (!d.which && d.button !== void 0)d.which = d.button & 1 ? 1 : d.button & 2 ? 3 : d.button & 4 ? 2 : 0;
    if (!d.relatedTarget && d.fromElement)d.relatedTarget = d.fromElement === d.target ? d.toElement : d.fromElement;
    return d
}, isNative:function (a) {
    return!!a && (/\{\s*\[native code\]\s*\}/.test(String(a)) || /\{\s*\/\* source code not available \*\/\s*\}/.test(String(a)))
}});
lib.Element = Class.create({initialize:function (a) {
    this._els = a;
    Array.prototype.push.apply(this, this._els);
    this._events = {}
}});
Object.extend(lib.Element.prototype, {length:0, get:function (a) {
    return this._els[a]
}, getAll:function () {
    return this._els
}, each:function (a) {
    for (var b = 0, c = this._els.length; b < c; b++)a(lib.$(this._els[b]), b)
}, html:function () {
    var a = this._els[0], b = "", c = "";
    if (a) {
        if (arguments.length == 1)return a.innerHTML = arguments[0], this; else if (arguments.length == 2)if (c = arguments[0], b = arguments[1], a.insertAdjacentHTML)a.insertAdjacentHTML(c, b); else {
            var d = null, d = a.ownerDocument.createRange();
            switch (String(c).toLowerCase()) {
                case "beforebegin":
                    d.setStartBefore(a);
                    d = d.createContextualFragment(b);
                    a.parentNode.insertBefore(d, a);
                    break;
                case "afterbegin":
                    d.selectNodeContents(a);
                    d.collapse(!0);
                    d = d.createContextualFragment(b);
                    a.insertBefore(d, a.firstChild);
                    break;
                case "beforeend":
                    d.selectNodeContents(a);
                    d.collapse(!1);
                    d = d.createContextualFragment(b);
                    a.appendChild(d);
                    break;
                case "afterend":
                    d.setStartAfter(a), d = d.createContextualFragment(b), a.parentNode.insertBefore(d, a.nextSibling)
            }
        }
        return a.innerHTML
    }
}, load:function (a, b) {
    var c = this._els[0];
    c && (b = b || {}, lib.net.Ajax.text(a,
        {success:function (a) {
            c.innerHTML = b.success && b.success(a) || a
        }, failure:function () {
            if (b.failure)c.innerHTML = b.failure()
        }}))
}, parent:function (a) {
    var b = this._els[0];
    if (b)return a ? b.nodeName.toLowerCase() == a ? lib.$(b) : (this._els[0] = b.parentNode, this.parent(a)) : lib.$(b.parentNode)
}, attr:function (a, b) {
    if (typeof b != "undefined" && b != null)return lib.each(this._els, function (c) {
        switch (a) {
            case "class":
                c.className = b;
                break;
            case "style":
                c.style.cssText = b;
                break;
            default:
                c.setAttribute(a, b)
        }
    }), this; else switch (a) {
        case "class":
            return this._els[0].className;
        case "style":
            return this._els[0].style.cssText;
        default:
            return this._els[0].getAttribute(a)
    }
}, removeAttr:function (a) {
    lib.each(this._els, function (b) {
        b.removeAttribute(a)
    });
    return this
}, pos:function (a) {
    if (a) {
        if ("left"in a)this._els[0].style.left = a.left + "px";
        if ("top"in a)this._els[0].style.top = a.top + "px";
        if ("right"in a)this._els[0].style.right = a.right + "px";
        if ("bottom"in a)this._els[0].style.bottom = a.bottom + "px"
    } else return lib.box.getPosition(this._els[0])
}, box:function () {
    var a = this._els[0], b = this.pos();
    b.width = a.offsetWidth;
    b.height = a.offsetHeight;
    b.bottom = b.top + b.height;
    b.right = b.left + b.width;
    return b
}, val:function (a) {
    var b = this._els[0], c = null;
    if (a != void 0)return b.value = a, this; else {
        switch (b.tagName.toLowerCase()) {
            case "input":
            case "textarea":
                c = b.value;
                break;
            case "select":
                a = b.selectedIndex;
                if (b.options.length > 0)c = b.options[a > -1 ? a : 0].value;
                break;
            default:
                (b = b.getAttribute("data-value")) && (c = b)
        }
        return c
    }
}, addClass:function (a) {
    lib.each(this._els, function (b) {
        var c = b.className.replace(/^\s+|\s+$/g, "").replace(/\s+/g,
            " ").split(" ");
        if (c.indexOf(a) == -1)c.push(a), b.className = c.join(" ")
    });
    return this
}, removeClass:function (a) {
    lib.each(this._els, function (b) {
        var c = b.className.replace(/^\s+|\s+$/g, "").replace(/\s+/g, " ").split(" "), d = c.indexOf(a);
        if (d > -1)c.splice(d, 1), b.className = c.join(" ")
    }.bind(this));
    return this
}, hasClass:function (a) {
    return this._els[0].className.replace(/^\s+|\s+$/g, "").replace(/\s+/g, " ").split(" ").include(a)
}, css:function (a, b) {
    if (typeof b == "undefined") {
        var c = this._els[0];
        if (a == "opacity")if (lib.IE) {
            var c =
                c.style.filter, d = c.toLowerCase();
            return c && d.indexOf("opacity=") >= 0 ? parseFloat(d.match(/opacity=([^)]*)/)[1]) / 100 : 1
        } else return c.style.opacity ? parseFloat(c.style.opacity) : 1; else {
            d = function (a) {
                return a.replace(/[A-Z]/g, function (a) {
                    return"-" + a.toLowerCase()
                })
            };
            if (window.getComputedStyle)try {
                return window.getComputedStyle(c, null).getPropertyValue(d(a))
            } catch (e) {
                return
            }
            if (document.defaultView && document.defaultView.getComputedStyle) {
                var f = document.defaultView.getComputedStyle(c, null);
                if (f)return f.getPropertyValue(d(a));
                if (a == "display")return"none"
            }
            if (c.currentStyle)return c.currentStyle[a];
            return c.style[a]
        }
    } else return this.each(function (c) {
        if (a == "opacity")if (lib.IE) {
            c[0].style.filter = "Alpha(Opacity=" + b * 100 + ");";
            try {
                c[0].style.opacity = b == 1 ? "1" : "" + b
            } catch (d) {
            }
        } else c[0].style.opacity = b == 1 ? "1" : "" + b; else c[0].style[a] = b
    }), this
}, append:function (a) {
    this._els[0].appendChild(a._els[0]);
    return this
}, elements:function () {
    return this._els
}, show:function () {
    lib.each(this._els, function (a) {
        a.style.display = "block"
    });
    return this
},
    hide:function () {
        lib.each(this._els, function (a) {
            a.style.display = "none"
        });
        return this
    }, focus:function (a) {
        if (typeof a == "function")lib.Event.on(this._els[0], "focus", a); else this._els[0].focus();
        return this
    }, blur:function (a) {
        if (typeof a == "function")lib.Event.on(this._els[0], "blur", a); else this._els[0].blur();
        return this
    }, down:function (a) {
        return lib.$(a, this._els[0])
    }, on:function (a, b) {
        lib.each(this._els, function (c) {
            if (!c._events)c._events = {};
            if (!lib.IE && (a == "mouseleave" || a == "mouseenter")) {
                a = a == "mouseleave" ?
                    "mouseout" : "mouseover";
                var d = b;
                b = function (a) {
                    var b = a.relatedTarget;
                    (b == null || b && b != this && !lib.$(this).contains(b)) && d.apply(this, arguments)
                }
            }
            c._events[a] || (c._events[a] = []);
            if (!b.guid)b.guid = lib.guid++;
            var e = b._scopeApplied ? b : b.bindEvent(c);
            e.guid = b.guid;
            e.handler = b;
            c._events[a].push(e);
            lib.Event.on(c, a, e)
        });
        return this
    }, un:function (a, b) {
        var c = arguments;
        lib.each(this._els, function (d) {
            if (!lib.IE && (a == "mouseleave" || a == "mouseenter"))a = a == "mouseleave" ? "mouseout" : "mouseover";
            var e = d._events, f = 0, g;
            if (e &&
                (e = e[a]))if (c.length === 1)for (g = e.length; f < g; f++)lib.$(d).un(a, e[0].handler); else if (b)for (; f < e.length; f++)if (g = e[f], b.guid === g.guid) {
                e.splice(f--, 1);
                lib.Event.un(d, a, g);
                break
            }
        });
        return this
    }, _delegateList:[], _getDlgParent:function (a) {
        if (!a)return null;
        return a.getAttribute && (a.getAttribute("j-delegate") || a.getAttribute("j-dlg")) ? a : this._getDlgParent(a.parentNode)
    }, delegate:function (a, b, c) {
        if (a) {
            var b = b || function () {
            }, c = c || "click", d = this, e = function (c) {
                var c = window.event || c, e = c.target || c.srcElement,
                    j = e.getAttribute("j-delegate") || e.getAttribute("j-dlg");
                j && j == a ? b({target:e, event:c}) : e.getAttribute("j-dlgbubble") !== null && (e = d._getDlgParent(e), j = e.getAttribute("j-delegate") || e.getAttribute("j-dlg"), e && j && j == a && b({target:e, event:c}))
            };
            this._delegateList.push([b, e]);
            lib.$(this._els[0]).on(c, e);
            return this
        }
    }, prev:function () {
        var a = this._els[0];
        if (a && a.previousElementSibling)return a.previousElementSibling;
        do a = a.previousSibling; while (a && a.nodeType != 1);
        return a
    }, next:function () {
        var a = this._els[0];
        if (a && a.nextElementSibling)return a.nextElementSibling;
        do a = a.nextSibling; while (a && a.nodeType != 1);
        return a
    }, first:function () {
        for (var a = this._els[0], a = a.firstChild; a.nodeType != 1;)a = a.nextSibling;
        return lib.$(a)
    }, last:function () {
        for (var a = this._els[0], a = a.lastChild; a.nodeType != 1;)a = a.previousSibling;
        return lib.$(a)
    }, children:function () {
        var a = this._els[0], b = [], a = a.firstChild;
        do a.nodeType == 1 && b.push(a), a = a.nextSibling; while (a);
        return new lib.Element(b)
    }, undelegate:function (a, b, c) {
        for (var a = null, d = this._delegateList,
                 e = d.length, f = 0; f < e; f++)d[f][0] === b && (a = d[f][1]);
        a && lib.$(this._els[0]).un(c || "click", a)
    }, remove:function () {
        this._els.each(function (a) {
            a.parentNode && a.parentNode.removeChild(a)
        })
    }, contains:function (a) {
        a = lib.$(a);
        if (this._els[0].contains)return this._els[0].contains(a._els[0]); else if (this._els[0].compareDocumentPosition)return this._els[0].compareDocumentPosition(a._els[0]) == 20; else {
            for (var b = !1, a = a._els[0]; a.parentNode != null;) {
                if (a.parentNode === this._els[0]) {
                    b = !0;
                    break
                }
                a = a.parentNode
            }
            return b
        }
    }, fixPostion:function () {
        var a =
            this.box().bottom - lib.box.getViewportHeight(), b = lib.box.getPageScrollTop();
        (b < a || b > this.box().top) && window.scrollTo(0, a)
    }});
lib.Element.create = function (a) {
    return new lib.Element([document.createElement(a)])
};
lib.$ = function (a, b) {
    if (a === null)return null;
    if (typeof a != "string") {
        if (a.attr) {
            if (!a._els[0])return null;
            return a
        }
        return new lib.Element([a])
    }
    var c = lib.find(a, b);
    if (c && c.length > 0)return new lib.Element(c);
    return null
};
if (!lib.NO_CONFLICT)window.$ = lib.$;
lib.Template = Class.create({initialize:function (a) {
    this.template = a + "";
    this.pattern = {left:"${",right:"}"};
    this.regPattern = /(?:^|.|\r|\n)?(\$\{(.*?)\})/g
}, evaluate:function (a) {
    var b = "";
    if (typeof a == "object")var c = this, b = this.template.replace(this.regPattern, function (b, e, f) {
        if ((b = b.split(c.pattern.left)[0]) && b == "\\")return e;
        return a[f] != void 0 ? b + a[f] : b
    });
    return b
}});
lib.TemplateNew = Class.create({initialize:function (a, b) {
    this.template = a + "";
    this.filter = "\\";
    this._isNesting = /([\s\S])?\$[^{]*?\{(?:(?![{}]).|\{(?:(?![{}]).)*\})*\}/;
    this._regPattern = /([\s\S]?)\$(\w*){((?:(?:\$\w*){(?:(?:\$\w*)?{(?:(?:\$\w*)?{(?:(?:\$\w*)?{(?:(?:\$\w*)?{(?:(?:\$\w*)?{[^{}]*}|[^{}])*}|[^{}])*}|[^{}])*}|[^{}])*}|[^{}])*}|[^{}])*)?}/g;
    this._funs = {};
    this._tmp_cache = {};
    this.params = {};
    this.self_params = {};
    if (b)for (var c in b)b.hasOwnProperty(c) && (typeof b[c] == "function" ? this._funs[c] = b[c] :
        this.self_params[c] = b[c])
}, evaluate:function (a, b) {
    var c = "";
    if (typeof a == "object") {
        this._tmp_cache = {};
        (this.params = a) && Object.extend(this.params, this.self_params);
        a && Object.extend(this.params, b);
        var d = this, c = this.template.replace(this._regPattern, function (b, c, g, j) {
            if (RegExp("^\\" + d.filter, "").test(b))return b.split("" + d.filter)[1];
            d._isNesting.test(j) && (j = j.replace(d._regPattern, arguments.callee));
            for (var h = j ? j.split(",") : [], k = 0, l = h.length; k < l; k++)h[k] = d.trim(h[k]);
            switch (g) {
                case "":
                    return c + d.get(h[0]);
                case "trim":
                    return l == 2 && h[1] && h[1].toLowerCase() == "html" ? (k = d.get(h[0]), c + (k ? d.trimHTML(k) : "")) : (k = d.get(h[0]), c + (k ? d.trim(k) : ""));
                case "encode":
                    return h = d.get(h[0]), c + (h && d.encode(h));
                case "time":
                    if (!/\d*/g.test(h[0]))throw Error("error(lib.TemplateNew.evaluate): time format is incorrect");
                    h = d.get(h[0]) || 0;
                    return c + (h ? d.time_format(h) : "");
                case "date":
                    if (!h[1])throw Error("error(lib.TemplateNew.evaluate): date format argument[1] is null");
                    k = d.get(h[0]);
                    if (!/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/g.test(k))throw Error("error(lib.TemplateNew.evaluate): date format is incorrect");
                    return c + (k ? d.date_format(k, h[1]) : "");
                case "evalstr":
                    var o;
                    try {
                        o = d.get(h[0])
                    } catch (m) {
                        throw Error("error(lib.TemplateNew.evaluate): evalstr error");
                    }
                    return c + eval(o);
                case "cache":
                    if (a[h[h.length - 1]])throw Error("error(lib.TemplateNew.evaluate): cache key the same with params key is not allowed");
                    k = h.slice(0, h.length - 1).join(",");
                    a[k] && (d._tmp_cache[h[h.length - 1]] = a[k]) || k && (d._tmp_cache[h[h.length - 1]] = k);
                    return c;
                case "fixed":
                    return k = d.get(h[0]), h[1] ? c + (k && d.fixed(k, h[1]) || "") : c + k;
                case "divide":
                    return h =
                        d.get(h[0]), c + (h && d.divide(h));
                case "img":
                    return k = d.get(h[0]), c + k.setImgSize(h[1]);
                case "arr":
                    k = h.slice(0, h.length - 1).join();
                    k = /\[[^\]]*\]/.test(k) ? k : d.get(h[0]);
                    if (typeof k == "string")try {
                        k = eval("(" + k + ")")
                    } catch (p) {
                        throw Error("error(lib.TemplateNew.evaluate): array format error");
                    }
                    return c + (k[h[h.length - 1] ? h[h.length - 1] : 0] || "");
                case "obj":
                    k = h.slice(0, h.length - 1).join();
                    k = /{[^}]*}/.test(k) ? k : d.get(h[0]);
                    if (typeof k == "string")try {
                        k = eval("(" + k + ")")
                    } catch (q) {
                        throw Error("error(lib.TemplateNew.evaluate): object format error");
                    }
                    h = h[1];
                    return c + (h && k[h] || "");
                case "pick":
                    try {
                        switch (l) {
                            case 2:
                                var n = d.get(h[0]);
                                return c + eval(n + "? '" + h[1] + "' : ''");
                            case 3:
                                return n = d.get(h[0]), c + eval(n + "? '" + h[1] + "':'" + h[2] + "'");
                            case 4:
                                return n = d.get(h[0]), c + (n ? n == h[1] ? h[2] : h[3] : "");
                            default:
                                throw Error("error(lib.TemplateNew.evaluate): the parameter num is incorrect");
                        }
                    } catch (r) {
                        switch (l) {
                            case 2:
                                return n = d.get(h[0]), c + eval("'" + n + "'? '" + h[1] + "' : ''");
                            case 3:
                                return n = d.get(h[0]), c + eval("'" + n + "'? '" + h[1] + "':'" + h[2] + "'");
                            default:
                                throw Error("error(lib.TemplateNew.evaluate): the parameter num is incorrect");
                        }
                    }
                default:
                    if (/^f_/.test(g)) {
                        k = g && g.split("f_")[1];
                        if (!k || !d._funs[k])throw Error("error(lib.TemplateNew.evaluate): function " + k + " is not exists");
                        return c + d._funs[k].apply(d, h)
                    }
            }
        })
    }
    return c
}, get:function (a) {
    if (a in this.params)return this.params[a];
    if (a in this._tmp_cache)return this._tmp_cache[a];
    return a
}, divide:function (a) {
    return a.divideNumber()
}, encode:function (a) {
    return encodeURIComponent(a)
}, trim:function (a) {
    return a.trim()
}, trimHTML:function (a) {
    return a.trimHtml()
}, fixed:function (a, b) {
    return a.trancate(b)
},
    date_format:function (a, b) {
        var c = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/.exec(a), d = c[1], e = c[2], f = c[3], g = c[4], j = c[5], c = c[6], b = b || "hh:mm:ss";
        /ss/.test(b) && (b = b.replace(/ss/, c));
        /mm/.test(b) && (b = b.replace(/mm/, j));
        /hh/.test(b) && (b = b.replace(/hh/, g));
        /MM/.test(b) && (b = b.replace(/MM/, e));
        /DD/.test(b) && (b = b.replace(/DD/, f));
        /YYYY/.test(b) && (b = b.replace(/YYYY/, d));
        /YY/.test(b) && (b = b.replace(/YY/, d.substring(2)));
        return b
    }, time_format:function (a) {
        var b = Math.floor(a / 60);
        a %= 60;
        a < 10 && (a = "0" + a);
        if (b >
            60) {
            var c = Math.floor(b / 60);
            b %= 60;
            c < 10 && (c = "0" + c);
            b < 10 && (b = "0" + b);
            return c + ":" + b + ":" + a
        } else return b < 10 && (b = "0" + b), b + ":" + a
    }});
lib.storage = Class.create({initialize:function () {
}, opt:function (a, b) {
    this.userData = this.userDataOpt(a, b);
    this.cookieData = this.cookieDataOpt(a, b);
    this.localData = this.localDataOpt(a, b);
    this.globalData = this.globalDataOpt(a, b);
    this.sessionData = this.sessionDataOpt(a, b);
    if (!b)return this.userData || this.cookieData || this.localData || this.globalData || this.sessionData
}, userDataOpt:function (a, b) {
    try {
        var c = this.createElem("div", "userdata_el", 1);
        c.style.behavior = "url(#default#userData)";
        if (typeof b != "undefined")c.setAttribute(a,
            b), c.save(a); else return c.load(a), c.getAttribute(a)
    } catch (d) {
    }
}, removeUserData:function (a) {
    try {
        var b = this.createElem("div", "userdata_el", 1);
        b.style.behavior = "url(#default#userData)";
        b.load(a);
        b.expires = (new Date(315532799E3)).toUTCString();
        b.save(a)
    } catch (c) {
    }
}, cookieDataOpt:function (a, b) {
    if (typeof b != "undefined")document.cookie = a + "=; expires=Mon, 20 Sep 2010 00:00:00 UTC; path=/", document.cookie = a + "=" + b + "; expires=Tue, 31 Dec 2030 00:00:00 UTC; path=/"; else return this.getFromStr(a, document.cookie)
},
    removeCookieData:function (a) {
        document.cookie = a + "=; expires=Mon, 20 Sep 2010 00:00:00 UTC; path=/"
    }, localDataOpt:function (a, b) {
        try {
            if (window.localStorage)if (typeof b != "undefined")localStorage.setItem(a, b); else return localStorage.getItem(a)
        } catch (c) {
        }
    }, globalDataOpt:function (a, b) {
        if (window.globalStorage) {
            this.getHost();
            try {
                if (typeof b != "undefined")eval("globalStorage[host]." + a + " = value"); else return eval("globalStorage[host]." + a)
            } catch (c) {
            }
        }
    }, sessionDataOpt:function (a, b) {
        try {
            if (window.sessionStorage)if (typeof b !=
                "undefined")sessionStorage.setItem(a, b); else return sessionStorage.getItem(a)
        } catch (c) {
        }
    }, getFromStr:function (a, b) {
        if (typeof b == "string")for (var c = a + "=", d = b.split(/[;&]/), e = 0; e < d.length; e++) {
            for (var f = d[e]; f.charAt(0) == " ";)f = f.substring(1, f.length);
            if (f.indexOf(c) == 0)return f.substring(c.length, f.length)
        }
    }, getHost:function () {
        var a = document.location.host;
        a.indexOf("www.") == 0 && (a = a.replace("www.", ""));
        return a
    }, createElem:function (a, b, c) {
        a = typeof b != "undefined" && document.getElementById(b) ? document.getElementById(b) :
            document.createElement(a);
        a.style.visibility = "hidden";
        a.style.position = "absolute";
        b && a.setAttribute("id", b);
        c && document.body.appendChild(a);
        return a
    }});
lib.$url = function (a) {
    var b = a.replace(/[\s\S]+.html(?:\?([^#]+))?(?:#([\s\S]+))?/g, function (a, b, c) {
        return b && c ? b + "&" + c : b || c
    }), c = arguments.length == 2 && arguments[1].sort ? arguments[1] : [].slice.call(arguments, 1), d = [], e, f;
    e = {};
    for (c = RegExp("(&?)((" + c.join("|") + ")(=?)([^&#?]*))", "g"); (f = c.exec(b)) != null;) {
        if (f[2].indexOf("=") == -1) {
            var g = f[3], j = f[5];
            d.push(f[4] ? f[5] : f[2])
        } else f = f[2].split("="), g = f[0], j = f[1], d.push(j);
        g && (e[g] = j)
    }
    if (d.length != 0)return e.params = d, e
};
lib.$tmp = function (a, b) {
    for (var c = new lib.TemplateNew(a), d = [], e = 0, f = b.length; e < f; e++)d.push(c.evaluate(b[e]));
    return d.join("")
};
lib.Event = {on:function (a, b, c) {
    if (!a || !b || !c)return this;
    a.addEventListener ? a.addEventListener(b, c, !1) : a.attachEvent ? a.attachEvent("on" + b, c) : lib.Event.manager.add(b, eventHandle);
    return this
}, unbind:function (a, b, c) {
    for (var d = 0, e = c.length; d < e; d++)this.un(a, b, c[d]);
    a["on" + b] = null;
    return this
}, un:function (a, b, c) {
    if (!a || !b)return this;
    a.removeEventListener ? (b === "mouseleave" ? b = "mouseout" : b === "mouseenter" && (b = "mouseover"), a.removeEventListener(b, c, !1)) : a.detachEvent ? a.detachEvent("on" + b, c) : lib.Event.manager.del(b,
        c)
}, stop:function (a) {
    lib.Event.stopPropagation(a);
    lib.Event.preventDefault(a)
}, stopPropagation:function (a) {
    a.cancelBubble = !0;
    a.stopPropagation && a.stopPropagation()
}, preventDefault:function (a) {
    try {
        a.returnValue = !1, a.preventDefault && a.preventDefault()
    } catch (b) {
    }
}, getEvent:function () {
    if (event)return event;
    for (var a = arguments.callee.caller, b, c = 0; a != null && c < 40;) {
        if ((b = a.arguments[0]) && (b.constructor == Event || b.constructor == MouseEvent))break;
        c++;
        a = a.caller
    }
    return b
}};
lib.go = function (a) {
    location.href = a
};
lib.base = function (a, b) {
    var c = arguments.callee.caller;
    if (c.superClass_)return c.superClass_.constructor.apply(a, Array.prototype.slice.call(arguments, 1));
    for (var d = Array.prototype.slice.call(arguments, 2), e = !1, f = a.constructor; f; f = f.superClass_ && f.superClass_.constructor)if (f.prototype[b] === c)e = !0; else if (e)return f.prototype[b].apply(a, d);
    if (a[b] === c)return a.constructor.prototype[b].apply(a, d); else throw Error("lib.base called from a method of one name to a method of a different name");
};
lib.inherits = function (a, b) {
    function c() {
    }

    c.prototype = b.prototype;
    a.superClass_ = b.prototype;
    a.prototype = new c;
    a.prototype.constructor = a
};
Object.extend(lib, {Class:function (a, b) {
    if (arguments[0] && typeof arguments[0] == "object")return Class.create.apply(null, arguments);
    var c = b.ns || lib;
    if (c[a])return c[a];
    var d = b.extend || lib.Object, e = function () {
    };
    e.prototype = d.prototype;
    var f = b.construct || function () {
    }, g = b.properties || {}, j = b.methods || {}, h = b.statics || {}, e = new e, k;
    for (k in e)e.hasOwnProperty(k) && delete e[k];
    for (k in g)e[k] = g[k];
    for (k in j)e[k] = j[k], e[k]._construct = f;
    e.constructor = f;
    e.superclass = d;
    e.__NAME__ = a;
    f.prototype = e;
    for (k in h)f[k] =
        h[k];
    return c[a] = f
}, abstractMethod:function () {
    throw"not implemented";
}, emptyMethod:function () {
}, reg:$reg});
lib.Class("Object", {extend:Object, methods:{callsuper:function (a) {
    if (typeof a == "string") {
        var b = arguments.callee.caller._construct.prototype.superclass, c = [];
        if (arguments.length > 1)for (var d = 1; d < arguments.length; d++)c.push(arguments[d]);
        return b.prototype[a].apply(this, c)
    } else return arguments.callee.caller.prototype.superclass.apply(this, arguments)
}}});
Object.extend(Function.prototype, {bind:function () {
    for (var a = this, b = arguments[0], c = [], d = 1, e = arguments.length; d < e; d++)c.push(arguments[d]);
    return function () {
        for (var d = c.concat(), e = 0, j = arguments.length; e < j; e++)d.push(arguments[e]);
        return a.apply(b, d)
    }
}, bindEvent:function () {
    for (var a = this, b = arguments[0], c = [], d = 1, e = arguments.length; d < e; d++)c.push(arguments[d]);
    return function (d) {
        var e = c.concat();
        e.unshift(d || window.event);
        return a.apply(b, e)
    }
}, method:function (a, b) {
    this[a] = b;
    return this
}, inherits:function (a) {
    function b() {
    }

    this.superClass_ = b.prototype = a.prototype;
    this.prototype = new b;
    this.prototype.constructor = this
}});
Object.extend(lib, function () {
    var a = {}, b = navigator.userAgent.toLowerCase(), c = navigator.plugins;
    a.IE = /msie/.test(b);
    a.OPERA = /opera/.test(b);
    a.MOZ = /gecko/.test(b);
    a.IE6 = /msie 6/.test(b);
    a.IE7 = /msie 7/.test(b);
    a.IE8 = /msie 8/.test(b);
    a.IE9 = /msie 9/.test(b);
    a.SAFARI = /safari/.test(b) && !/chrome/.test(b);
    a.WEBKIT = /webkit/.test(b);
    a.winXP = /windows nt 5.1/.test(b);
    a.winVista = /windows nt 6.0/.test(b);
    a.CHROME = /chrome/.test(b);
    a.iphone = /iphone os/.test(b);
    a.ipod = /ipod\;/.test(b);
    a.android = /android/.test(b);
    a.iphone4 =
        /iphone os [456]_/.test(b);
    a.realIpad = /ipad/.test(b);
    a.lePad = /lepad_hls/.test(b);
    a.Mac = /macintosh/.test(b);
    a.ipad = a.realIpad || a.iphone || a.lePad;
    a.noFlashAndroid = a.WEBKIT && a.android && (!c || !c["Shockwave Flash"]);
    a.TT = /tencenttraveler/.test(b);
    a.$360 = /360se/.test(b);
    a.ff = /firefox/.test(b);
    a.ff4 = /firefox\/4/.test(b);
    a.Maxthon = !1;
    try {
        a.html5Video = !!document.createElement("video").play
    } catch (d) {
        a.html5Video = !1
    }
    try {
        a.Maxthon = window.external.max_version ? !0 : !1
    } catch (e) {
    }
    lib.swf.browserVer = function () {
        if (a.IE6)return"IE6";
        if (a.IE7)return"IE7";
        if (a.IE8)return"IE8";
        if (a.IE9)return"IE9";
        if (a.ff)return"fireFox";
        if (a.CHROME)return"chrome";
        return"none"
    };
    a.getOS = function () {
        var a = navigator.userAgent, b = navigator.platform == "Win32" || navigator.platform == "Windows", c = navigator.platform == "Mac68K" || navigator.platform == "MacPPC" || navigator.platform == "Macintosh" || navigator.platform == "MacIntel";
        if (c)return"Mac";
        if (navigator.platform == "X11" && !b && !c)return"Unix";
        if (b) {
            if (a.indexOf("Windows NT 5.0") > -1 || a.indexOf("Windows 2000") > -1)return"Win2000";
            if (a.indexOf("Windows NT 5.1") > -1 || a.indexOf("Windows XP") > -1)return"WinXP";
            if (a.indexOf("Windows NT 5.2") > -1 || a.indexOf("Windows 2003") > -1)return"Win2003";
            if (a.indexOf("Windows NT 6.0") > -1 || a.indexOf("Windows Vista") > -1)return"WinVista";
            if (a.indexOf("Windows NT 6.1") > -1 || a.indexOf("Windows 7") > -1)return"Win7"
        }
        return"None"
    };
    a.getBr = function () {
        var a = navigator.userAgent.toLowerCase(), b = !1;
        try {
            var c = window.external;
            if (b = c.max_version ? !0 : !1)return"\u50b2\u6e38 " + c.max_version
        } catch (d) {
        }
        if (/msie/.test(a))return a.match(/msie [\d.]+/)[0];
        if (/Firefox/i.test(a))return"firefox " + a.match(/firefox\/([\d.]+)/)[1];
        if (/360se/.test(a))return"360";
        if (/tencenttraveler/.test(a))return"TT";
        if (/chrome\/([\d.]+)/.test(a))return a.match(/chrome\/[\d.]+/);
        if (/safari/.test(a))return a.match(/safari\/[\d.]+/);
        if (/opera/.test(a))return"opera";
        return"\u975e\u4e3b\u6d41\u6d4f\u89c8\u5668"
    };
    return a
}());
if (lib.IE6)try {
    document.execCommand("BackgroundImageCache", !1, !0)
} catch (e$$28) {
}
lib.WMODE = lib.SAFARI || lib.IE || lib.CHROME && lib.winXP ? "Opaque" : "window";
lib.kit.slog = {url:"http://jsmsg.video.qiyi.com/m.gif", log:function (a, b) {
    if (b)this.url = b;
    if (a) {
        var c = new Image, d = "slog_" + Math.floor(Math.random() * 2147483648).toString(36);
        lib.kit.slog[d] = c;
        c.onload = c.onerror = c.onabort = function () {
            c.onload = c.onerror = c.onabort = null;
            lib.kit.slog[d] = null;
            delete lib.kit.slog[d];
            c = null
        };
        var e = [];
        a.t = Math.round(Math.random() * 2147483647);
        for (d in a)e.push(d + "=" + encodeURIComponent(a[d]));
        c.src = this.url + "?" + e.join("&")
    }
}};
var Url = function (a) {
    this.url = a || "";
    this.query = {};
    this.hrParam = {};
    this.info = {};
    this.parse()
};
(function (a) {
    a.prototype = {parse:function (a) {
        if (a)this.url = a;
        this.parseAnchor();
        this.parseParam();
        this.parseInfo()
    }, parseAnchor:function () {
        var a = this.url.match(/\#(.*)/);
        this._anchor = a = a ? a[1] : null;
        if (a != null)this.anchor = this.getNameValuePair(a), this.url = this.url.replace(/\#.*/, "")
    }, parseParam:function () {
        var a = this.url.match(/\?([^\?]*)/), a = a ? a[1] : null;
        if (a != null)this.query = this.getNameValuePair(a), this.hrParam = this.getNameValuePair(a, "-"), this.url = this.url.replace(/\?([^\?]*)/, "")
    }, parseInfo:function () {
        var a =
            this.url.match(/(\w+):\/\/([^\/:]+):?(\d*)((?:\/|$).*)/);
        if (a)this.info = {protocol:a[1], host:a[2], port:a[3], path:a[4]}
    }, getNameValuePair:function (a, c) {
        var d = {}, e = c || "&";
        a.replace(RegExp("([^" + e + "=]*)(?:=([^" + e + "]*))?", "gim"), function (a, b, c) {
            if (b == "")return d;
            d[b] = c || ""
        });
        return d
    }, getParam:function (a) {
        return this.query[a] || ""
    }, getHrParam:function (a) {
        return this.hrParam[a] || ""
    }, getHostname:function () {
        return this.info.host
    }, clearParam:function () {
        this.query = {}
    }, setParam:function (a, c) {
        if (a == null || a == "" ||
            typeof a != "string")throw Error("no param name set");
        this.query = this.query || {};
        this.query[a] = c
    }, setParams:function (a) {
        this.query = a
    }, serialize:function (a) {
        var c = [], d;
        for (d in a)a[d] == null || a[d] == "" ? c.push(d + "=") : c.push(d + "=" + a[d]);
        return c.join("&")
    }, toString:function () {
        var a = this.serialize(this.query);
        return this.url + (a.length > 0 ? "?" + a : "") + (this.anchor ? "#" + this.serialize(this.anchor) : "")
    }, getHashStr:function (a) {
        return this.anchor ? "#" + this.serialize(this.anchor) : a ? "#" : ""
    }}
})(Url);
$reg("lib.kit.Url", function () {
    lib.kit.Url = Url
});
lib.kit.util = lib.kit.util || {};
lib.kit.util.jsLoad = {};
(function () {
    function a(a, b) {
        var c;
        try {
            if (typeof b != "undefined")for (c in a)b[c] && (a[c] = b[c])
        } finally {
            return a
        }
    }

    function b(a, b) {
        c(a, b);
        var d = a.urls, j = document.createElement("script");
        j.src = d.url;
        j.charset = d.charset;
        j.onload = j.onerror = j.onreadystatechange = function () {
            if (!j || !j.readyState || !(j.readyState != "loaded" && j.readyState != "complete"))b.script_loaded_num++, j.onload = j.onreadystatechange = j.onerror = null, j.src = "", j.parentNode.removeChild(j), j = null
        };
        document.getElementsByTagName("head")[0].appendChild(j)
    }

    function c(a, b) {
        var c = a.urls, d, h, k;
        if (typeof a.CACHE != "undefined") {
            var l = a.CACHE;
            h = c.url;
            for (d in l)d == "varname" ? k = l[d] : h += l[d] + "/";
            c.url = h.toString();
            if (a.spliter === "0")c.url = c.url.slice(0, -1)
        }
        if (typeof a.GET != "undefined") {
            h = new lib.kit.Url(c.url);
            l = a.GET;
            for (d in l)d == "cb" && (k = l[d]), h.setParam(d, encodeURIComponent(l[d]));
            c.url = h.toString()
        }
        b.script_var_arr.push(k);
        c.charset = a.charset || "utf-8"
    }

    function d(c, d) {
        var g = {urls:[], charset:"utf-8", timeout:-1, CACHE:d.CACHE, GET:d.GET, spliter:"1", onSuccess:function () {
        },
            onError:function () {
            }}, j = {script_loaded_num:0, is_timeout:!1, is_loadcomplete:!1, script_var_arr:[]};
        g.urls = typeof c == "string" ? {url:c} : c;
        a(g, d);
        b(g, j);
        (function () {
            if (!(g.noreturn == !0 && g.onComplete == null)) {
                var a, b = [];
                if (j.script_loaded_num == 1) {
                    if (j.is_loadcomplete = !0, g.onSuccess != null) {
                        for (a = 0; a < j.script_var_arr.length; a++) {
                            var c = j.script_var_arr[a].trim(), c = c.indexOf(".") != -1 ? eval(c) : window[c];
                            b.push(c)
                        }
                        if (j.script_var_arr.length < 2)if (typeof b[0] != "undefined" && (!b[0].code || b[0].code == "A00000"))g.onSuccess(typeof b[0].data ==
                            "undefined" ? b[0] : b[0].data); else g.onError(b[0]); else if (!b.code || b.code == "A00000")g.onSuccess(typeof b.data == "undefined" ? b : b.data); else g.onError(b)
                    }
                } else j.is_timeout != !0 && setTimeout(arguments.callee, 50)
            }
        })();
        g.timeout > 0 && setTimeout(function () {
            if (!j.is_loadcomplete) {
                if (g.onError)g.onError();
                j.is_timeout = !0
            }
        }, g.timeout)
    }

    lib.kit.util.jsLoad.request = function (a, b) {
        new d(a, b)
    }
})();
lib.action.html5VV = function () {
    var a = lib.$("#video"), b = info.ipad ? info.ipad.serverId || "" : "", c = function () {
            var a = 3;
            lib.realIpad && (a = 2);
            lib.iphone && (a = 3);
            a += lib.$("#j-back2App") ? "4" : "1";
            return a
        }(), d = {flag:"plyract", plyract:"", prgr:0, vid:info.videoId || "", aid:info.albumId || "", tvid:info.tvId || "", cid:info.ipad ? info.ipad.categoryId || "" : "", purl:window.location.protocol + "//" + window.location.host + window.location.pathname, pla:c, z:b, lev:a.attr("bits") || ""}, e = {flag:"error", errcode:"4015", tvid:info.tvId || "", cid:info.ipad ?
            info.ipad.categoryId || "" : "", pla:c, z:b, lev:a.attr("bits") || ""}, f, g = 0, j = 0, h = !0, k = !0, l = function (b) {
            var c = Object.extend({}, d);
            c.prgr = Math.round(a[0].currentTime);
            c.plyract = "timing";
            c.tl = b;
            c.puid = lib.component.login.getUserInfo().uid || "";
            m(function (a) {
                c.suid = a;
                lib.kit.slog.log(c, "http://msg.video.qiyi.com/vpb.gif")
            })
        }, o = function () {
            var b = Object.extend({}, d);
            b.prgr = Math.round(a[0].currentTime);
            b.plyract = "start";
            b.pla = c;
            b.puid = lib.component.login.getUserInfo().uid || "";
            m(function (a) {
                b.suid = a;
                lib.kit.slog.log(b,
                    "http://msg.video.qiyi.com/vpb.gif")
            })
        }, m = function (a) {
            var b = function (a) {
                var b;
                lib.kit.util.jsLoad.request("http://data.video.qiyi.com/uid", {CACHE:{varname:"uid"}, onSuccess:function (c) {
                    b = c ? c.uid : lib.md5(+new Date + Math.round(Math.random() * 2147483647) + "");
                    a(b)
                }, onError:function () {
                    a(data.uid)
                }, is_timeout:!0, timeout:2E3})
            };
            (uid = lib.cookie.get("suid")) ? a(uid) : b(function (b) {
                lib.cookie.set("suid", b, 8760, "/", lib.SITE_DOMAIN);
                a(b)
            })
        }, p = function () {
            h && (lib.kit.slog.log({c1:"1", c2:"7290408", c3:"", c4:"", c5:"",
                c6:""}, "http://b.scorecardresearch.com/b"), o(), h = !1);
            f = setTimeout(function () {
                j++;
                if (a[0].ended || a[0].paused)clearTimeout(f), a.on("timeupdate", p); else {
                    switch (g) {
                        case 0:
                            j == 15 && (l(j), g++);
                            break;
                        case 1:
                            j == 60 && (l(j), g++);
                            break;
                        case 2:
                            j == 120 && (l(j), j = 0)
                    }
                    f = setTimeout(arguments.callee, 1E3)
                }
            }, 1E3);
            a.un("timeupdate", p)
        }, b = function () {
            l(j)
        }, q = function () {
            var a = Object.extend({}, e);
            a.puid = lib.component.login.getUserInfo().uid || "";
            !h && k && m(function (b) {
                a.suid = b;
                lib.kit.slog.log(a, "http://msg.video.qiyi.com/err.gif")
            })
        },
        n = function () {
            k = !1
        }, r = function () {
            k = !0
        };
    a && a[0].play && (a.on("timeupdate", p), a.on("ended", b), a.on("waiting", q), a.on("seeking", n), a.on("canplay", r), $(window).on("beforeunload", b))
};
var hexcase = 0, b64pad = "", chrsz = 8;
function hex_md5(a) {
    return binl2hex(core_md5(str2binl(a), a.length * chrsz))
}
function b64_md5(a) {
    return binl2b64(core_md5(str2binl(a), a.length * chrsz))
}
function str_md5(a) {
    return binl2str(core_md5(str2binl(a), a.length * chrsz))
}
function hex_hmac_md5(a, b) {
    return binl2hex(core_hmac_md5(a, b))
}
function b64_hmac_md5(a, b) {
    return binl2b64(core_hmac_md5(a, b))
}
function str_hmac_md5(a, b) {
    return binl2str(core_hmac_md5(a, b))
}
function md5_vm_test() {
    return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72"
}
function core_md5(a, b) {
    a[b >> 5] |= 128 << b % 32;
    a[(b + 64 >>> 9 << 4) + 14] = b;
    for (var c = 1732584193, d = -271733879, e = -1732584194, f = 271733878, g = 0; g < a.length; g += 16)var j = c, h = d, k = e, l = f, c = md5_ff(c, d, e, f, a[g + 0], 7, -680876936), f = md5_ff(f, c, d, e, a[g + 1], 12, -389564586), e = md5_ff(e, f, c, d, a[g + 2], 17, 606105819), d = md5_ff(d, e, f, c, a[g + 3], 22, -1044525330), c = md5_ff(c, d, e, f, a[g + 4], 7, -176418897), f = md5_ff(f, c, d, e, a[g + 5], 12, 1200080426), e = md5_ff(e, f, c, d, a[g + 6], 17, -1473231341), d = md5_ff(d, e, f, c, a[g + 7], 22, -45705983), c = md5_ff(c, d, e, f, a[g + 8], 7,
        1770035416), f = md5_ff(f, c, d, e, a[g + 9], 12, -1958414417), e = md5_ff(e, f, c, d, a[g + 10], 17, -42063), d = md5_ff(d, e, f, c, a[g + 11], 22, -1990404162), c = md5_ff(c, d, e, f, a[g + 12], 7, 1804603682), f = md5_ff(f, c, d, e, a[g + 13], 12, -40341101), e = md5_ff(e, f, c, d, a[g + 14], 17, -1502002290), d = md5_ff(d, e, f, c, a[g + 15], 22, 1236535329), c = md5_gg(c, d, e, f, a[g + 1], 5, -165796510), f = md5_gg(f, c, d, e, a[g + 6], 9, -1069501632), e = md5_gg(e, f, c, d, a[g + 11], 14, 643717713), d = md5_gg(d, e, f, c, a[g + 0], 20, -373897302), c = md5_gg(c, d, e, f, a[g + 5], 5, -701558691), f = md5_gg(f, c, d, e, a[g +
        10], 9, 38016083), e = md5_gg(e, f, c, d, a[g + 15], 14, -660478335), d = md5_gg(d, e, f, c, a[g + 4], 20, -405537848), c = md5_gg(c, d, e, f, a[g + 9], 5, 568446438), f = md5_gg(f, c, d, e, a[g + 14], 9, -1019803690), e = md5_gg(e, f, c, d, a[g + 3], 14, -187363961), d = md5_gg(d, e, f, c, a[g + 8], 20, 1163531501), c = md5_gg(c, d, e, f, a[g + 13], 5, -1444681467), f = md5_gg(f, c, d, e, a[g + 2], 9, -51403784), e = md5_gg(e, f, c, d, a[g + 7], 14, 1735328473), d = md5_gg(d, e, f, c, a[g + 12], 20, -1926607734), c = md5_hh(c, d, e, f, a[g + 5], 4, -378558), f = md5_hh(f, c, d, e, a[g + 8], 11, -2022574463), e = md5_hh(e, f, c, d, a[g +
        11], 16, 1839030562), d = md5_hh(d, e, f, c, a[g + 14], 23, -35309556), c = md5_hh(c, d, e, f, a[g + 1], 4, -1530992060), f = md5_hh(f, c, d, e, a[g + 4], 11, 1272893353), e = md5_hh(e, f, c, d, a[g + 7], 16, -155497632), d = md5_hh(d, e, f, c, a[g + 10], 23, -1094730640), c = md5_hh(c, d, e, f, a[g + 13], 4, 681279174), f = md5_hh(f, c, d, e, a[g + 0], 11, -358537222), e = md5_hh(e, f, c, d, a[g + 3], 16, -722521979), d = md5_hh(d, e, f, c, a[g + 6], 23, 76029189), c = md5_hh(c, d, e, f, a[g + 9], 4, -640364487), f = md5_hh(f, c, d, e, a[g + 12], 11, -421815835), e = md5_hh(e, f, c, d, a[g + 15], 16, 530742520), d = md5_hh(d, e, f,
        c, a[g + 2], 23, -995338651), c = md5_ii(c, d, e, f, a[g + 0], 6, -198630844), f = md5_ii(f, c, d, e, a[g + 7], 10, 1126891415), e = md5_ii(e, f, c, d, a[g + 14], 15, -1416354905), d = md5_ii(d, e, f, c, a[g + 5], 21, -57434055), c = md5_ii(c, d, e, f, a[g + 12], 6, 1700485571), f = md5_ii(f, c, d, e, a[g + 3], 10, -1894986606), e = md5_ii(e, f, c, d, a[g + 10], 15, -1051523), d = md5_ii(d, e, f, c, a[g + 1], 21, -2054922799), c = md5_ii(c, d, e, f, a[g + 8], 6, 1873313359), f = md5_ii(f, c, d, e, a[g + 15], 10, -30611744), e = md5_ii(e, f, c, d, a[g + 6], 15, -1560198380), d = md5_ii(d, e, f, c, a[g + 13], 21, 1309151649), c = md5_ii(c,
        d, e, f, a[g + 4], 6, -145523070), f = md5_ii(f, c, d, e, a[g + 11], 10, -1120210379), e = md5_ii(e, f, c, d, a[g + 2], 15, 718787259), d = md5_ii(d, e, f, c, a[g + 9], 21, -343485551), c = safe_add(c, j), d = safe_add(d, h), e = safe_add(e, k), f = safe_add(f, l);
    return[c, d, e, f]
}
function md5_cmn(a, b, c, d, e, f) {
    return safe_add(bit_rol(safe_add(safe_add(b, a), safe_add(d, f)), e), c)
}
function md5_ff(a, b, c, d, e, f, g) {
    return md5_cmn(b & c | ~b & d, a, b, e, f, g)
}
function md5_gg(a, b, c, d, e, f, g) {
    return md5_cmn(b & d | c & ~d, a, b, e, f, g)
}
function md5_hh(a, b, c, d, e, f, g) {
    return md5_cmn(b ^ c ^ d, a, b, e, f, g)
}
function md5_ii(a, b, c, d, e, f, g) {
    return md5_cmn(c ^ (b | ~d), a, b, e, f, g)
}
function core_hmac_md5(a, b) {
    var c = str2binl(a);
    c.length > 16 && (c = core_md5(c, a.length * chrsz));
    for (var d = Array(16), e = Array(16), f = 0; f < 16; f++)d[f] = c[f] ^ 909522486, e[f] = c[f] ^ 1549556828;
    c = core_md5(d.concat(str2binl(b)), 512 + b.length * chrsz);
    return core_md5(e.concat(c), 640)
}
function safe_add(a, b) {
    var c = (a & 65535) + (b & 65535);
    return(a >> 16) + (b >> 16) + (c >> 16) << 16 | c & 65535
}
function bit_rol(a, b) {
    return a << b | a >>> 32 - b
}
function str2binl(a) {
    for (var b = [], c = (1 << chrsz) - 1, d = 0; d < a.length * chrsz; d += chrsz)b[d >> 5] |= (a.charCodeAt(d / chrsz) & c) << d % 32;
    return b
}
function binl2str(a) {
    for (var b = "", c = (1 << chrsz) - 1, d = 0; d < a.length * 32; d += chrsz)b += String.fromCharCode(a[d >> 5] >>> d % 32 & c);
    return b
}
function binl2hex(a) {
    for (var b = hexcase ? "0123456789ABCDEF" : "0123456789abcdef", c = "", d = 0; d < a.length * 4; d++)c += b.charAt(a[d >> 2] >> d % 4 * 8 + 4 & 15) + b.charAt(a[d >> 2] >> d % 4 * 8 & 15);
    return c
}
function binl2b64(a) {
    for (var b = "", c = 0; c < a.length * 4; c += 3)for (var d = (a[c >> 2] >> 8 * (c % 4) & 255) << 16 | (a[c + 1 >> 2] >> 8 * ((c + 1) % 4) & 255) << 8 | a[c + 2 >> 2] >> 8 * ((c + 2) % 4) & 255, e = 0; e < 4; e++)b += c * 8 + e * 6 > a.length * 32 ? b64pad : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".charAt(d >> 6 * (3 - e) & 63);
    return b
}
for (var plainText = "Rebellious subjects, enemies to peace,\n    Profaners of this neighbour-stained steel,--\n    Will they not hear? What, ho! you men, you beasts,\n    That quench the fire of your pernicious rage\n    With purple fountains issuing from your veins,\n    On pain of torture, from those bloody hands\n    Throw your mistemper'd weapons to the ground,\n    And hear the sentence of your moved prince.\n    Three civil brawls, bred of an airy word,\n    By thee, old Capulet, and Montague,\n    Have thrice disturb'd the quiet of our streets,\n    And made Verona's ancient citizens\n    Cast by their grave beseeming ornaments,\n    To wield old partisans, in hands as old,\n    Canker'd with peace, to part your canker'd hate:\n    If ever you disturb our streets again,\n    Your lives shall pay the forfeit of the peace.\n    For this time, all the rest depart away:\n    You Capulet; shall go along with me:\n    And, Montague, come you this afternoon,\n    To know our further pleasure in this case,\n    To old Free-town, our common judgment-place.\n    Once more, on pain of death, all men depart.", i =
    0; i < 4; i++)plainText += plainText;
var md5Output = hex_md5(plainText);
lib.md5 = hex_md5;
window.lib = window.lib || {};
lib.KEY = {};
Object.extend(lib.KEY, {BACKSPACE:8, TAB:9, RETURN:13, ESC:27, LEFT:37, UP:38, RIGHT:39, DOWN:40, DELETE:46, HOME:36, END:35, PAGEUP:33, PAGEDOWN:34, pointerX:function (a) {
    return a.pageX || a.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)
}, pointerY:function (a) {
    return a.pageY || a.clientY + (document.documentElement.scrollTop || document.body.scrollTop)
}});
lib.eventTarget = function () {
    this.handlers = {}
};
lib.eventTarget.prototype = {constructor:lib.eventTarget, on:function (a, b) {
    typeof this.handlers[a] == "undefined" && (this.handlers[a] = []);
    this.handlers[a].push(b)
}, fire:function (a) {
    if (!a.target)a.target = this;
    if (this.handlers[a.type]instanceof Array)for (var b = this.handlers[a.type], c = 0, d = b.length; c < d; c++)try {
        b[c](a)
    } catch (e) {
        lib.log(e)
    }
}, un:function (a, b) {
    if (this.handlers[a]instanceof Array) {
        for (var c = this.handlers[a], d = 0, e = c.length; d < e; d++)if (c[d] === b)break;
        c.splice(d, 1)
    }
}};
lib._PAGE_EVENT = new lib.eventTarget;
lib.swf = lib.swf || {};
lib.swf.playerLoaded = function () {
    lib._PLAYER_LOADED_TIME = (new Date).getTime()
};
lib.swf.startAcc = function () {
    var a = lib.cookie.get("startedAcc");
    if ((lib.IE6 || lib.IE7) && !a)lib.cookie.set("startedAcc", 1, 24, "/", lib.SITE_DOMAIN), window.location.href = "qiyiacc:\\StartMethod=1;WebBrowser=" + lib.swf.browserVer()
};
lib.swf.error = function (a) {
    lib.kit.slog && lib.kit.slog.log({flag:"flasherr_" + a})
};
(function () {
    var a = lib.swf.notice || function () {
    };
    lib.swf.notice = function (b) {
        a(b);
        try {
            var c = JSON.parse(b)
        } catch (d) {
            lib.kit.slog.log({flag:"SwfNoticeError", param:b});
            return
        }
        c.type = "swf_" + c.type;
        lib._PAGE_EVENT.fire(c)
    }
})();
var isWin = navigator.appVersion.toLowerCase().indexOf("win") != -1 ? !0 : !1, authUrl = "http://serv.vip.qiyi.com/services/padw_auth.action", video = lib.kit.video = {controlVersion:function () {
    var a, b;
    try {
        b = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7"), a = b.GetVariable("$version")
    } catch (c) {
    }
    if (!a)try {
        new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3"), a = "Player 3,0,18,0"
    } catch (d) {
    }
    if (!a)try {
        new ActiveXObject("ShockwaveFlash.ShockwaveFlash"), a = "Player 2,0,0,11"
    } catch (e) {
        a = -1
    }
    return(a + "").replace(/\,/g, ".")
},
    getSwfVer:function () {
        var a = -1;
        if (navigator.plugins && navigator.plugins.length > 0) {
            if (navigator.plugins["Shockwave Flash 2.0"] || navigator.plugins["Shockwave Flash"]) {
                var a = navigator.plugins["Shockwave Flash" + (navigator.plugins["Shockwave Flash 2.0"] ? " 2.0" : "")].description.split(" "), b = a[2].split("."), c = b[0], b = b[1], d = a[3];
                d == "" && (d = a[4]);
                d[0] == "d" ? d = d.substring(1) : d[0] == "r" && (d = d.substring(1), d.indexOf("d") > 0 && (d = d.substring(0, d.indexOf("d"))));
                a = c + "." + b + "." + d
            }
        } else navigator.userAgent.match(/webtv\/2.6/i) ?
            a = 4 : navigator.userAgent.match(/webtv\/2.5/i) ? a = 3 : navigator.userAgent.match(/webtv/i) ? a = 2 : lib.IE && isWin && !lib.OPERA && (a = this.controlVersion());
        return a
    }, html5video:function (a) {
        var b = this;
        this._renderVideo(a);
        var c = this._getVid(a);
        c && lib.kit.util.jsLoad.request("http://cache.vip.qiyi.com/ip4j/", {CACHE:{vid:c, varname:"ipLimit"}, onSuccess:function (c) {
            var e = typeof c.ipLimit != "undefined" ? c.ipLimit : 0;
            lib.cookie && (e = lib.cookie.get("iplimit") || e);
            lib.kit.util.jsLoad.request("http://data.video.qiyi.com/v.ts",
                {CACHE:{varname:"videoUrl"}, onSuccess:function (f) {
                    typeof f.l == "undefined" || f.l == "" ? (lib.$("#flashbox").html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u6682\u65f6\u4e0d\u652f\u6301\u60a8\u7684\u8bbe\u5907\u89c2\u770b\u3002"), lib.$("#flashbox").css("color", "#fff"), lib.$("#flashbox").css("font-size", "16px")) : f.t.match(/oversea/ig) && e == 1 ? (lib.$("#flashbox").html('\u7531\u4e8e\u7248\u6743\u53d7\u9650\uff0c\u60a8\u8bbf\u95ee\u7684\u89c6\u9891\u53ea\u80fd\u5728\u4e2d\u56fd\u5927\u9646\u8303\u56f4\u5185\u89c2\u770b\uff01<br/><span style="font-size:12px">\u5982\u679c\u60a8\u6240\u5728\u533a\u57df\u4e3a\u4e2d\u56fd\u5927\u9646\uff0c<a href="http://www.qiyi.com/common/helpandsuggest.html?entry=banquan" target="_blank" class="fWhite">\u8bf7\u544a\u77e5\u6211\u4eec</a> \u6211\u4eec\u5c06\u5c3d\u5feb\u67e5\u627e\u539f\u56e0\u3002'),
                        lib.$("#flashbox").css("color", "#fff"), lib.$("#flashbox").css("font-size", "16px")) : (c.ip = f.l, c.serverId = f.z, c.serverInfo = f.s, window.info = window.info || {}, window.info.ipad = c, window.productInfo && window.productInfo.isCharge ? b._getQiyi(a, function (c) {
                        Object.extend(window.info.ipad, c);
                        b._getVip(a, function (c) {
                            lib.ipad ? b._loadHtml5video(c) : (lib.$("#" + a.wrapper).html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u6682\u65f6\u4e0d\u652f\u6301\u60a8\u7684\u8bbe\u5907\u89c2\u770b\u3002"), lib.$("#" + a.wrapper).css("color",
                                "#fff"), lib.$("#" + a.wrapper).css("font-size", "16px"))
                        })
                    }) : b._getQiyi(a, function (c) {
                        Object.extend(window.info.ipad, c);
                        lib.ipad ? b._streamSelect(c, f, function (a) {
                            var d = 2;
                            if (c.mtl && c.mtl.length > 0)for (var e = 0, f = c.mtl.length; e < f; e++)if (c.mtl[e].m3u == a) {
                                d = c.mtl[e].vd;
                                break
                            }
                            b._loadHtml5video({url:a, bits:d})
                        }) : b._getMp4(c, a, function (a) {
                            b._loadHtml5video({url:a.l})
                        })
                    }))
                }, onError:function () {
                    lib.$("#" + a.wrapper).html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u6682\u65f6\u4e0d\u652f\u6301\u60a8\u7684\u8bbe\u5907\u89c2\u770b\u3002");
                    lib.$("#" + a.wrapper).css("color", "#fff");
                    lib.$("#" + a.wrapper).css("font-size", "16px")
                }})
        }, onError:function (b) {
            b && b.code == "Q00201" ? lib.$("#" + a.wrapper).html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u56e0\u7248\u6743\u65b9\u7684\u8981\u6c42\uff0c\u6682\u65f6\u53ea\u652f\u6301\u5728PC\u4e0a\u64ad\u653e\u3002") : lib.$("#" + a.wrapper).html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u6682\u65f6\u4e0d\u652f\u6301\u60a8\u7684\u8bbe\u5907\u89c2\u770b\u3002");
            lib.$("#" + a.wrapper).css("color", "#fff");
            lib.$("#" +
                a.wrapper).css("font-size", "16px")
        }})
    }, _renderVideo:function (a) {
        a.wrapper = a.wrapper || "flashbox";
        var b = [];
        b.push('<div id="j-html5video-warrper" style="background-color:#000000;position:relative;">');
        b.push(['<div data-ctrl="playbar-warpper" class="ctrl-layer" style="display:none;position:absolute;width:' + a.width + "px;height:" + (a.height - 53) + 'px;">', '<div data-layer="warpper" class="ctrl-layerhalf"><div data-layer="play" class="layer-btn"><a href="#" data-ctrl="play" class="ctrlbigplay"></a></div><div data-layer="load" class="layer-load" style="display:none;"><img src="http://www.qiyipic.com/common/images/load.gif" />\u6b63\u5728\u52a0\u8f7d...</div></div></div>'].join(""));
        b.push('<video id="video" width="' + a.width + '" height="' + a.height + '" controls="controls" x-webkit-airplay="allow"');
        typeof a.flashVars != "undefined" && a.flashVars.match(/\&flvPic=(.*?)\&/g) && b.push("poster = " + RegExp.$1);
        b.push(">");
        b.push('<source src="" type="video/mp4"/>');
        b.push("</video>");
        b.push('<div data-ctrl="ctrlbar-warpper" class="video-controlbox clearfix" style="display:none;"><div class="ctrl-top"></div><div class="ctrl-bot"><div class="ctrl-m"><div class="ctrl-c"><div class="ctrl-scheduleBox" data-ctrl="scroll-track"><div class="ctrl-scrollbg"></div><div class="ctrl-scrollbtn" data-ctrl="scroll-thumb" style="width:0;"><span class="ctrl-circle" data-ctrl="scroll-corner"></span></div></div></div></div><div class="ctrl-l"><div class="ctrl-btn"><a class="ctrlplay" href="#" data-btn="ctrlbtn"></a></div><div class="ctrl-split"></div><div class="ctrl-time" data-text="current">00:00:00</div></div><div class="ctrl-r"><div class="ctrl-btn"><a class="ctrlscreen" href="#" data-btn="fullscreen"></a></div><div class="ctrl-time" data-text="duration">00:00:00</div></div></div></div>');
        b.push("</div>");
        lib.$("#" + a.wrapper) && lib.$("#" + a.wrapper).html(b.join(""))
    }, _loadHtml5video:function (a) {
        var b = lib.$("#video");
        a.bits && b.attr("bits", a.bits);
        b[0].src = a.url;
        b && (b[0].load(), lib.action.html5VV(), info.ipad && info.ipad.logo == 1 && this._createWatermark())
    }, _createWatermark:function () {
        var a = lib.$("#video"), b = lib.Element.create("div");
        b.css("width", "91");
        b.css("height", "22");
        b.css("position", "absolute");
        b.css("zIndex", "100");
        b.css("overflow", "hidden");
        b.pos({top:a.box().top + 80, left:a.box().right -
            91 - 20});
        b.html('<img src="http://www.qiyipic.com/common/fix/ipadwatermark.png"/>');
        lib.$(document.body).append(b)
    }, _getQiyi:function (a, b) {
        a.wrapper = a.wrapper || "flashbox";
        var c = this._getVid(a), d = this._getTvId(a);
        lib.kit.util.jsLoad.request("http://cache.video.qiyi.com/m/", {CACHE:{tvId:d, vid:c, varname:"ipadUrl"}, onSuccess:function (a) {
            b(a)
        }, onError:function (b) {
            if (b && b.code == "Q00201")lib.$("#" + a.wrapper).html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u56e0\u7248\u6743\u65b9\u7684\u8981\u6c42\uff0c\u6682\u65f6\u53ea\u652f\u6301\u5728PC\u4e0a\u64ad\u653e\u3002");
            else if (b && b.code == "Q00202")var c = setTimeout(function () {
                clearTimeout(c);
                lib._PAGE_EVENT.handlers.videoUnder ? lib._PAGE_EVENT.fire({type:"videoUnder", target:{data:{cid:b.data.categoryId, container:lib.$("#" + a.wrapper)}}}) : c = setTimeout(arguments.callee, 100)
            }, 100); else lib.$("#" + a.wrapper).html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u6682\u65f6\u4e0d\u652f\u6301\u60a8\u7684\u8bbe\u5907\u89c2\u770b\u3002");
            lib.$("#" + a.wrapper).css("color", "#fff");
            lib.$("#" + a.wrapper).css("font-size", "16px")
        }})
    }, _getVip:function (a, b) {
        a.wrapper = a.wrapper || "flashbox";
        var c = info.albumId, d = this._getVid(a), e = (new Date).getTime() + "", f = parseInt(e.substring(0, 2)) * parseInt(e.substring(e.length - 3)) + 100;
        lib.kit.util.jsLoad.request(authUrl, {GET:{aid:c, platform:"b85da1cf3ae44351", cid:"afbe8fd3d73448c9", vid:d, ut:e, utt:f, v:lib.md5([c, "afbe8fd3d73448c9", d, e, f, "2385461878"].join("_")), cb:"cb_" + Math.floor(Math.random() * 2147483648).toString(36)}, onSuccess:function (a) {
            b({url:"http://cache.vip.qiyi.com/m/u/" + d + "/afbe8fd3d73448c9/" + a.t + "/" + a.pt +
                ".m3u8"})
        }, onError:function () {
        }})
    }, _getVid:function (a) {
        if (a.flashVars && a.flashVars.indexOf("vid=") !== -1)var a = a.flashVars, b = a.indexOf("vid=") + 4, c = a.indexOf("&", b), a = a.substring(b, c) || info.videoId; else a = info.videoId;
        return a
    }, _getTvId:function (a) {
        var b = "";
        return b = a.flashVars && a.flashVars.indexOf("tvId=") !== -1 ? a.flashVars.match(/tvId=(.*?)&/)[1] : info.tvId
    }, _getMp4:function (a, b, c) {
        a.mp4Url ? lib.kit.util.jsLoad.request(a.mp4Url, {CACHE:{varname:"videoUrl"}, onSuccess:c, onError:function () {
            lib.$("#" + b.wrapper).html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u6682\u65f6\u4e0d\u652f\u6301\u60a8\u7684\u8bbe\u5907\u89c2\u770b\u3002");
            lib.$("#" + b.wrapper).css("color", "#fff");
            lib.$("#" + b.wrapper).css("font-size", "16px")
        }}) : (lib.$("#" + b.wrapper).html("\u5bf9\u4e0d\u8d77\uff0c\u6b64\u89c6\u9891\u6682\u65f6\u4e0d\u652f\u6301\u60a8\u7684\u8bbe\u5907\u89c2\u770b\u3002"), lib.$("#" + b.wrapper).css("color", "#fff"), lib.$("#" + b.wrapper).css("font-size", "16px"))
    }, _streamSelect:function (a, b, c) {
        var d = b.s + "", e, f, g;
        a.mtl.each(function (a) {
            switch (a.vd) {
                case 1:
                    f = a.m3u;
                    break;
                case 2:
                    e = a.m3u;
                    break;
                case 96:
                    g = a.m3u
            }
        });
        e = e || a.url;
        a = b.l.replace("v.ts", "speed_test.png");
        switch (d) {
            case "2":
                this._speedTest(a, function (a) {
                    a > 80 ? c(f || e) : c(g || f || e)
                });
                break;
            case "3":
            case "4":
                c(g || f || e);
                break;
            default:
                this._speedTest(a, function (a) {
                    a > 120 ? c(e) : a < 80 ? c(g || f || e) : c(f || e)
                })
        }
    }, _speedTest:function (a, b) {
        var c, d = 0, e;
        if (a) {
            var f = new Image;
            f.onload = function () {
                f.onload = null;
                e = new Date * 1 - e;
                if (!d) {
                    clearTimeout(c);
                    var a = parseInt(300 / (e / 1E3));
                    lib.kit.slog.log({flag:"html5speedstatsfrmsk", speed:a}, "http://msg.video.qiyi.com/tmpstats.gif");
                    b(a)
                }
            };
            e = new Date * 1;
            c = setTimeout(function () {
                d = 1;
                lib.kit.slog.log({flag:"html5speedstatsfrmsk",
                    speed:"timeout"}, "http://msg.video.qiyi.com/tmpstats.gif");
                b(1);
                clearTimeout(c)
            }, 5E3);
            f.src = a + "?r=" + Math.random()
        } else b(1E3)
    }, detectFlashVer:function (a, b, c) {
        var d = this.getSwfVer(), e, b = b || "0", c = c || "0";
        if (d == -1)return!1; else if (d != 0) {
            lib.IE && isWin && !lib.OPERA && (d = d.split(" "), d = d[1]);
            e = d.split(".");
            var d = parseFloat(e[0]), f = parseFloat(e[1]);
            e = e[2];
            if (d > parseFloat(a))return!0; else if (d == parseFloat(a))if (f > parseFloat(b))return!0; else if (f == parseFloat(b) && e >= parseFloat(c))return!0;
            return!1
        }
    }, render:function () {
        var a =
            this.AC_GetArgs(arguments, "");
        a && a.embedAttrs && a.embedAttrs.src && a.embedAttrs.src.match(/qiyi_n_player\.swf$/) && parseInt(Math.random() * 100) > 90 && lib.kit.slog.log({flag:"hasplayer"});
        if (a.embedAttrs.ipad && (lib.ipad || lib.noFlashAndroid))return this.html5video(a.embedAttrs);
        if (a.embedAttrs.iPadLive)return this._renderHtml5Live(a.embedAttrs);
        if (!this.detectFlashVer(10, 0, 0) && a.embedAttrs.hint)return isWin ? lib.IE ? document.write("\u4f60\u9700\u8981\u5347\u7ea7FLASH\u64ad\u653e\u5668\u7248\u672c\u81f310.0+,\u8bf7<a style='color:#6C6C6C;text-decoration:underline;' href='http://www.adobe.com/go/getflash' target='_blank'>\u4e0b\u8f7d</a>") :
            document.write("\u4f60\u9700\u8981\u5347\u7ea7FLASH\u64ad\u653e\u5668\u7248\u672c\u81f310.0+,\u8bf7<a href='http://www.adobe.com/go/getflash' style='color:#6C6C6C;text-decoration:underline;' target='_blank'>\u4e0b\u8f7d</a>") : document.write("\u4f60\u9700\u8981\u5347\u7ea7FLASH\u64ad\u653e\u5668\u7248\u672c\u81f310.0+,\u8bf7<a href='http://get.adobe.com/flashplayer/otherversions/' style='color:#6C6C6C;text-decoration:underline;' target='_blank'>\u4e0b\u8f7d</a>"), !1;
        if (a.isPopup != "true")lib.$(window).on("beforeunload",
            function () {
                var b = lib.$("#" + a.objAttrs.id);
                if (b && b[0].windowClose)try {
                    b[0].windowClose()
                } catch (c) {
                }
            });
        return this.AC_Generateobj(a.objAttrs, a.params, a.embedAttrs, a.isStr, a.nocache)
    }, _renderHtml5Live:function (a) {
        a = a || {};
        this._renderVideo(a);
        var b = this;
        lib.kit.util.jsLoad.request(a.src || "http://m3u8.live.video.qiyi.com/tslive/CCTV-1/CCTV-1.flv", {CACHE:{varname:"videoUrl"}, onSuccess:function (a) {
            a = a.l.replace(/[^\.]*$/, "m3u8");
            b._loadHtml5video({url:a})
        }})
    }, _playersID:[], renderPlayer:function () {
        this.render.apply(this,
            arguments);
        var a = this.AC_GetArgs(arguments, "").objAttrs.id, b = document.getElementById(a);
        (b && b.play || b && b.playQiyiVideo) && this._players.push(a)
    }, getPlayersID:function () {
        return this._playersID
    }, AC_GetArgs:function (a) {
        for (var b = {embedAttrs:{}, params:{}, objAttrs:{}}, c = 0; c < a.length; c += 2)switch (a[c].toLowerCase()) {
            case "src":
                b.embedAttrs.src = a[c + 1];
                b.params.movie = a[c + 1];
                break;
            case "onafterupdate":
            case "onbeforeupdate":
            case "onblur":
            case "oncellchange":
            case "onclick":
            case "ondblclick":
            case "ondrag":
            case "ondragend":
            case "ondragenter":
            case "ondragleave":
            case "ondragover":
            case "ondrop":
            case "onfinish":
            case "onfocus":
            case "onhelp":
            case "onmousedown":
            case "onmouseup":
            case "onmouseover":
            case "onmousemove":
            case "onmouseout":
            case "onkeypress":
            case "onkeydown":
            case "onkeyup":
            case "onload":
            case "onlosecapture":
            case "onpropertychange":
            case "onreadystatechange":
            case "onrowsdelete":
            case "onrowenter":
            case "onrowexit":
            case "onrowsinserted":
            case "onstart":
            case "onscroll":
            case "onbeforeeditfocus":
            case "onactivate":
            case "onbeforedeactivate":
            case "ondeactivate":
            case "type":
            case "id":
                b.objAttrs[a[c]] =
                    a[c + 1];
                b.embedAttrs[a[c]] = a[c + 1];
                break;
            case "width":
            case "height":
            case "align":
            case "vspace":
            case "hspace":
            case "class":
            case "title":
            case "accesskey":
            case "tabindex":
                b.embedAttrs[a[c]] = b.objAttrs[a[c]] = a[c + 1];
                break;
            case "isstr":
                b.isStr = a[c + 1];
                break;
            case "ispopup":
                b.isPopup = a[c + 1];
                break;
            case "nocache":
                b.nocache = a[c + 1];
                break;
            default:
                b.embedAttrs[a[c]] = b.params[a[c]] = a[c + 1]
        }
        return b
    }, AC_Generateobj:function (a, b, c, d, e) {
        var f = [];
        if (lib.IE && isWin && !lib.OPERA) {
            f.push('<object codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0"');
            f.push('classid ="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"');
            for (var g in a)f.push(g + '="' + a[g] + '" ');
            f.push(">");
            f.push('<param name="quality" value="high" /> ');
            f.push('<param name="loop" value="true" /> ');
            f.push('<param name="play" value="true" /> ');
            f.push('<param name="DeviceFont" value="false" /> ');
            f.push('<param name="allowFullScreen" value="true" /> ');
            f.push('<param name="menu" value="true" /> ');
            for (g in b) {
                if ((lib.TT || lib.$360 || lib.Maxthon) && g.match(/src|movie/))b[g] += !e ? "?" + Math.random() :
                    "";
                f.push('<param name="' + g + '" value="' + b[g] + '" /> ')
            }
            f.push('<param name="allowScriptAccess" value="always" /> ');
            f.push("</object>")
        } else {
            f.push('<embed pluginspage="http://www.macromedia.com/go/getflashplayer" ');
            lib.winXP && lib.ff && f.push('style="outline: none;" ');
            f.push('loop = "true"');
            f.push('play = "true"');
            f.push('quality = "hight"');
            f.push('scale = "showall"');
            f.push('DeviceFont= "false"');
            f.push('allowFullScreen="true"');
            f.push('menu="true"');
            f.push('type="application/x-shockwave-flash"');
            for (g in c)f.push(g + '="' + c[g] + '" ');
            f.push('allowScriptAccess="always"');
            f.push("> </embed>")
        }
        if (d)return f.join("");
        document.write(f.join(""))
    }};
Object.extend(window, {GetSwfVer:video.getSwfVer.bind(video), AC_FL_RunContent:video.render.bind(video), DetectFlashVer:video.detectFlashVer.bind(video), AC_Generateobj:video.AC_Generateobj.bind(video)});
window.videoPlayStart = function () {
    lib._PAGE_EVENT && lib._PAGE_EVENT.fire({type:"videoPlayStart", target:arguments})
};
window.videoPlayEnd = function () {
    lib._PAGE_EVENT && lib._PAGE_EVENT.fire({type:"videoPlayEnd", target:arguments})
};
if (lib._PAGE_EVENT)lib._PAGE_EVENT.on("videoPlayStart", function () {
    var a = document.getElementById("flash");
    if (a) {
        if (a.setVisits) {
            var b = lib.cookie.get("QC008"), b = b.split(".");
            a.setVisits([b[1], ".", b[b.length - 1]].join(""))
        }
        a.setNextVideoId && (new lib.kit.Monitor(function () {
            if (!lib.action.customPlay || !lib.action.customPlay.nextInfo.initNextVideoEnd)return!1;
            try {
                lib.action.customPlay.nextInfo.vid && a.setNextVideoId(lib.action.customPlay.nextInfo.vid)
            } catch (b) {
            }
            lib.kit.FlashCall({flashID:"flash", functionName:"notice",
                parameter:"{type:'setNextInfo',data:{vid:'" + lib.action.customPlay.nextInfo.vid + "',videoName:'" + lib.action.customPlay.nextInfo.videoName + "'}}"})
        }, {maxTime:3E4})).start()
    }
});
lib._PAGE_EVENT.on("swf_download", function (a) {
    a = a.data || {};
    if (a.albumId && a.videoName && a.isCharge && a.tvid)a = "qisu://albumId=" + a.albumId + ";tvname=" + encodeURIComponent(encodeURIComponent(a.videoName)) + ";isCharge=" + a.isCharge + ";tvid=" + a.tvid + ";offline=true", window.location.href = a
});
lib.swf.playerisready = !1;
lib._PAGE_EVENT.on("swf_playerStateChange", function (a) {
    a = a || {};
    a.data = a.data || {};
    var b = a.data.state || "";
    b.toLocaleLowerCase() == "startplay" && lib.$("#flash") && (a = lib.cookie.get("QC008"), a = a.split("."), lib.kit.FlashCall({flashID:"flash", functionName:"setQiyiVisits", parameter:[a[1], ".", a[a.length - 1]].join("")}), (a = (a = lib.$("#flash")[0].getQiyiVideoInfo()) ? JSON.parse(a.replace(/\r/g, "").replace(/\n/g, "")) : "") && function () {
        lib._PAGE_EVENT.fire({type:"videoPlayStart", target:arguments})
    }(a.vid, a.an, a.tvid));
    if (b.toLocaleLowerCase() == "ready")lib.swf.playerisready = !0;
    b.toLocaleLowerCase() == "playing" && lib._PAGE_EVENT.fire({type:"player_playing", data:a});
    b.toLocaleLowerCase() == "stoped" && lib._PAGE_EVENT.fire({type:"player_stoped", data:a});
    b.toLocaleLowerCase() == "pause" && lib._PAGE_EVENT.fire({type:"player_pause", data:a})
});
lib.cookie = lib.cookie || {};
lib.cookie.remove = function (a, b, c) {
    document.cookie = a + "=;expires=Fri, 31 Dec 1999 23:59:59 GMT;path=" + (b || "/") + ";domain=" + c
};
lib.cookie.get = function (a) {
    a = a.replace(/([\.\[\]\$])/g, "\\$1");
    return(a = (document.cookie + ";").match(RegExp(a + "=([^;]*)?;", "i"))) ? a.length > 1 && a[1] == "deleted" ? "" : decodeURIComponent(a[1]) || "" : ""
};
lib.cookie.set = function (a, b, c, d, e, f) {
    var g = [];
    g.push(a + "=" + encodeURIComponent(b));
    c && (a = new Date, c = a.getTime() + c * 36E5, a.setTime(c), g.push("expires=" + a.toGMTString()));
    d && g.push("path=" + d);
    e && g.push("domain=" + e);
    f && g.push(f);
    document.cookie = g.join(";")
};
(function (a, b) {
    function c(a, c) {
        var g = Object.prototype.toString, j = /((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^[\]]*\]|['"][^'"]*['"]|[^[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?/g, h = [], k = {ID:/#((?:[\w\u00c0-\uFFFF\-]|\\.)+)/, ATTR:/\[\s*((?:[\w\u00c0-\uFFFF\-]|\\.)+)\s*(?:(\S?=)\s*(['"]*)(.*?)\3|)\s*\]/}, l = {attr:function (a, b) {
            for (var c = [], d = a.match(k.ATTR), e = a.slice(0, a.indexOf("[")), e = b.getElementsByTagName(e), f = 0, g = e.length; f < g; f++)e[f].getAttribute(d[1]) && (e[f].getAttribute(d[1]) == d[4] || d[4] ==
                "") && c.push(e[f]);
            return c
        }, filter:function (a, b) {
            for (var c = [], d = 0; d < a.length; d++)b.contains(a[d]) && c.push(a[d]);
            return c.length == 0 ? null : c
        }};
        b.querySelectorAll ? (h = b.querySelectorAll(a), c && (h = l.filter(h, lib.$(c)))) : (j = a.match(j), h = j.length == 1 ? l.attr(a, c || b) : l.attr(j[1], b.getElementById(j[0].slice(1))));
        return g.call(h) == "[object Array]" ? h : d(h)
    }

    function d(a) {
        if (a) {
            for (var b = [], c = a.length, d = 0; d < c; d++)b[d] = a[d];
            return b
        }
    }

    a.lib = a.lib || {};
    lib.find = function (a, d) {
        if (typeof a == "object") {
            if (a._els)return[a._els[0]];
            if (a.getAttribute)return[a];
            return null
        }
        var g = "*", j = {}, d = d || b.body, j = a.match(/(#[\w-_]+)?([\w-_*]+)?(\.[\w-_]+)?(\s+.+)?(\[\w(=\w)?])?/i);
        if (!j)return null;
        var j = {id:j[1], tag:j[2], cls:j[3], child:j[4] ? j[4].replace(/(^[\s\n]+|[\s\n]+$)/g, "") : ""}, a = a.replace(/(^[\s\n]+|[\s\n]+$)/g, ""), h = a.match(/\[\s*((?:[\w\u00c0-\uFFFF\-]|\\.)+)\s*(?:(\S?=)\s*(['"]*)(.*?)\3|)\s*\]/);
        if (h && h.length > 0)return c(a, d);
        if (j.child) {
            var k = lib.find(a.split(" ")[0], d), g = [];
            if (k.length)for (var h = 0, l = k.length; h < l; h++) {
                var o = lib.find(j.child,
                    k[h]);
                if (o.length)for (var m = 0, p = o.length; m < p; m++)g.push(o[m]);
                o.innerHTML && g.push(o)
            }
            k.innerHTML && g.push(k);
            return g.length > 0 ? g : null
        }
        if (j.id)return j.child ? lib.find(child, lib.find(j.id)) : (j = b.getElementById(j.id.replace("#", ""))) ? [j] : null;
        if (j.tag && (g = j.tag, !j.cls))if (j = d.getElementsByTagName(g), g = [], j) {
            m = 0;
            for (p = j.length; m < p; m++)g.push(j[m]);
            return g
        } else return null;
        if (j.cls) {
            m = lib.find(g, d);
            g = [];
            if (m) {
                j = RegExp("(^| )" + j.cls.replace(".", "") + "( |$)");
                h = 0;
                for (l = m.length; h < l; h++)m[h].className.match(j) &&
                g.push(m[h]);
                return g
            }
            return null
        }
    }
})(window, document);
(function () {
    var a = Array.prototype;
    lib.each({each:function (a) {
        this.forEach(a);
        return this
    }, include:function (a) {
        return this.index(a) != -1
    }, index:function (a) {
        for (var c = 0, d = this.length; c < d; c++)if (this[c] == a)return c;
        return-1
    }, unique:function () {
        for (var a = 0; a < this.length; a++)for (var c = this[a], d = this.length - 1; d > a; d--)this[d] == c && this.splice(d, 1);
        return this
    }, del:function (a) {
        a = this.index(a);
        a >= 0 && a < this.length && this.splice(a, 1);
        return this
    }, insert:function (a, c) {
        return this.slice(0, a).concat(c, this.slice(a))
    },
        remove:function (a) {
            var c = this.slice(0, a), a = this.slice(a + 1);
            return c.concat(a)
        }, indexOf:function (a, c) {
            c || (c = 0);
            var d = this.length;
            for (c < 0 && (c = d + c); c < d; c++)if (this[c] === a)return c;
            return-1
        }, lastIndexOf:function (a, c) {
            var c = isNaN(c) ? this.length : (c < 0 ? this.length + c : c) + 1, d = this.slice(0, c).reverse().indexOf(a);
            return d < 0 ? d : c - d - 1
        }, every:function (a, c) {
            var d = this.length;
            if (typeof a != "function")throw new TypeError;
            for (var e = 0; e < d; e++)if (e in this && !a.call(c, this[e], e, this))return!1;
            return!0
        }, filter:function (a, c) {
            var d = this.length;
            if (typeof a != "function")throw new TypeError;
            for (var e = [], f = 0; f < d; f++)if (f in this) {
                var g = this[f];
                a.call(c, g, f, this) && e.push(g)
            }
            return e
        }, forEach:function (a) {
            var c = this.length;
            if (typeof a != "function")throw new TypeError;
            for (var d = 0; d < c; d++)d in this && a(this[d], d)
        }, map:function (a, c) {
            var d = this.length;
            if (typeof a != "function")throw new TypeError;
            for (var e = Array(d), f = 0; f < d; f++)f in this && (e[f] = a.call(c, this[f], f, this));
            return e
        }, some:function (a, c) {
            var d = this.length;
            if (typeof a != "function")throw new TypeError;
            for (var e = 0; e < d; e++)if (e in this && a.call(c, this[e], e, this))return!0;
            return!1
        }, last:function () {
            var a = this.length;
            return a > 0 ? this[a - 1] : null
        }}, function (b, c) {
        lib.isNative(a[c]) || (a[c] = b)
    })
})(window, document);
(function () {
    var a = Object.prototype.hasOwnProperty;
    lib.each({each:function (b, c, d) {
        if (typeof c != "function")throw new TypeError;
        for (var e in b)a.call(b, e) && c.call(d, b[e], e, b)
    }, subset:function (a, c) {
        for (var d = {}, e = 0, f = c.length; e < f; e++) {
            var g = c[e];
            g in a && (d[g] = a[g])
        }
        return d
    }, map:function (b, c, d) {
        if (typeof c != "function")throw new TypeError;
        var e = {}, f;
        for (f in b)a.call(b, f) && (e[f] = c.call(d, b[f], f, b));
        return e
    }, filter:function (b, c, d) {
        if (typeof c != "function")throw new TypeError;
        var e = {}, f;
        for (f in b) {
            var g =
                b[f];
            a.call(b, f) && c.call(d, g, f, b) && (e[f] = g)
        }
        return e
    }, every:function (b, c, d) {
        if (typeof c != "function")throw new TypeError;
        for (var e in b)if (a.call(b, e) && !c.call(d, b[e], e))return!1;
        return!0
    }, some:function (b, c, d) {
        if (typeof c != "function")throw new TypeError;
        for (var e in b)if (a.call(b, e) && c.call(d, b[e], e))return!0;
        return!1
    }, keys:function (b) {
        var c = [], d;
        for (d in b)a.call(b, d) && c.push(d);
        return c
    }, values:function (b) {
        var c = [], d;
        for (d in b)a.call(b, d) && c.push(b[d]);
        return c
    }, getLength:function (a) {
        return Object.keys(a).length
    },
        keyOf:function (b, c) {
            for (var d in b)if (a.call(b, d) && b[d] === c)return d;
            return null
        }, contains:function (a, c) {
            return Object.keyOf(a, c) != null
        }}, function (a, c) {
        lib.isNative(Object[c]) || (Object[c] = a)
    })
})(window, document);
lib.box = lib.box || {version:"1.0.0", toString:function () {
    return"[Object lib.box(version " + this.version + ")]"
}};
Object.extend(lib.box, {getDocumentHeight:function (a) {
    var a = a || window, b = a.document;
    return Math.max(b.compatMode != "CSS1Compat" ? b.body.scrollHeight : b.documentElement.scrollHeight, this.getViewportHeight(a))
}, getDocumentWidth:function (a) {
    var a = a || window, b = a.document;
    return Math.max(b.compatMode != "CSS1Compat" ? b.body.scrollWidth : b.documentElement.scrollWidth, this.getViewportWidth(a))
}, getViewportHeight:function (a) {
    var a = a || window, b = a.document, c = b.documentElement;
    return a.innerHeight || c && c.clientHeight + (c.style.borderTopWidth ==
        "" ? 0 : c.style.borderTopWidth) + (c.style.borderBottomWidth == "" ? 0 : c.style.borderBottomWidth) || b.body.clientHeight
}, getViewportWidth:function (a) {
    var a = a || window, b = a.document, c = b.documentElement;
    return a.innerWidth || c && c.clientWidth + (c.style.borderLeftWidth == "" ? 0 : c.style.borderLeftWidth) + (c.style.borderRightWidth == "" ? 0 : c.style.borderRightWidth) || b.body.clientWidth
}, getPageScrollTop:function (a) {
    var a = a || window, b = a.document, c = b.documentElement;
    return a.pageYOffset || c && c.scrollTop || b.body.scrollTop
}, getPageScrollLeft:function (a) {
    var a =
        a || window, b = a.document, c = b.documentElement;
    return a.pageXOffset || c && c.scrollLeft || b.body.scrollLeft
}, getPosition:function (a) {
    try {
        var b = a.getBoundingClientRect()
    } catch (c) {
        return lib.log("getPosition failed."), {top:9999, left:9999}
    }
    var d = a.ownerDocument, a = d.body, d = d.documentElement;
    return{top:b.top + (self.pageYOffset || d.scrollTop || a.scrollTop) - (d.clientTop || a.clientTop || 0), left:b.left + (self.pageXOffset || d.scrollLeft || a.scrollLeft) - (d.clientLeft || a.clientLeft || 0)}
}});
Object.extend(Date.prototype, {format:function (a) {
    var b = this.getFullYear(), c = this.getMonth() + 1, c = c > 9 ? c : "0" + c, d = this.getDate() > 9 ? this.getDate() : "0" + this.getDate(), e = this.getHours() > 9 ? this.getHours() : "0" + this.getHours(), f = this.getMinutes() > 9 ? this.getMinutes() : "0" + this.getMinutes(), g = this.getSeconds() > 9 ? this.getSeconds() : "0" + this.getSeconds();
    return a.replace(/(y{2,4})/, b).replace("MM", c).replace("dd", d).replace("hh", e).replace("mm", f).replace("ss", g)
}});
lib.date = {};
Object.extend(lib.date, {getHours:function (a) {
    var b = a > 3600 ? Math.floor(a / 3600) : 0, c = a % 3600 > 60 ? Math.floor(a % 3600 / 60) : 0, c = c >= 10 ? c : "0" + c, a = c > 0 ? a % 3600 % 60 : a, a = a >= 10 ? a : "0" + a;
    return b > 0 ? (b > 9 ? b : "0" + b) + ":" + c + ":" + a : c + ":" + a
}, formatTime:function (a, b) {
    var a = parseInt(a), c = Math.floor(a / 3600), d = Math.floor((a - c * 3600) / 60), e = a - c * 3600 - d * 60, f = 0;
    return b.indexOf("d") == 0 ? (f = Math.floor(c / 24), c %= 24, {d:f, h:c, m:d, s:e}) : {h:c, m:d, s:e}
}, isLeap:function (a) {
    return a % 400 ? a % 100 ? a % 4 ? !1 : !0 : !1 : !0
}, toSecond:function (a) {
    for (var a = a.split(":"),
             b = 0, c = a.length, d = 0; d < c; d++)b += Math.pow(60, c - 1 - d) * parseInt(a[d]);
    return b
}});
$reg("lib.net", function () {
    lib.net.Ajax = {request:function (a, b) {
        var c = this._getTransport(), b = Object.extend({method:"get", async:!0}, b || {});
        if (b.method == "get" && typeof b.data == "string" && b.data.length > 0)a += (a.indexOf("?") == -1 ? "?" : "&") + b.data, b.data = null;
        c.open(b.method, a, b.async);
        b.method == "post" && c.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=UTF-8");
        c.onreadystatechange = this._onStateChange.bind(this, c, a, b);
        c.send(b.data || null);
        return c
    }, text:function (a, b) {
        b.format = "text";
        return this.request(a, b)
    }, json:function (a, b) {
        b.format = "json";
        return this.request(a, b)
    }, xml:function (a, b) {
        b.format = "xml";
        return this.request(a, b)
    }, _getTransport:function () {
        if (window.XMLHttpRequest)return new XMLHttpRequest; else try {
            return new ActiveXObject("Msxml2.XMLHTTP")
        } catch (a) {
            try {
                return new ActiveXObject("Microsoft.XMLHTTP")
            } catch (b) {
                return!1
            }
        }
    }, _onStateChange:function (a, b, c) {
        if (a.readyState == 4)if (a.onreadystatechange = function () {
        }, b = a.status, typeof b == "number" && b >= 200 && b < 300) {
            if (typeof c.success ==
                "function") {
                b = a;
                if (typeof c.format == "string")switch (c.format) {
                    case "text":
                        b = a.responseText;
                        break;
                    case "json":
                        try {
                            b = eval("(" + a.responseText + ")")
                        } catch (d) {
                            window.console && console.error && console.error(d)
                        }
                        break;
                    case "xml":
                        b = a.responseXML
                }
                c.success(b)
            }
        } else if (!window.closed && typeof c.failure == "function") {
            b = {status:a.status, statusText:a.statusText};
            if (a.readyState == 4 && (a.status == 0 || a.status == 12030))b.status = -1;
            c.failure(b)
        }
    }};
    lib.net.loadCSS = function (a) {
        if (a) {
            var b = document.getElementsByTagName("head"),
                c = document.createElement("link");
            c.setAttribute("rel", "stylesheet");
            c.setAttribute("type", "text/css");
            c.setAttribute("href", a);
            b && b[0].appendChild(c)
        }
    };
    lib.net.SUCCESS = "A00000";
    lib.net.jsLoad = function (a) {
        var b = Object.extend({url:"", onComplete:function () {
        }, onError:function () {
        }, charset:!1, doc:document, timeout:1E4}, a), c = !1, d = !1, e = b.doc.createElement("script");
        e.language = "javascript";
        e.type = "text/javascript";
        b.charset && (e.charset = b.charset);
        e.onload = e.onreadystatechange = function () {
            if (!d && (!e.readyState ||
                "loaded" == e.readyState || "complete" == e.readyState))c = !0, b.onComplete(), e.onload = e.onreadystatechange = null
        };
        setTimeout(function () {
            c || (d = !0, b.onError())
        }, b.timeout);
        e.src = b.url;
        document.getElementsByTagName("head")[0].appendChild(e)
    };
    lib.getPath = function (a) {
        var b = {js:lib.PROJECT_BASE_PATH || "http://static.qiyi.com/js/qitan/"};
        if (!b.js)b.js = "";
        var c = b.js.substr(b.js.length - 1, 1), a = a.trim().toLowerCase();
        return b.js + (c == "/" ? "" : "/") + a.split(".").join("/") + ".js"
    };
    lib._loadQueue = {_queue:[], enqueue:function (a) {
        this._queue.push(a)
    },
        dequeue:function () {
            return this._queue.splice(0, 1)
        }, get:function () {
            return this._queue[0]
        }, isEmpty:function () {
            return this._queue.length === 0
        }};
    lib._loadStack = {_stack:[], _loaded:{}, _running:!1, start:function () {
        this._running || this.pull()
    }, push:function (a) {
        this._stack.push(a)
    }, pull:function () {
        this._running = !0;
        if (this._stack.length == 0) {
            lib._loadQueue.dequeue();
            if (lib._loadQueue.isEmpty()) {
                this._running = !1;
                return
            }
            this.push(lib._loadQueue.get())
        }
        var a = this._stack[this._stack.length - 1];
        if (a.scripts.length ==
            0) {
            if (a.fn)try {
                a.fn()
            } catch (b) {
            }
            this._stack.splice(this._stack.length - 1, 1);
            this.pull()
        } else if (a = a.scripts.shift(), this._loaded[a.toLowerCase()])this.pull(); else {
            this._loaded[a.toLowerCase()] = !0;
            var a = lib.getPath(a), c = this;
            lib.net.jsLoad({url:a, onComplete:function () {
                c.pull()
            }, onError:function () {
            }})
        }
    }};
    lib.require = function () {
        var a, b, c;
        arguments.length == 2 ? (a = arguments[0], b = arguments[1]) : arguments.length == 3 ? (a = arguments[0], c = arguments[1], b = arguments[2]) : a = arguments[0];
        b = b || function () {
        };
        a = {scripts:a ?
            a.split(",") : [], fn:b};
        c ? (lib._loadQueue.isEmpty() && lib._loadStack.push(a), lib._loadQueue.enqueue(a)) : lib._loadStack.push(a);
        lib._loadStack.start()
    }
});
lib.reg = $reg;
window.Ijax = lib.net.Ijax = {arrTaskLists:[], createLoadingIframe:function () {
    if (this.loadFrames != null)return!1;
    var a = "loadingIframe_thread" + Math.ceil(Math.random() * 1E4);
    this.loadFrames = a;
    var a = ['<iframe id="' + a + '" name="' + a + '" class="invisible"', ' scrolling="no" src="http://www.qiyi.com/common/crosspost.html" allowTransparency="true" style="display:none;" frameborder="0" ></iframe>'].join(""), b = document.createElement("div");
    b.id = "ijax_iframes";
    b.innerHTML = a;
    document.body.appendChild(b);
    if (document.getElementById(this.loadFrames) !=
        null)loadTimer = null, this.loadingIframe = {container:document.getElementById(this.loadFrames), isBusy:!1}, this.loadByList()
}, isIjaxReady:function () {
    if (typeof this.loadingIframe == "undefined")return!1;
    if (this.loadingIframe.isBusy == !1)return this.loadingIframe.isBusy = !0, this.loadingIframe;
    return!1
}, request:function (a, b) {
    var c = {};
    c.url = a;
    c.option = b || {};
    this.arrTaskLists.push(c);
    this.loadFrames == null ? this.createLoadingIframe() : this.loadByList()
}, loadByList:function () {
    if (this.arrTaskLists.length == 0)return!1;
    var a = this.isIjaxReady();
    if (a == !1)return!1;
    var b = this.arrTaskLists[0], c = this;
    setTimeout(function () {
        c.loadData(b.url, b.option, a)
    }, 10);
    this.arrTaskLists.shift()
}, destory:function () {
    if (!(this.arrTaskLists.length > 0)) {
        document.getElementById(this.loadFrames).callback = null;
        document.body.removeChild(document.getElementById("ijax_iframes"));
        if (document.getElementById("IjaxForm"))document.getElementById("IjaxForm").action = "", document.getElementById("IjaxForm").target = "", document.body.removeChild(document.getElementById("IjaxForm"));
        this.loadFrames = null
    }
}, loadData:function (a, b, c) {
    var d = c.container, e = this, f = "", g = !1, j = !1, h;
    d.callback = function (a) {
        j = !0;
        if (!g) {
            a = typeof a == "string" && /\s*{/.test(a) ? eval("(" + a + ")") : a;
            if (a.code == "A00000" && b.onSuccess)b.onSuccess(a.data); else b.onError(a);
            e.destory();
            c.isBusy = !1;
            e.loadByList()
        }
    };
    isNaN(b.timeout) || setTimeout(function () {
        j || (g = !0, b.onError(), e.destory())
    }, b.timeout);
    if (b.CACHE) {
        var f = a, k;
        for (k in b.CACHE)f += b.CACHE[k] + "/";
        b.spliter === "0" && (f = f.slice(0, -1))
    } else {
        f = new lib.kit.Url(a);
        if (b.GET)for (k in b.GET)f.setParam(k,
            encodeURIComponent(b.GET[k]));
        if (b.POST) {
            a = window.correctArea || {};
            a.ip && a.ip.html();
            document.getElementById("IjaxForm") ? document.getElementById("IjaxForm").innerHTML = "" : (a = document.createElement("form"), document.body.appendChild(a), a.id = "IjaxForm", a.method = "post", a.target = d.id);
            document.getElementById("IjaxForm").action = f;
            for (var l in b.POST)a = document.createElement("input"), a.type = "hidden", a.name = l, a.value = b.POST[l], document.getElementById("IjaxForm").appendChild(a);
            h = setTimeout(function () {
                clearTimeout(h);
                d.readyState == "complete" || !lib.IE ? document.getElementById("IjaxForm").submit() : h = setTimeout(arguments.callee, 100)
            }, 100)
        }
    }
    b.POST || d.contentWindow.location.replace(f)
}};
lib.net.crossDomain = {Request:function (a, b) {
    this._url = a;
    this.option = {prefix:"cb_", charset:"utf-8", queryField:"cb", callbackName:"cb_" + Math.floor(Math.random() * 2147483648).toString(36), timeout:1E4, spliter:"1"};
    Object.extend(this.option, b);
    this._getParams = function () {
        var a = "t=" + (new Date).getTime();
        return this.option.data == "" ? a : this.option.data + "&" + a
    };
    this.get = function () {
        var a = this.option.callbackName, b = this._url + "?" + this.option.queryField + "=" + a + "&" + this._getParams(), e = this;
        lib.net.jsLoad({timeout:this.option.timeout,
            url:b, onComplete:function () {
                if (window[a])try {
                    e.option.success.apply(window, [window[a]])
                } finally {
                    try {
                        delete window[a] || (window[a] = null)
                    } catch (b) {
                    }
                }
            }, onError:function () {
            }})
    };
    this.post = function () {
        var a = this, b = this.option.data;
        b[this.option.queryField] = this.option.callbackName;
        lib.net.Ijax.request(this._url, {onSuccess:function (b) {
            a.option.success.apply(window, [
                {code:"A00000", data:b}
            ])
        }, onError:function (b) {
            a.option.failure.apply(window, [b])
        }, POST:b, timeout:this.option.timeout})
    }
}, request:function (a, b) {
    var c =
        b.method.toLowerCase(), d = new lib.net.crossDomain.Request(a, b);
    c == "get" && d.get();
    c == "post" && d.post()
}, _error:function () {
}};
lib.net.formRequest = {request:function (a, b) {
    this.option = b || {};
    if (lib.$("#order_form"))var c = lib.$("#order_form"); else c = lib.Element.create("form"), c.attr("id", "order_form"), lib.$(document.body).append(c);
    c.attr("action", a);
    c.attr("method", this.option.method || "GET");
    c.attr("target", this.option.target || "_self");
    var d = this.option.param || {}, e;
    for (e in d) {
        var f = lib.$("#" + e);
        if (!f || !c.contains(f))f = lib.Element.create("input"), f.attr("type", "hidden"), f.attr("id", e), f.attr("name", e), c.append(f);
        f.val(d[e])
    }
    c[0].submit()
},
    _error:function () {
    }};
lib.reg("qitan.model.request", function () {
    var a = qitan.model.request;
    qitan.model.SUCCESS = "A00000";
    lib.net.isLogin = a.isLogin = function () {
        return lib.cookie.get("P00002") !== "" && lib.cookie.get("P00002") !== "deleted" && lib.cookie.get("P00003") !== "" && lib.cookie.get("P00003") !== "deleted"
    };
    lib.net.getUserInfo = a.getUserInfo = function () {
        var a = lib.cookie.get("P00002");
        return a == "" ? "" : window.JSON ? window.JSON.parse(a) : eval("(" + a + ")")
    };
    lib.net.getLoginInfo = function () {
        return{isLogin:lib.net.isLogin(), uid:lib.net.getUserInfo().uid}
    };
    lib.net.showLogin = function (a) {
        var c = lib.PROJECT_LOGIN_COMPONENT || qitan.component.login.init;
        c.show ? c.show(a || function () {
        }) : c()
    };
    a.core = Class.create({initialize:function (a) {
        this.opt = a;
        this._initActions()
    }, _initActions:function () {
        for (var a in this.opt.actions)this[a] = this._action.bind(this, a)
    }, _action:function (a, c, d) {
        var a = this.opt.actions[a], e = (this.opt.url || "") + (a.url || "");
        a.data = this._getParams(a, c, e);
        a.success = this._success.bind(this, a.format, d);
        a.failure = this._failure.bind(this, d);
        a.passport && !lib.net.isLogin() ? (this.__request = this._request.bind(this, e, a), this.__request.isTemp = !0, lib.net.showLogin(this.__request)) : this._request(e, a)
    }, _request:function (a, c) {
        var d = null;
        if (arguments.length >= 3 && arguments[2].nickname && (d = arguments[2], c.data.indexOf("userId=undefined") !== -1))c.data = c.data.replace("userId=undefined", "userId=" + d.uid);
        this.isCrossDomain(a) ? lib.net.crossDomain.request(a, c) : lib.net.Ajax.request(a + "?t=" + (new Date).getTime(), c)
    }, isCrossDomain:function (a) {
        var c = /https?:\/\/(.*?)\//,
            a = a.match(c)[0], c = location.href.match(c)[0];
        return this.opt.crossDomain === void 0 ? a !== c : this.opt.crossDomain
    }, _success:function (a, c, d) {
        a == "json" ? d.code == qitan.model.SUCCESS ? c.success && c.success(d.data) : c.failure && c.failure(d) : c.success(d)
    }, _failure:function (a, c) {
        a.failure && a.failure(c)
    }, _getParams:function (a, c, d) {
        var d = this.isCrossDomain(d), e = [], f = {}, g;
        for (g in c)a.params.include(g) && (!d && a.encode || d && a.encode && a.method == "get" ? e.push(g + "=" + encodeURIComponent(c[g])) : d && a.method == "post" ? f[g] = c[g] : e.push(g +
            "=" + c[g]));
        if (d && a.method == "post")return f;
        return e.join("&")
    }});
    lib.model = qitan.request = function (a) {
        return new qitan.model.request.core(a)
    }
});
(function () {
    var a = String.prototype;
    lib.each({trimLeft:function () {
        return this.replace(/^(\u3000|\s|\t)*/gi, "")
    }, trimRight:function () {
        return this.replace(/(\u3000|\s|\t)*$/gi, "")
    }, trim:function () {
        return this.trimLeft().trimRight()
    }, trimHtml:function () {
        return this.replace(/<\/?[^>]+(>|$)/g, "")
    }, format:function () {
        var a = arguments;
        return this.replace(/{(\d+)(:([0-9a-z]+))?}/gi, function (c, d) {
            var e = a[parseInt(d)];
            if (typeof e === "undefined")return c;
            return e
        })
    }, setImgSize:function (a) {
        var c = this.match(/^([^_]*)(_\d+_\d+)?(\..*)$/);
        if (!c)return this;
        return c[1] + (a || c[2] || "") + c[3]
    }, getLen:function () {
        if (typeof this == "undefined")return 0;
        var a = this.match(/[^\x00-\x80]/g);
        return this.length + (!a ? 0 : a.length)
    }, divideNumber:function () {
        for (var a = "", c = Math.ceil(this.length / 3); c > 0; c--)left = this.length - (c - 1) * 3 <= 0 ? 0 : this.length - (c - 1) * 3, a += "," + this.substring(left, this.length - c * 3);
        return a = a.substring(1, a.length)
    }, filter:function () {
        return this.replace(/[^a-z0-9A-Z\u4e00-\u9fa5]/g, " ")
    }, trancate:function (a, c) {
        var d = this;
        typeof c == "undefined" &&
        (c = "..");
        if (d.getLen() <= a)return d;
        var e = d.replace(/\*/g, " ").replace(/[^\x00-\xff]/g, "**"), d = d.slice(0, e.slice(0, a).replace(/\*\*/g, " ").replace(/\*/g, "").length);
        return d = d.slice(0, d.length - (c === "" ? 0 : 1)) + c
    }, encodeHtml:function () {
        return String(this).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;")
    }}, function (b, c) {
        lib.isNative(a[c]) || (a[c] = b)
    })
})(window, document);
(function () {
    $reg("lib.ui", function () {
    });
    lib.ui.viewCenter = function (a, b) {
        b = b || "absolute";
        if (a) {
            var c = a.offsetWidth, d = a.offsetHeight, e = lib.box.getViewportWidth(), f = lib.box.getViewportHeight();
            if (!c || !d)throw"zero width or height.";
            c = {left:(e - c) / 2 + lib.box.getPageScrollLeft(), top:(f - d) / 2 + lib.box.getPageScrollTop()};
            a.style.position = b;
            $(a).pos(c)
        }
    }
})();
if (!window.JSON)window.JSON = window.JSON || {}, JSON.parse = function (a) {
    return(new Function("return " + a))()
}, JSON.stringify = function () {
    function a(a) {
        /["\\\x00-\x1f]/.test(a) && (a = a.replace(/["\\\x00-\x1f]/g, function (a) {
            var b = c[a];
            if (b)return b;
            b = a.charCodeAt();
            return"\\u00" + Math.floor(b / 16).toString(16) + (b % 16).toString(16)
        }));
        return'"' + a + '"'
    }

    function b(a) {
        return a < 10 ? "0" + a : a
    }

    var c = {"\u0008":"\\b", "\t":"\\t", "\n":"\\n", "\u000c":"\\f", "\r":"\\r", '"':'\\"', "\\":"\\\\"};
    return function (c) {
        switch (typeof c) {
            case "undefined":
                return"undefined";
            case "number":
                return isFinite(c) ? String(c) : "null";
            case "string":
                return a(c);
            case "boolean":
                return String(c);
            default:
                if (c === null)return"null"; else if (c instanceof Array) {
                    var e = ["["], f = c.length, g, j, h;
                    for (j = 0; j < f; j++)switch (h = c[j], typeof h) {
                        case "undefined":
                        case "function":
                        case "unknown":
                            break;
                        default:
                            g && e.push(","), e.push(JSON.stringify(h)), g = 1
                    }
                    e.push("]");
                    return e.join("")
                } else if (c instanceof Date)return'"' + c.getFullYear() + "-" + b(c.getMonth() + 1) + "-" + b(c.getDate()) + "T" + b(c.getHours()) + ":" + b(c.getMinutes()) +
                    ":" + b(c.getSeconds()) + '"'; else {
                    g = ["{"];
                    f = JSON.stringify;
                    for (key in c)if (c.hasOwnProperty(key))switch (j = c[key], typeof j) {
                        case "undefined":
                        case "unknown":
                        case "function":
                            break;
                        default:
                            e && g.push(","), e = 1, g.push(f(key) + ":" + f(j))
                    }
                    g.push("}");
                    return g.join("")
                }
        }
    }
}();
var lib = lib || {};
function Jobs() {
    this._jobTable = [];
    this._startedjobTable = []
}
Jobs.prototype = {_registedJobTable:{}, _registedJobsTable:{}, _orinJobTable:{}, initialize:function () {
}, _registJob:function (a, b) {
    this._registedJobTable[a] = b;
    this._orinJobTable[a] = b;
    return this
}, _registJobs:function (a, b) {
    this._registedJobsTable[a] = b;
    return this
}, add:function (a, b) {
    for (var c = 0, d = this._jobTable.length; c < d; c++)if (this._jobTable[c].name == a)return this;
    for (c in this._registedJobsTable)if (c == a) {
        for (var e in this._registedJobsTable[c])this._jobTable.push({name:e, param:b && b[e] || this._registedJobsTable[c][e]});
        return this
    }
    this._jobTable.push({name:a, param:b});
    return this
}, start:function () {
    for (var a = this._registedJobTable; this._jobTable.length > 0;) {
        var b = this._jobTable[0].name, c = this._jobTable[0].param, d = a[b];
        if (typeof d == "undefined")this._jobTable.shift(); else try {
            this._startedjobTable.indexOf(b) == -1 && (d.call(null, c), this._startedjobTable.push(b)), this._jobTable.shift(), delete this._registedJobTable[b]
        } catch (e) {
            lib.log("Job[" + b + "] failed!!!"), _try = !1, lib.log("job start  msg: " + e.message), lib.log("job start file: " +
                e.fileName), lib.log("job start line: " + e.lineNumber), this._jobTable.shift()
        }
    }
}, call:function (a, b) {
    typeof this._orinJobTable[a] != "undefined" ? this._orinJobTable[a].apply(this, b) : lib.log("Job[" + a + "] is undefined!!!")
}};
$newJob = lib.kit.newJob = function (a, b) {
    Jobs.prototype._registJob(a, b)
};
$newJobs = lib.kit.newJobs = function (a, b) {
    Jobs.prototype._registJobs(a, b)
};
lib.kit.$callJob = function (a) {
    var b = [];
    arguments.length > 1 && (arguments.foreach(function (a, d) {
        b[d] = a
    }), b.shift());
    Jobs.prototype.call(a, b)
};
lib._PAGE_JOB = new Jobs;
$reg("lib.kit.Monitor", function () {
    lib.kit.Monitor = Class.create({initialize:function (a, b) {
        this._fn = a;
        this._opt = {time:10, maxTime:null};
        Object.extend(this._opt, b)
    }, start:function () {
        var a = this;
        if (this._opt.maxTime)this._maxTimer = setTimeout(function () {
            a.stop()
        }, this._opt.maxTime);
        this._timer = setTimeout(function () {
            if (a._fn.call() === !1)a._timer = setTimeout(arguments.callee, a._opt.time)
        }, this._opt.time)
    }, stop:function () {
        this._timer && clearTimeout(this._timer)
    }})
});
$reg("lib.kit.FlashCall", function () {
    lib.kit.FlashCall = function (a) {
        var a = a || {}, b = $("#" + (a.flashID || "")), c = a.functionName, d = a.parameter, e = a.tryTimes || 0, f = a.perTimes || 500, g = 0, j = a.callback || lib.emptyMethod, h, k;
        b && c && (h = function () {
            var a;
            try {
                a = d === void 0 ? b[0][c]() : Object.prototype.toString.apply(d) == "[object Object]" ? b[0][c](JSON.stringify(d)) : b[0][c](d)
            } catch (e) {
                return!1
            }
            try {
                j(a)
            } catch (f) {
            }
            return!0
        }, function () {
            clearTimeout(k);
            if (!h() && (!e || g < e))k = setTimeout(arguments.callee, f), g++
        }())
    }
});
lib.swf = lib.swf || {};
lib.swf.openWindow = function (a) {
    window.open(a);
    return!0
};
lib.swf.openAdPostWindow = function (a, b, c, d) {
    d != void 0 && (b = b.replace('"ib":"' + d + '"', '"ib":"' + String((new Date).getTime() + Number(d)) + '"'));
    c = document.createElement("form");
    c.id = "tempForm";
    c.method = "post";
    c.action = a;
    c.target = "_blank";
    a = document.createElement("input");
    a.type = "hidden";
    a.name = "data";
    a.value = b;
    c.appendChild(a);
    document.body.appendChild(c);
    c.submit();
    document.body.removeChild(c)
};
lib.swf.openPostWindow = function (a, b) {
    var b = JSON.parse(b), c = document.createElement("form");
    c.id = "tempForm";
    c.method = "post";
    c.action = a;
    c.target = "_blank";
    if (b)for (var d in b) {
        var e = document.createElement("input");
        e.type = "hidden";
        e.name = d;
        e.value = b[d];
        c.appendChild(e)
    }
    document.body.appendChild(c);
    c.submit();
    document.body.removeChild(c)
};
lib._PAGE_EVENT.on("swf_getLoginInfo", function () {
    var a = lib.$("#flash");
    a && a[0] && !a[0].notice && lib.kit.slog.log({flag:"getLoginInfoErr"});
    lib.kit.FlashCall({flashID:"flash", functionName:"notice", parameter:{type:"getLoginInfo", data:{isLogin:lib.net.isLogin(), uid:lib.net.getUserInfo().uid}}})
});
lib.swf.getCookieLoginState = function () {
    return JSON.stringify({isLogin:lib.net.isLogin(), uid:lib.net.getUserInfo().uid})
};
lib.swf.getPageInfo = function () {
    var a = lib.$("#j-gui-qitan") ? "true" : "false", b = lib.net.getUserInfo() || {}, a = {canDown:(!!lib.$("#j-offline")).toString(), login:lib.net.isLogin().toString(), passportId:b.uid, comment:a, name:b.nickname};
    return JSON.stringify(a)
};
lib._PAGE_EVENT.on("swf_moveToQitan", function () {
    try {
        lib.swf.scroll2qitan()
    } catch (a) {
        lib.log("player-api msg: " + a.message), lib.log("player-api file: " + a.fileName), lib.log("player-api line: " + a.lineNumber)
    }
});
lib.temp = lib.temp || {};
lib.temp.processVBaidu = function (a) {
    if ((a = lib.$(a.target || a.srcElement).parent("a")) && a.attr("target") != "_blank" && a.attr("href") && !a.attr("href").match(/#$/) && !a.attr("href").match(/^javascript\:/))top.location.href = a.attr("href")
};
var url = new lib.kit.Url(location.href);
if (url.getParam("pr") == "baidu")lib.$(document).on("click", lib.temp.processVBaidu);