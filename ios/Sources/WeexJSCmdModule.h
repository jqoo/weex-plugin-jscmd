//
//  WeexJSCmdModule.h
//  WeexPluginTemp
//
//  Created by 齐山 on 17/3/14.
//  Copyright © 2017年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>
#import <WeexSDK/WXModuleProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class WeexJSCmdModule;

@protocol WXJSCmdInstanceProtocol <NSObject>

- (void)bindJSCmdModule:(WeexJSCmdModule *)module;

@end

@interface WeexJSCmdModule : NSObject <WXModuleProtocol>

// export to native
- (void)eval:(NSString *)cmd args:(NSDictionary *)args completion:(void (^)(NSDictionary *error, NSDictionary *))completion;

@end

NS_ASSUME_NONNULL_END
