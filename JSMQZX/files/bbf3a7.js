/*! Camus. Copyright © 2014 Triton Information. All rights reserved. */
(function(){"use strict";!function(a,b){var c,d,e;return d=a.location,a.self!==a.top&&0!==(null!=(e=d.pathname)?e.indexOf("/studio/paper/connect"):void 0)?(c="color: red; font-size: 2.5em; line-height: 2em; padding: 0.5em; background: yellow;",b.warn("%c\u60a8\u6240\u4f7f\u7528\u7684\u9875\u9762\uff0c\u7531\u79c0\u7c73\u63d0\u4f9b",c),b.warn("%c\u6211\u4eec\u6b22\u8fce\u5408\u4f5c\uff0c\u4f46\u8bf7\u60a8\u4e0e\u6211\u4eec\u8054\u7cfb\uff0c\u544a\u77e5\u4f7f\u7528\u65b9\u5f0f\u3002",c),b.warn("%c\u6211\u4eec\u4fdd\u7559\u4e00\u5207\u6743\u5229\u3002",c),b.warn("%chttp://xiumi.us",c),b.warn("%cEmail: contact@tritoninfo.net",c),b.warn("%cCopyright \xa9 2014 Triton Information. All rights reserved.",c)):(c="color: #0f0; font-size: 1.5em; line-height: 3em; padding: 1em; background: rgba(10, 10, 10, 1);",b.info("%c\u559c\u6b22\u7814\u7a76\u79c0\u7c73\u7684\u4ee3\u7801\uff0c\u8fd8\u662f\u53d1\u73b0\u4e86\u4ec0\u4e48bug\uff1f\u544a\u8bc9\u6211\u4eec\u5427~ :)",c),b.info("%cEmail: contact@tritoninfo.net",c),b.warn("%c\u4f46\u6293\u53d6\u4ee3\u7801\u53e6\u5efa\u7ad9\uff0c\u9ebb\u9ebb\u53ef\u662f\u8981\u6253pp\u7684\u54df\u3002",c+"color: #f50;"),b.warn("%cCopyright \xa9 2014 Triton Information. All rights reserved.",c+"color: #f50;"))}(window,console)}).call(this),function(){"use strict";window.namespace={_ns:{},reg:function(a){var b,c,d,e,f;for(b=this._ns,d=a.split("."),e=0,f=d.length;f>e;e++)c=d[e],b=b[c]=b[c]||{};return b},use:function(a){var b,c,d,e,f;for(b=this._ns,d=a.split("."),e=0,f=d.length;f>e&&(c=d[e],b=b[c],b);e++);return b}}}.call(this),function(){"use strict";!function(a,b){var c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v;if(e=13152551,l=function(a){var b,c,d,f;for(f=[],c=0,d=a.length;d>c;c++)b=a[c],f.push(b^e);return f},i=function(a){var b;return b=l(a),String.fromCharCode.apply(String,b)},f=function(){var b,c,d,e,f,g,h;return d=[13152582,13152585,13152576,13152594,13152587,13152582,13152597],e=[13152589,13152630,13152594,13152578,13152597,13152606],b=[13152515],f=[13152585,13152582,13152586,13152578,13152596,13152599,13152582,13152580,13152578],a[i(d)]=a[i(e)]=a[i(b)]=a[i(f)]=void 0,h=[13152591,13152595,13152595,13152599,13152541,13152520,13152520,13152607,13152590,13152594,13152586,13152590,13152521,13152594,13152596],c=[13152632,13152595,13152584,13152599],g=[13152584,13152599,13152578,13152585],a[i(g)](i(h),i(c))},a&&b||f(),o=[13152591,13152584,13152596,13152595,13152585,13152582,13152586,13152578],n=[13152534,13152533,13152528,13152521,13152535,13152521,13152535,13152521,13152534],p=[13152587,13152584,13152580,13152582,13152587,13152591,13152584,13152596,13152595],j=b[i(o)],j!==i(n)&&j!==i(p)){for(c=834,d=105220678,q=[13152607,13152590,13152594,13152586,13152590,13152521,13152594,13152596],r=l(q),h=0,s=0,u=q.length;u>s;s++)k=q[s],h+=k;for(g=0,t=0,v=r.length;v>t;t++)k=r[t],g+=k;return m=i(q),h!==d||g!==c?f():j.slice(-m.length)!==m?f():void 0}}(window,location,console)}.call(this),function(){"use strict";var a,b;b=angular.module("triton.directives",[]),b.filter("unsafe",["$sce",function(a){return function(b){return null!=b?a.trustAsHtml(b):void 0}}]),b.filter("unsafeResource",["$sce",function(a){return function(b){return null!=b?a.trustAsResourceUrl(b):void 0}}]),b.filter("eol2br",[function(){return function(a){return null!=a?a.replace(/(?:\r\n|\r|\n)/g,"<br>"):void 0}}]),b.filter("hitCountText",[function(){return function(a){return null==a?"[ \u65e0\u8bb0\u5f55 ]":"number"!=typeof a?a.toString():1e4>=a?a.toString():""+Math.floor(a/1e4)+"\u4e07+"}}]),b.factory("formUploader",["$http",function(a){var b;return b={"Content-Type":void 0},{submit:function(c,d,e){var f,g,h;null==e&&(e=b),f=new FormData;for(g in d)h=d[g],f.append(g,h);return a.post(c,f,{transformRequest:angular.identity,headers:e})}}}]),b.directive("fileModel",["$parse",function(a){return{restrict:"A",link:function(b,c,d){var e,f;return e=a(d.fileModel),f=e.assign,c.on("change",function(){return b.$apply(function(){return f(b,c[0].files[0])}),c[0].value=null})}}}]),b.directive("filesModel",["$parse",function(a){return{restrict:"A",link:function(b,c,d){var e,f;return e=a(d.filesModel),f=e.assign,c.on("change",function(){return b.$apply(function(){var a,d,e,g,h;for(d=[],h=c[0].files,e=0,g=h.length;g>e;e++)a=h[e],d.push(a);return f(b,d)}),c[0].value=null})}}}]),b.directive("fileChange",[function(){return{restrict:"A",scope:{fileChange:"&"},link:function(a,b){return b.on("change",function(){return a.$apply(function(){return a.fileChange()})})}}}]),b.directive("stopPropagation",[function(){return{restrict:"A",link:function(a,b,c){var d,e;return e=null,d=function(a){return a.stopPropagation()},c.$observe("stopPropagation",function(a){return e&&b.off(e,d),b.on(a,d),e=a})}}}]),b.directive("tnEditContent",[function(){return{restrict:"A",require:"ngModel",link:function(a,b,c,d){var e,f;return f="true"===c.stripBr,e=function(){var a,c,e;return c=b.get(0),e=c.innerText||c.textContent,a=f?"":"\n",e=e.replace(/(?:\r\n|\r|\n)/g,a),d.$setViewValue(e),d.$render()},b.bind("blur",function(){return a.$apply(e)}),d.$render=function(){var a,c,e;return e=d.$viewValue||"",a=f?"":"<br>",c=e.replace(/(?:\r\n|\r|\n)/g,a),b.html(c)},d.$render()}}}]),b.directive("tnEditHtmlContent",[function(){return{restrict:"A",require:"ngModel",link:function(a,b,c,d){var e;return e=function(){return d.$setViewValue(b.html())},a.$on("$destroy",function(){return b.off("blur paste")}),b.off("blur paste"),b.on("blur",function(){return a.$apply(e)}),b.on("paste",function(a){var b,c,d;return b=a.clipboardData||(null!=(d=a.originalEvent)?d.clipboardData:void 0)||window.clipboardData,c=b.getData("text/plain")||b.getData("Text"),("function"==typeof document.queryCommandSupported?document.queryCommandSupported("insertText"):void 0)?("function"==typeof document.execCommand&&document.execCommand("insertText",!1,c),a.preventDefault(),a.stopPropagation()):("function"==typeof document.queryCommandSupported?document.queryCommandSupported("insertHTML"):void 0)?("function"==typeof document.execCommand&&document.execCommand("insertHTML",!1,c),a.preventDefault(),a.stopPropagation()):void 0}),d.$render=function(){var a,c;return c=d.$viewValue||"",a=c,c.length>0&&(0!==c.indexOf("<section")&&(a="<section>"+c+"</section>"),a=a.replace(/(?:\r\n|\r|\n)/g,"<br>")),c&&a!==c&&d.$setViewValue(a),b.html(a)},d.$render()}}}]),b.directive("qrcode",[function(){return{restrict:"AE",scope:{qrData:"="},link:function(a,b,c){var d,e,f,g,h,i;return b.addClass("qrcode"),d={L:1,M:0,Q:3,H:2},i=parseInt(c.qrSize)||256,h=c.qrRender||"canvas",f=c.qrForeground||"black",e=c.qrBackground||"transparent",g=d[c.qrLevel||"M"],a.$watch("qrData",function(a){return null!=a?(b.empty(),b.qrcode({text:a.toString(),render:h,width:i,height:i,typeNumber:-1,correctLevel:g,background:e,foreground:f})):void 0})}}}]),b.directive("tnUeditor",[function(){return{restrict:"AE",require:"ngModel",scope:{editorReady:"&",selectionChange:"&"},link:function(a,b,c,d){var e,f,g,h;return h=Math.floor(1e6*Math.random()).toString(),b.attr("id",h),f=function(){var b;return b=UE.getEditor(h,{initialFrameWidth:"100%"}),window._ue=b,b.ready(function(){var c;return c=function(){var c;return c=b.getContent(),d.$setViewValue(c),"function"==typeof a.selectionChange?a.selectionChange({ue:b}):void 0},b.addListener("selectionchange",function(){return a.$apply(c)}),d.$render=function(){var a;return a=d.$viewValue||"",b.setContent(a)},d.$render(),"function"==typeof a.editorReady?a.editorReady({ue:b}):void 0})},"undefined"!=typeof UE?f():(e=$("body"),$('<script type="text/javascript" src="/3rd/ueditor/20141210/ueditor.config.js"></script>').appendTo(e),g=$('<script type="text/javascript" src="/3rd/ueditor/20141210/ueditor.all.min.js"></script>').appendTo(e),g.ready(function(){return f()}))}}}]),a=function(a,b,c){return a.directive(b,[function(){return{restrict:"A",link:function(a,d,e){var f,g;if(null!=d[c])return g=null,f=function(){return"function"==typeof d[c]?d[c]():void 0},e.$observe(b,function(a){return g&&d.off(g,f),d.on(a,f),g=a})}}}])},a(b,"autoFocusOn","focus"),a(b,"autoSelectOn","select"),b.directive("focusMe",[function(){return{restrict:"A",link:function(a,b,c){return a.$watch(c.focusMe,function(a){return a===!0?setTimeout(function(){return b.select(),b.focus()},0):void 0})}}}]),b.directive("actAsLink",[function(){return{restrict:"A",link:function(a,b,c){return b.on("click",function(a){var b,d;return b=c.actAsLink||c.href||c.value,d=c.target||"_blank",b?(window.open(b,d),a.preventDefault(),a.stopPropagation()):void 0})}}}]),b.directive("aliasAs",[function(){return{restrict:"A",link:function(a,b,c){var d;return d=jQuery(c.aliasAs),d.css("cssText","position  : fixed !important;\nleft      : -10000px !important;\nheight    : 0 !important;\nwidth     : 0 !important;\nopacity   : 0 !important;"),c.aliasEvent?b.on(c.aliasEvent,function(a){return d.trigger(a.type)}):void 0}}}]),b.directive("elementReady",[function(){return{priority:-1e3,restrict:"A",link:function(a,b,c){console.log(" -- Element ready!"),a.$eval(c.elementReady)}}}]),b.directive("finishRepeatWithEvent",["$timeout",function(a){return{restrict:"A",link:function(b,c,d){return b.$last===!0?a(function(){return b.$emit(d.finishRepeatWithEvent)}):void 0}}}])}.call(this),function(){"use strict";var EDT_EditingAttrs,EDT_EditingAttrs_Global,EDT_PresentationAttrs,createLocation,editablePage;createLocation=function(){return{left:0/0,top:0/0,leftToPage:0/0,topToPage:0/0,width:0/0,height:0/0}},editablePage=angular.module("triton.editablePage",["triton.directives"]),EDT_PresentationAttrs={"ed-type-text":{"ng-style":" {\n  'font-size'       : eo.fontSize || 'inherit',\n  'font-family'     : eo.fontFamily || 'inherit',\n  'font-style'      : eo.fontStyle || 'inherit',\n  'font-weight'     : eo.fontWeight || 'inherit',\n  'text-align'      : eo.textAlign || 'inherit',\n  'text-decoration' : eo.textDecoration || 'inherit',\n  'color'           : (eo.color || theme.majorColor)\n} ","ng-bind-html":"eo.text | eol2br | unsafe"},"ed-type-rich-text":{"ng-style":" {\n  'font-size'       : eo.fontSize || 'inherit',\n  'font-family'     : eo.fontFamily || 'inherit',\n  'font-style'      : eo.fontStyle || 'inherit',\n  'font-weight'     : eo.fontWeight || 'inherit',\n  'text-align'      : eo.textAlign || 'inherit',\n  'text-decoration' : eo.textDecoration || 'inherit',\n  'color'           : (eo.color || theme.majorColor),\n  'background-color': (eo.backgroundColor || theme.majorColor),\n  'border-color'    : (eo.borderColor || theme.majorColor)\n} "},"ed-type-bg":{"tn-style":" {\n  'background-image'  : 'url(\"' + eo.url + '\")',\n} ","ng-style":" {\n  'background-position-x' : eo.posX || 'center',\n  'background-position-y' : eo.posY || 'center',\n  'background-repeat'     : 'no-repeat',\n  'background-size'       : eo.backgroundSize || 'cover',\n} "},"img-link":{"sell-link":"{{ eo.url }}","tn-commodity-link":"","ng-show":"eo.url","tn-ga-event":"\u8fdb\u5165\u8d2d\u4e70\u9875"},"tel-link":{"ng-href":"{{ eo.url }}","ng-show":"!!eo.url","tn-ga-event":"\u62e8\u6253\u7535\u8bdd"},"aud-link":{"ng-src":"{{ eo.url | unsafeResource }}"},"ed-aud-link":{"ng-src":"{{ eo.url | unsafeResource }}"},image:{"ng-src":"{{ eo.url | unsafeResource }}"},"bg-color":{"ng-style":" {\n  'background-color' : (eo.backgroundColor || theme.textBgColor),\n} "},"border-color":{"ng-style":" {\n  'border-color' : (eo.borderColor || theme.borderColor),\n} "},"text-color":{"ng-style":" {\n  'color' : (eo.color || theme.majorColor),\n} "}},EDT_EditingAttrs={"ed-type-text":{contenteditable:"true",placeholder:"{ \u70b9\u51fb\u7f16\u8f91 }","ng-model":"eo.text","tn-edit-html-content":"true","stop-propagation":"click mousedown mouseup","ng-bind-html":null,"ui-on-drop":"block($event)"},"ed-type-rich-text":{"stop-propagation":"click mousedown mouseup","ui-on-drop":"block($event)"},"ed-type-bg":{"ui-on-drop":"onAssetDrop($event, $data)"},"img-link":{"tn-commodity-link":null,"ng-show":"true"},"tel-link":{"ng-href":null,"tn-ga-event":null,"ng-show":"true"},"ed-aud-link":{"tn-auto-play":"{{ eo.autoPlay }}","tn-loop":"{{ eo.loop }}","tn-show-control":"{{ eo.showControl }}"},image:{"ui-on-drop":"onAssetDrop($event, $data)"}},EDT_EditingAttrs_Global={"ng-click":"onClick($event)"},editablePage.directive("tnPageBox",[function(){return{restrict:"A",replace:!1,controller:["$scope","$element",function(a,b){return{screenLocation:function(){return b.offset()}}}],link:function(a,b){return b.css("cssText","position: relative !important;"),b.addClass("tn-page-box")}}}]),editablePage.directive("tnSliceBusPropsEditable",[function(){return{restrict:"A",replace:!1,scope:{onClickEditable:"&"},controller:["$scope","$element",function(a,b){return{submitEditable:function(c,d,e){var f,g;if(null!=d)switch(d.type){case"bg-color":case"border-color":case"text-color":return(f=a.busPropEO.eoList)[c]||(f[c]=d),(g=a.busPropEO.elList)[c]||(g[c]=e),b.addClass("tn-page-editable")}}}}],link:function(a,b){var c;return a.busPropEO={type:"slice-bus-props",eoList:{},elList:{}},c=function(){var c,d,e,f,g;return e=b.parents("[tn-page-box]").offset()||{left:0,top:0},g=b.offset(),f=createLocation(),c=parseInt(b.css("border-left-width"),10),d=parseInt(b.css("border-top-width"),10),f.left=g.left-e.left+c,f.top=g.top-e.top+d,f.width=b.innerWidth(),f.height=b.innerHeight(),{templateId:"",editableId:"__slice-bus-props",editableType:"tn-page-slice-bus-props",editableObject:a.busPropEO,notEditableAttrList:[],editableLocation:f,subEditables:[]}},b.on("click",function(){return Object.keys(a.busPropEO.eoList).length?a.$apply(function(){return"function"==typeof a.onClickEditable?a.onClickEditable({editableDesc:c(),editableElem:b}):void 0}):void 0}),b.addClass("tn-page-slice-bus-props")}}}]),editablePage.filter("templateIdToPath",[function(){return function(a,b){return null==a?void 0:(b||console.error("tplPath is not set correctly!"),""+b+"/"+a+".html")}}]),editablePage.filter("clr2theme",[function(){var a,b;return a={},b=function(a){return{majorColor:a,textBgColor:a,borderColor:a}},function(c){return c?a[c]||(a[c]=b(c)):null}}]),editablePage.directive("tnPageLoader",[function(){return{restrict:"AE",replace:!1,require:["tnPageLoader","?^tnPageBox"],scope:{page:"=",theme:"=",templatePath:"@",onClickEditable:"&",onDropAssetToEditable:"&"},template:'<div class="tn-page"\n     ng-include="(page.templateId) | templateIdToPath: templatePath">\n</div>',controller:["$scope","$element",function(a,b){return{calcPageBoxLocation:function(a){var c,d,e,f,g,h;return e=b.parents("[tn-page-box]").offset()||{left:0,top:0},h=b.offset(),f=a.offset(),c=parseInt(a.css("border-left-width"),10),d=parseInt(a.css("border-top-width"),10),g=createLocation(),g.left=f.left-e.left+c,g.top=f.top-e.top+d,g.leftToPage=f.left-h.left+c,g.topToPage=f.top-h.top+d,g.width=a.innerWidth(),g.height=a.innerHeight(),g}}}]}}]),editablePage.directive("tnPageShowWithTransition",["$timeout",function(a){return{restrict:"A",priority:1e4,controller:function(){},link:function(b,c,d){return b.$on("$includeContentLoaded",function(){var b,e;return e="true"===d.tnPageShowWithTransition,b=c.find('[ng-controller="pageController"]').scope(),null!=(null!=b?b.onPageShow:void 0)?a(function(){return b.onPageShow(e)}):void 0})}}}]),editablePage.directive("editableType",["$compile",function(a){return{restrict:"A",replace:!1,require:["?^tnPageBox","?^tnPageShowWithTransition"],priority:1e3,terminal:!0,compile:function(){return{pre:function(a,b,c,d){var e,f,g,h;return f=c.editableType,b.removeAttr("editable-type"),b.attr("tn-page-editable-type",f),e=function(a){var c,d,e;null==a&&(a={}),e=[];for(c in a)d=a[c],e.push(b.attr(c,d));return e},e(EDT_PresentationAttrs[f]),g=d[0],h=d[1],null!=g&&(e(EDT_EditingAttrs_Global),e(EDT_EditingAttrs[f]),b.addClass("tn-page-"+f)),null==h||"img-link"!==f&&"aud-link"!==f?void 0:e(EDT_EditingAttrs[f])},post:function(b,c){return a(c)(b)}}}}}]),editablePage.directive("tnPageEditable",["$window",function(a){return{restrict:"A",replace:!1,require:["^tnPageLoader","?^tnPageBox","?^tnSliceBusPropsEditable"],scope:!0,link:function(b,c,d,e){var f,g,h,i,j,k,l;return a.location.__p||834===a.document.__a||994===a.document.__a||3!==Math.floor(5*a.location.__r)||c.css(c.parent().css()),g=function(a){return{subEdIndex:a.attr("tn-sub-ed-index"),editableWidth:a.width(),editableHeight:a.height()}},h=function(){var a;return b.subEd=[],null!=d.tnSetEditable?(a=c.find("[tn-sub-ed-index]"),a.each(function(){return b.subEd.push(g(jQuery(this)))})):void 0},f=function(){return{templateId:b.templateId,editableId:b.ei,editableType:b.et,editableObject:b.eo,notEditableAttrList:b.neal,editableLocation:"undefined"!=typeof k&&null!==k&&"function"==typeof k.calcPageBoxLocation?k.calcPageBoxLocation(c):void 0,subEditables:b.subEd}},i=function(){var a,e,f,g,i,k,m,n,o,p,q;return null==b.page&&console.error("tnPageEditable: slice is null"),null==(null!=(i=b.page)?i.editables:void 0)&&console.error("tnPageEditable: editables is null"),b.ei=d.tnPageEditable,b.et=d.tnPageEditableType,b.neal=[],null!=d.tnNotEditableAttr&&(b.neal=d.tnNotEditableAttr.split(" ")),b.eo=null!=d.tnSubEdIndex?null!=(k=b.page)&&null!=(m=k.editables)?(e=m[b.ei].set)[f=c.attr("tn-sub-ed-index")]||(e[f]={type:b.et}):void 0:null!=(n=b.page)&&null!=(o=n.editables)?o[g=b.ei]||(o[g]={type:b.et}):void 0,h(),c.addClass("tn-page-editable"),null==b.eo?(a=b.$parent.$parent.$parent.$index,console.error("[Editable] editable object mismatch. at page '"+a+"'\n  '"+b.page.templateId+"' >> '"+b.ei+"' ( '"+b.et+"' )")):(null!=(p=b.eo)?p.type:void 0)!==b.et&&(a=b.$parent.$parent.$parent.$index,console.error("[Editable] editable object type mismatch. at page '"+a+"'\n  '"+b.page.templateId+"' >> '"+b.ei+"' ( '"+(null!=(q=b.eo)?q.type:void 0)+"' | '"+b.et+"' )")),"undefined"!=typeof j&&null!==j&&"undefined"!=typeof l&&null!==l?l.submitEditable(b.ei,b.eo,c):void 0},b.block=function(a){return a.preventDefault(),a.stopPropagation()},b.onClick=function(a){return"border-color"===d.tnPageEditableType||null!=d.tnSubEdIndex||null!=d.tnSetEditable&&null===a.target.getAttribute("tn-sub-ed-index")?void 0:(a.preventDefault(),a.stopPropagation(),"function"==typeof b.onClickEditable?b.onClickEditable({editableDesc:f(),editableElem:c}):void 0)},b.onAssetDrop=function(a,d){return a.preventDefault(),a.stopPropagation(),"function"==typeof b.onDropAssetToEditable?b.onDropAssetToEditable({editableDesc:f(),editableElem:c,asset:d}):void 0},k=e[0],j=e[1],l=e[2],i(),b.$watch(function(){return c.attr("tn-sub-ed-index")},function(){return i()}),b.$watch("page",function(a,e){var f,g;return(null!=a?a.templateId:void 0)===(null!=e?e.templateId:void 0)?b.eo=null!=d.tnSubEdIndex?null!=a&&null!=(f=a.editables)?f[b.ei].set[c.attr("tn-sub-ed-index")]:void 0:null!=a&&null!=(g=a.editables)?g[b.ei]:void 0:void 0})}}}]),editablePage.directive("tnHideWhenEditing",[function(){return{restrict:"A",require:"?^tnPageBox",link:function(a,b){return b.addClass("tn-hide-when-editing")}}}]),editablePage.directive("tnShowWhenEditing",[function(){return{restrict:"A",require:"?^tnPageBox",link:function(a,b,c,d){return d?b.addClass("tn-show-when-editing"):void 0}}}]),editablePage.directive("tnHideWhenEnterEditing",[function(){return{restrict:"A",link:function(a,b){return a.$on("editingManager_enterEditing",function(){return b.addClass("tn-hide-when-enter-editing")}),a.$on("editingManager_exitEditing",function(){return b.removeClass("tn-hide-when-enter-editing")})}}}]),editablePage.directive("tnAutoPlay",[function(){return{restrict:"A",link:function(scope,element,attrs){return attrs.$observe("tnAutoPlay",function(tnAutoPlay){return eval(tnAutoPlay)?element.attr("autoplay","autoplay"):element.removeAttr("autoplay")},!0)}}}]),editablePage.directive("tnLoop",[function(){return{restrict:"A",link:function(scope,element,attrs){return attrs.$observe("tnLoop",function(tnLoop){return eval(tnLoop)?element.attr("loop","loop"):element.removeAttr("loop")},!0)}}}]),editablePage.directive("tnShowControl",[function(){return{restrict:"A",link:function(scope,element,attrs){return attrs.$observe("tnShowControl",function(tnShowControl){return eval(tnShowControl)?element.css("display","block"):element.css("display","none")},!0)}}}]),editablePage.directive("tnRichTextContent",["$compile",function(a){return{restrict:"A",require:"?^tnPageBox",priority:1010,terminal:!0,compile:function(){return{pre:function(a,b,c,d){return b.removeAttr("tn-rich-text-content"),d?(b.attr("ng-bind-html",null),b.attr("contenteditable","true"),b.attr("placeholder","{ \u70b9\u51fb\u7f16\u8f91 }"),b.attr("ng-model","eo.text"),b.attr("tn-edit-html-content","true")):b.attr("ng-bind-html","eo.text | eol2br | unsafe"),b.addClass("tn-rich-text-content")},post:function(b,c){return a(c)(b)}}}}}]),editablePage.directive("tnDragHandlerNotInEditing",["$compile",function(a){return{restrict:"A",replace:!1,require:"?^tnPageBox",priority:1e3,terminal:!0,compile:function(){return{pre:function(a,b,c,d){return b.removeAttr("tn-drag-handler-not-in-editing"),null==d?(b.attr("hammer-dragstart","onDragStart($event)"),b.attr("hammer-drag","onDrag($event)"),b.attr("hammer-dragend","onDragEnd($event)")):void 0},post:function(b,c){return a(c)(b)}}}}}])}.call(this),function(){"use strict";var a;a=angular.module("triton.infrastructure",[]),a.directive("tnTransitionEnd",[function(){return{restrict:"AC",link:function(a,b){return b.on("webkitTransitionEnd transitionend msTransitionEnd oTransitionEnd","*",function(a){return angular.element(this).trigger("tnTransitionEnd",a),a.stopPropagation()})}}}]),a.factory("tnLinkRedirecter",[function(){return{redirectURI:function(a){var b;return b=encodeURIComponent('<html lang="utf-8">\n<head><meta http-equiv="Refresh" Content="0; Url='+a+'" /></head>\n<body></body>\n</html>'),"data:text/html;charset=utf-8,"+b},redirectWeiboURI:function(a){return"http://api.weibo.com/t_short_url?outUrl="+encodeURIComponent(a)}}}]),a.directive("tnCommodityLink",["$document","tnLinkRedirecter",function(a,b){return{restrict:"A",link:function(a,c,d){return c.attr("href","#"),d.$observe("sellLink",function(d){var e,f,g,h,i,j;if(d)return a.wbLink=b.redirectWeiboURI(d),e=-1!==d.indexOf("taobao.com")||-1!==d.indexOf("tmall.com"),e&&c.attr("href",b.redirectURI(d)),h=angular.element(".item-sell-link-prompt").hide(),g=2e3,f=800,i=function(){return h.fadeIn(f,function(){return setTimeout(function(){return h.fadeOut(f)},g)})},j=window.navigator.userAgent,/weibo/i.test(j)?c.attr("href",a.wbLink):/micromessenger/i.test(j)&&e?h?c.on("click",function(a){return a.preventDefault(),i()}):void 0:c.attr("href",d)})}}}]),a.directive("tnGaEvent",["$document",function(a){return{restrict:"A",link:function(b,c,d){return c.on("click",function(){var b;return b=d.tnGaEvent,"undefined"!=typeof ga&&null!==ga?ga("send","event","\u5355\u54c1\u79c0",""+a.find("title").text(),b):void 0})}}}]),a.directive("tnStyle",[function(){return{restrict:"A",link:function(a,b,c){return a.$watch(c.tnStyle,function(a,c){var d,e;if(d=null!=c&&a!==c)for(e in c)b.css(e,"");return a?b.css(a):void 0},!0)}}}]),a.factory("messageCenter",["$timeout",function(a){var b,c;return b=null,c={tipsText:"",showTips:!1,levelClass:"alert-warning"},{messages:function(){return c},pushMessage:function(d,e,f){return null==e&&(e="warning"),null==f&&(f=2e3),b&&a.cancel(b),c.tipsText=d,c.showTips=!0,c.levelClass="alert-"+e,b=a(function(){return c.tipsText="",c.showTips=!1,c.levelClass="alert-warning",b=null},f)}}}]),a.factory("authManager",["$rootScope","$sce","$http","$window","$timeout","$log",function(a,b,c,d,e,f){var g,h,i,j,k,l,m;return g="/auth",h=b.trustAsResourceUrl("about:blank"),j={loadingUserInfo:!1,signingIn:!1,signingOut:!1,userInfo:null},i={signInFrameSrc:h},k=function(a){return{nickname:a.nickname,avatarUrl:b.trustAsUrl(a.avatar_url),auth_type:a.auth_type,level:a.level,levelLimit:a.levelLimit,oemCustomer:a.oemCustomer}},m=function(a){return i.signInFrameSrc=h,j.userInfo=k(a)},l=function(){return i.signInFrameSrc=h,j.userInfo=null},{authStatus:function(){return j},authBinding:function(){return i},isUserReady:function(){return null!=j.userInfo},loadUser:function(a){return j.loadingUserInfo=!0,c.get("/auth/me").then(function(b){var c;return c=b.data,m(c.data.user),"function"==typeof a?a(null,j.userInfo):void 0})["catch"](function(b){return"function"==typeof a?a(b):void 0})["finally"](function(){return i.signInFrameSrc=h,j.loadingUserInfo=!1})},signIn:function(b){return j.signingIn=!0,d.tn_auth_sign_in_result=function(c){return d.tn_auth_sign_in_result=void 0,a.$apply(function(){return 0===c.code?(m(c.data.user),"function"==typeof b&&b(null,j.userInfo)):(l(),"function"==typeof b&&b(Error("sign in failed"))),j.signingIn=!1})},i.signInFrameSrc=g},signOut:function(a){return j.signingOut=!0,c.get("/auth/logout").then(function(){return"function"==typeof a?a(null,null):void 0})["catch"](function(b){return f.error("sign.out: error",b),"function"==typeof a?a(b,null):void 0})["finally"](function(){return l(),j.signingOut=!1})}}}])}.call(this),window._MountWXShare=function(){function a(){WeixinJSBridge.invoke("sendAppMessage",{appid:d.appid,img_url:d.img,img_width:d.width,img_height:d.height,link:d.url,desc:d.desc,title:d.title},function(a){_report("send_msg",a.err_msg)})}function b(){WeixinJSBridge.invoke("shareTimeline",{img_url:d.img,img_width:d.width,img_height:d.height,link:d.url,desc:d.desc,title:d.title},function(a){_report("timeline",a.err_msg)})}function c(){WeixinJSBridge.invoke("shareWeibo",{content:d.desc,url:d.url},function(a){_report("weibo",a.err_msg)})}var d={};window._WXShare2=function(a,b,c,e,f,g,h,i,j,k){d.img=a||$("meta[name='wx-image']").attr("content")||"",d.width=b||120,d.height=c||120,d.title=e||$("meta[name='wx-title']").attr("content")||document.title,d.desc=f||$("meta[name='wx-desc']").attr("content"),d.url=j||document.location.href,d.appid=k||"wxfae5a1b61337030e",d.timestamp=g||"",d.nonceStr=h||"",d.signature=i||"",wx.config({debug:!1,appId:d.appid,timestamp:d.timestamp,nonceStr:d.nonceStr,signature:d.signature,jsApiList:["checkJsApi","onMenuShareTimeline","onMenuShareAppMessage","onMenuShareQQ","onMenuShareWeibo"]}),wx.ready(function(){wx.checkJsApi({jsApiList:["onMenuShareTimeline","onMenuShareAppMessage","onMenuShareQQ","onMenuShareWeibo"],success:function(){wx.onMenuShareAppMessage({title:d.title,desc:d.desc,link:d.url,imgUrl:d.img}),wx.onMenuShareTimeline({title:d.title,link:d.url,imgUrl:d.img}),wx.onMenuShareQQ({title:d.title,desc:d.desc,link:d.url,imgUrl:d.img}),wx.onMenuShareWeibo({title:d.title,desc:d.desc,link:d.url,imgUrl:d.img})}})}),wx.error(function(a){console.error("wx.config error",a)})},document.addEventListener("WeixinJSBridgeReady",function(){WeixinJSBridge.on("menu:share:appmessage",function(){a()}),WeixinJSBridge.on("menu:share:timeline",function(){b()}),WeixinJSBridge.on("menu:share:weibo",function(){c()})},!1)},function(){"use strict";var a,b;a=angular.module("triton.xiumi.reader.board",["ngAnimate","triton.directives","triton.infrastructure","triton.editablePage","triton.xiumi.templates.parts"]),a.constant("globalConstants",window.globalConstants),b=function(a){return"function"==typeof _WXShare2?_WXShare2(a.cover||"",120,120,a.title||"\u6211\u7684\u56fe\u6587",a.desc||"\u6211\u7684\u56fe\u6587",window.globalConstants.wxSign.timestamp,window.globalConstants.wxSign.nonceStr,window.globalConstants.wxSign.signature):void 0},a.controller("BoardDeskController",["$scope","$window","$document","$timeout","globalConstants",function(a,c,d,e,f){var g,h,i;return a.showInfo=f.showInfo,a.templateRootPath=f.tplPath,i=angular.element('<script type="text/javascript" src="'+a.showInfo.show_data_url+'"></script>'),jQuery("body").append(i),g=function(){return delete c.tn_show_data_result},h=function(c){return g(),i.remove(),b(c),a.$apply(function(){return a.showData=c,a.slices=a.showData.pages})},c.tn_show_data_result=function(a){return e(function(){return h(a)})}}])}.call(this),function(){"use strict";var a,b,c;if(window.angular){if(a="tn-launch-app",b=angular.element("["+a+"]"),c=b.attr(a),!c)return;b.ready(function(){return angular.bootstrap(b,[c])})}}.call(this);var _hmt=_hmt||[];!function(){var a=document.createElement("script");a.src="//hm.baidu.com/hm.js?ffe6968809d7872701e07ea21cce5427";var b=document.getElementsByTagName("script")[0];b.parentNode.insertBefore(a,b)}();