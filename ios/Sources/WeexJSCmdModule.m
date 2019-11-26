//
//  WeexJSCmdModule.m
//  WeexPluginTemp
//
//  Created by  on 17/3/14.
//  Copyright © 2017年 . All rights reserved.
//

#import "WeexJSCmdModule.h"
#import <WeexPluginLoader/WeexPluginLoader.h>

@implementation WeexJSCmdModule
{
    int _nextCmdId;
    NSMutableDictionary *_completionMap;
    WXModuleKeepAliveCallback _cmdHandler;
}

WX_PlUGIN_EXPORT_MODULE(js-cmd, WeexJSCmdModule)

WX_EXPORT_METHOD(@selector(bindCmdHandler:))
WX_EXPORT_METHOD(@selector(setCmdResult:))

- (instancetype)init {
    self = [super init];
    if (self) {
        _completionMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// export to js:
- (void)bindCmdHandler:(WXModuleKeepAliveCallback)cmdHandler {
    _cmdHandler = cmdHandler;
    
    if ([self.weexInstance conformsToProtocol:@protocol(WXJSCmdInstanceProtocol)]) {
        [(id<WXJSCmdInstanceProtocol>)self.weexInstance bindJSCmdModule:self];
    }
}

// export to js:
// {id:123, data:{}}
- (void)setCmdResult:(NSDictionary *)result {
    int cmdId = [result[@"id"] intValue];
    void (^completion)(NSDictionary *error, NSDictionary *) = _completionMap[@(cmdId)];
    if (completion) {
        completion(result[@"error"], result[@"data"]);
        [_completionMap removeObjectForKey:@(cmdId)];
    }
}

// {id:,cmd:parse,args:{}}
- (void)eval:(NSString *)cmd args:(NSDictionary *)args completion:(void (^)(NSDictionary *error, NSDictionary *))completion {
    if (!_cmdHandler) {
        completion(@{@"code":@(-1), @"msg":@"cmd handler not registered"}, nil);
        return;
    }
    NSMutableDictionary *cmdObj = [[NSMutableDictionary alloc] init];
    int cmdId = _nextCmdId++;
    [cmdObj setObject:@(cmdId) forKey:@"id"];
    [cmdObj setObject:cmd forKey:@"cmd"];
    if (!args) {
        args = @{};
    }
    [cmdObj setObject:args forKey:@"args"];
    if (completion) {
        [_completionMap setObject:completion forKey:@(cmdId)];
    }
    _cmdHandler(cmdObj, YES);
}

@end
