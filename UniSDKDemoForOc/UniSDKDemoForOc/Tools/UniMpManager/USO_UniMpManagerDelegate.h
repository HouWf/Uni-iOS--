//
//  USO_UniMpManagerDelegate.h
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/23.
//

#import "USO_UniMpManagerDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@protocol USO_UniMpManagerDelegate <NSObject>
@optional

/// 返回打开小程序时的闪屏视图
/// @param appid appid
- (UIView *)splashViewForApp:(NSString *)appid;

/// 拦截胶囊`x`关闭按钮事件，注意：实现该方法后框架内不会执行关闭小程序的逻辑，需要宿主自行处理逻辑 （3.2.9+ 支持）
/// @param appid appid
- (void)hookCapsuleCloseButtonClicked:(NSString *)appid;

/// 拦截胶囊`···`菜单按钮事件，注意：实现该方法后框架内不会弹出actionSheet弹窗，需宿主自行处理逻辑 （3.2.9+ 支持）
/// @param appid appid
- (void)hookCapsuleMenuButtonClicked:(NSString *)appid;

// 3.3.7+支持
/// 胶囊按钮菜单 ActionSheetItem 点击回调方法
/// @param appid appid
/// @param identifier item 项的标识
- (void)defaultMenuItemClicked:(NSString *)appid identifier:(NSString *)identifier;

/// 小程序已关闭
/// @param appid appid
- (void)uniMPOnClose:(NSString *)appid;

/// 小程序向原生发送事件回调方法
/// @param appid 对应小程序的appid
/// @param event 事件名称
/// @param data 数据：NSString 或 NSDictionary 类型
/// @param callback 回调数据给小程序
- (void)onUniMPEventReceive:(NSString *)appid event:(NSString *)event data:(id)data callback:(DCUniMPKeepAliveCallback)callback;

///  监听关闭按钮点击
- (void)closeButtonClicked:(NSString *)appid;

@end
NS_ASSUME_NONNULL_END
