//
//  WXSDKInstance+JSCmd.h
//  weex-plugin-jscmd
//
//  Created by jqoo on 2019/11/26.
//

#import "WXSDKInstance.h"

@interface WXSDKInstance (JSCmd)

- (void)jscmd_eval:(NSString *)cmd args:(NSDictionary * _Nullable)args completion:(void (^)(NSDictionary *error, id data))completion;

@end
