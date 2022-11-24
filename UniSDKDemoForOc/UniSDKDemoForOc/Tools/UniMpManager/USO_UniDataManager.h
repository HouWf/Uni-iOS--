//
//  USO_UniDataManager.h
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/22.
//

// 小程序数据请求管理模块
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USO_UniDataManager : NSObject

typedef void (^KeepAliveCallback)(id result, BOOL keepAlive);
typedef void (^DownloadCallback)(id result, NSError *error);

// 处理接收到的数据
- (void)onUniMPEventReceive:(NSString *)event data:(id)data callback:(KeepAliveCallback)callback;

// 下载小程序
- (void)downloadWithUrl:(NSString *)url uniMp:(NSString *)appid complate:(DownloadCallback)callback;

@end

NS_ASSUME_NONNULL_END
