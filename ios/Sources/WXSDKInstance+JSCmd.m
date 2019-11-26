//
//  WXSDKInstance+JSCmd.m
//  weex-plugin-jscmd
//
//  Created by jqoo on 2019/11/26.
//

#import "WXSDKInstance+JSCmd.h"
#import "WeexJSCmdModule.h"
#import <objc/runtime.h>

#import "WXWeakObjectWrapper.h"

static void *key_jq_jsCmd = &key_jq_jsCmd;

@interface WXSDKInstance (JSCmdImpl) <WXJSCmdInstanceProtocol>

@property (nonatomic, strong) WXWeakObjectWrapper *jq_jsCmd;

@end

@implementation WXSDKInstance (JSCmdImpl)

@dynamic jq_jsCmd;

- (void)bindJSCmdModule:(WeexJSCmdModule *)module {
    self.jq_jsCmd = [[WXWeakObjectWrapper alloc] initWithWeakObject:module];
}

- (void)setBf_jsCmd:(WXWeakObjectWrapper *)jsCmd {
    objc_setAssociatedObject(self, key_jq_jsCmd, jsCmd, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WXWeakObjectWrapper *)jq_jsCmd {
    return objc_getAssociatedObject(self, key_jq_jsCmd);
}

@end

@implementation WXSDKInstance (JSCmd)

- (void)jscmd_eval:(NSString *)cmd args:(NSDictionary *)args completion:(void (^)(NSDictionary *error, id data))completion {
    WeexJSCmdModule *jscmd = [self.jq_jsCmd weakObject];
    if (jscmd) {
        [jscmd eval:cmd args:args completion:completion];
    }
    else if (completion) {
        completion(@{@"code":@(-1), @"msg":@"cmd handler not registered"}, nil);
    }
}

@end
