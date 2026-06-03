// 云闪付滑块验证绕过
// Hook WKWebView didFinishNavigation 注入自动滑块JS
#import <WebKit/WebKit.h>
#import <substrate.h>

static void (*orig_didFinish)(id, SEL, id, id);

static void hook_didFinish(id self, SEL _cmd, WKWebView *webView, id navigation) {
    orig_didFinish(self, _cmd, webView, navigation);
    
    // 注入自动完成滑块的JavaScript
    NSString *js = @"\
(function(){\
    var c=0;\
    var iv=setInterval(function(){\
        var s=document.querySelector('.slider-btn') || document.querySelector('[class*=\"slide\"]') || document.querySelector('[class*=\"slider\"]');\
        var t=document.querySelector('.slider-track') || document.querySelector('[class*=\"track\"]');\
        if(s && t && ++c<10){\
            var d=parseInt(s.getAttribute('data-dist')||s.style.left||'0');\
            if(!d){\
                var r=s.getBoundingClientRect();\
                var tr=t.getBoundingClientRect();\
                d=tr.width-r.width;\
            }\
            var x=s.getBoundingClientRect().x;\
            var y=s.getBoundingClientRect().y+s.getBoundingClientRect().height/2;\
            var ev1=new PointerEvent('pointerdown',{clientX:x,clientY:y,bubbles:true}); s.dispatchEvent(ev1);\
            for(var i=0;i<d;i+=5){\
                var ev2=new PointerEvent('pointermove',{clientX:x+i,clientY:y,bubbles:true}); document.dispatchEvent(ev2);\
            }\
            var ev3=new PointerEvent('pointerup',{clientX:x+d,clientY:y,bubbles:true}); document.dispatchEvent(ev3);\
            clearInterval(iv);\
        }else if(c>=10){clearInterval(iv);}\
    },800);\
})();";
    
    [webView evaluateJavaScript:js completionHandler:nil];
}

__attribute__((constructor))
static void init() {
    // Hook WKNavigationDelegate
    Class wkNav = NSClassFromString(@"WKWebView");
    // Hook the delegate method
    MSHookMessageEx(
        NSClassFromString(@"WKWebView"),
        @selector(webView:didFinishNavigation:),
        (IMP)&hook_didFinish,
        (IMP*)&orig_didFinish
    );
}
