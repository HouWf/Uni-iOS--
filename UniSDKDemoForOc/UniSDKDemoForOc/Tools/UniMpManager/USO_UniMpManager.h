//
//  USO_UniMpManager.h
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/22.
//

// 小程序管理模块
#import <Foundation/Foundation.h>
#import "USO_UniDataManager.h"
#import "DBManager.h"
#import "DCUniMP.h"

#import "USO_UniMpManagerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface USO_UniMpManager : NSObject

singleton_interface(USO_UniMpManager)

@property (nonatomic, weak) id<USO_UniMpManagerDelegate> delegate;

//设置小程序菜单栏
- (void)setUniMPMenuItems:(NSArray<NSDictionary *> *)items;

/// 检查运行目录是否存在应用资源，不存在将应用资源部署到运行目录
/// @param appid 应用id
/// @param path 路径，如果传空，则自动检索本地wgt文件
- (BOOL)checkUniMPResource:(NSString *)appid path:(NSString *)path;

/// 预加载后打开小程序
/// @param appid 小程序id
/// @param immediately 是否立即打开
/// @param redirectPath 打开小程序的目标路径，默认打开首页
/// @param complated 回调
- (void)preloadUniMP:(NSString *)appid openImmediately:(BOOL)immediately  redirectPath:(NSString *)redirectPath  completed:(void(^)(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error))complated;

/// 打开小程序
/// @param appid 小程序id
/// @param redirectPath 打开小程序的目标路径，默认打开首页
/// @param complated 回调
- (void)openUniMP:(NSString *)appid  redirectPath:(NSString *)redirectPath  completed:(void(^)(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error))complated;

/// 隐藏小程序
- (void)hideUniMP;

/// 显示小程序
- (void)showUniMP;

/// 关闭小程序
- (void)closeUniMP;

/// 发送指令到小程序
- (void)sendUniMPEvent:(NSString *)event data:(id __nullable)data;

/// 隐藏胶囊按钮 只支持全局隐藏
/// @param hidden 是否隐藏
- (void)setMenuButtonHidden:(BOOL)hidden;

/// 小程序打开状态，调用此方法可获取小程序对应的 ViewController 实例
- (UIViewController *)getUniMPViewController;

/// 获取当前小程序页面的直达链接url
- (NSString *)getCurrentPageUrl;

/// 获取当前运行的小程序appid
- (NSString *)getActiveUniMPAppid;

/// 在显示系统导航栏的页面 push 进入小程序页面，从小程序页面 push 到其他原生页面时需要隐藏系统导航栏，则可以在跳转页面前调用此方法来处理；
/// 注意：只有通过 DCUniMPOpenModePush 的方式打开小程序才生效
/// @param hidden 是否隐藏
- (void)whenUniMPCloseSetNavigationBarHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
