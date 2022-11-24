//
//  USO_UniMpManager.m
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/22.
//

#import "USO_UniMpManager.h"

@interface USO_UniMpManager() <DCUniMPSDKEngineDelegate>

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, weak) DCUniMPInstance *uniMPInstance; /**< 保存当前打开的小程序应用的引用 注意：请使用 weak 修辞，否则应在关闭小程序时置为 nil */

@end

@implementation USO_UniMpManager

static USO_UniMpManager *manager = nil;

singleton_implementation(USO_UniMpManager);

- (instancetype)init{
    if (self = [super init]) {
        [DCUniMPSDKEngine setDelegate:self];
    }
    return self;
}

//设置小程序菜单栏
- (void)setUniMPMenuItems:(NSArray<NSDictionary *> *)items{
    if (items.count == 0) {
        DCUniMPMenuActionSheetItem *item1 = [[DCUniMPMenuActionSheetItem alloc] initWithTitle:@"将小程序隐藏到后台" identifier:@"enterBackground"];
        DCUniMPMenuActionSheetItem *item2 = [[DCUniMPMenuActionSheetItem alloc] initWithTitle:@"关闭小程序" identifier:@"closeUniMP"];
        [DCUniMPSDKEngine setDefaultMenuItems:@[item1, item2]];
    }else{
        NSMutableArray *itemArray = [NSMutableArray  array];
        for (NSDictionary *dic in items) {
            DCUniMPMenuActionSheetItem *item = [[DCUniMPMenuActionSheetItem alloc] initWithTitle:dic[@"title"] identifier:dic[@"identifier"]];
            [itemArray addObject:item];
        }
        [DCUniMPSDKEngine setDefaultMenuItems:itemArray];
    }
}

// 获取配置信息
- (DCUniMPConfiguration *)getUniMPConfiguration{
    DCUniMPConfiguration *configuration = [[DCUniMPConfiguration alloc] init];
    // 配置启动小程序时传递的参数（参数可以在小程序中通过 plus.runtime.arguments 获取此参数）
    configuration.extraData = @{ @"arguments":@"Hello uni microprogram" };
    // 配置小程序启动后直接打开的页面路径 例：@"pages/component/view/view?action=redirect&password=123456"
    //    configuration.redirectPath = @"pages/component/view/view?action=redirect&password=123456";
    // 开启后台运行
    configuration.enableBackground = YES;
    // 设置 push 打开方式
    configuration.openMode = DCUniMPOpenModePush;
    // 启用侧滑手势关闭小程序
    configuration.enableGestureClose = YES;
    
    return configuration;
}

// 检查运行目录是否存在应用资源，不存在将应用资源部署到运行目录
- (BOOL)checkUniMPResource:(NSString *)appid path:(NSString *)path{
#warning  isExistsUniMP: 运行路径汇总是否有对应的资源，宿主还需要做好内置wgt版本的管理，如果更新了内置的wgt也应该执行 installUniMPResourceWithAppid 方法应用最新的资源
    NSString *appResourcePath = path;
    if (path.length == 0) {
        appResourcePath = [[NSBundle mainBundle] pathForResource:appid ofType:@"wgt"];
    }
    if (appResourcePath == nil || appResourcePath.length == 0) {
        NSLog(@"当前无小程序文件");
        return NO;
    }
//    TODO: 3.3.7+ 支持
    if(![DCUniMPSDKEngine isExistsUniMP:appid]){
        if (!appResourcePath) {
            NSLog(@"资源路径不正确");
            return NO;
        }
        NSError *error = nil;
        if ([DCUniMPSDKEngine installUniMPResourceWithAppid:appid resourceFilePath:appResourcePath password:nil error:&error]) {
            NSLog(@"应用资源文件部署--成功");
            return YES;
        }else{
            NSLog(@"应用资源文件部署--失败");
            return NO;
        }
    }
    
    NSLog(@"已存在小程序 %@ 应用资源，版本信息：%@",appid,[DCUniMPSDKEngine getUniMPVersionInfoWithAppid:appid]);
    return YES;
}

/// 预加载后打开小程序
- (void)preloadUniMP:(NSString *)appid openImmediately:(BOOL)immediately redirectPath:(NSString *)redirectPath completed:(void(^)(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error))complated{
    DCUniMPConfiguration *configuration = [self getUniMPConfiguration];
    configuration.path = redirectPath;
    
    __weak typeof(self) weakSelf = self;
    [DCUniMPSDKEngine preloadUniMP:appid configuration:configuration completed:^(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error) {
        complated(uniMPInstance, error);
        weakSelf.uniMPInstance = uniMPInstance;
        if (uniMPInstance && immediately) {
            [weakSelf showUniMP];
            weakSelf.appid = appid;
        } else {
            NSLog(@"预加载小程序出错：%@",error);
        }
    }];
}

// 启动小程序
- (void)openUniMP:(NSString *)appid  redirectPath:(NSString *)redirectPath  completed:(void(^)(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error))complated{
    DCUniMPConfiguration *configuration = [self getUniMPConfiguration];
    configuration.path = redirectPath;
    
    __weak typeof(self) weakSelf = self;
    [DCUniMPSDKEngine openUniMP:appid configuration:configuration completed:^(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error) {
        complated(uniMPInstance, error);
        weakSelf.uniMPInstance = uniMPInstance;
        weakSelf.appid = appid;
        if (error) {
            NSLog(@"打开小程序失败 %@", error);
        }
    }];
}

//发送指令到小程序
- (void)sendUniMPEvent:(NSString *)event data:(id __nullable)data{
    [self.uniMPInstance sendUniMPEvent:event data:data];
}

//隐藏胶囊按钮 只支持全局隐藏
-(void)setMenuButtonHidden:(BOOL)hidden{
    [DCUniMPSDKEngine setCapsuleButtonHidden:hidden];
}

// 隐藏小程序
- (void)hideUniMP{
    __weak __typeof(self)weakSelf = self;
    [self.uniMPInstance hideWithCompletion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"小程序 %@ 进入后台",weakSelf.uniMPInstance.appid);
        } else {
            NSLog(@"hide 小程序出错：%@",error);
        }
    }];
}

//关闭小程序
- (void)closeUniMP{
    __weak typeof(self) weakSelf = self;
    [self.uniMPInstance closeWithCompletion:^(BOOL success, NSError * _Nullable error) {
        weakSelf.appid = @"";
        if (success) {
            NSLog(@"小程序 closed");
        } else {
            [DCUniMPSDKEngine closeUniMP];
            NSLog(@"close 小程序出错：%@",error);
        }
    }];
}

// 显示小程序
- (void)showUniMP{
    [self.uniMPInstance showWithCompletion:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"show 小程序失败：%@",error);
        }
    }];
}

/// 小程序打开状态，调用此方法可获取小程序对应的 ViewController 实例
- (UIViewController *)getUniMPViewController{
    return [DCUniMPSDKEngine getUniMPViewController];
}

/// 获取当前运行的小程序appid
- (NSString *)getActiveUniMPAppid{
    NSString *appid = [DCUniMPSDKEngine getActiveUniMPAppid];
    if (appid.length == 0 || appid == nil) {
        appid = self.appid;
    }
    return appid;
}

/// 获取当前小程序页面的直达链接url
- (NSString *)getCurrentPageUrl{
    return [DCUniMPSDKEngine getCurrentPageUrl];
}

/// 在显示系统导航栏的页面 push 进入小程序页面，从小程序页面 push 到其他原生页面时需要隐藏系统导航栏，则可以在跳转页面前调用此方法来处理；
/// 注意：只有通过 push 的方式打开小程序才生效
/// @param hidden 是否隐藏
- (void)whenUniMPCloseSetNavigationBarHidden:(BOOL)hidden{
    [DCUniMPSDKEngine whenUniMPCloseSetNavigationBarHidden:hidden];
}

#pragma mark - DCUniMPSDKEngineDelegate
/// 拦截胶囊`x`关闭按钮事件，注意：实现该方法后框架内不会执行关闭小程序的逻辑，需要宿主自行处理逻辑
/// @param appid appid
- (void)hookCapsuleCloseButtonClicked:(NSString *)appid{
    [self closeUniMP];
    if ([self.delegate respondsToSelector:@selector(hookCapsuleMenuButtonClicked:)]) {
        [self.delegate hookCapsuleCloseButtonClicked:appid];
    }
}

/// 拦截胶囊`···`菜单按钮事件，注意：实现该方法后框架内不会弹出actionSheet弹窗，需宿主自行处理逻辑
/// @param appid appid
//- (void)hookCapsuleMenuButtonClicked:(NSString *)appid{
//    if ([self.delegate respondsToSelector:@selector(hookCapsuleMenuButtonClicked:)]) {
//        [self.delegate hookCapsuleMenuButtonClicked:appid];
//    }
//}

/// 胶囊按钮菜单 ActionSheetItem 点击回调方法
/// @param appid appid
/// @param identifier item 项的标识
- (void)defaultMenuItemClicked:(NSString *)appid identifier:(NSString *)identifier{
    NSLog(@"标识为 %@ 的 item 被点击了", identifier);
    // 将小程序隐藏到后台
    if ([identifier isEqualToString:@"enterBackground"]) {
        [self hideUniMP];
    }
    // 关闭小程序
    else if ([identifier isEqualToString:@"closeUniMP"]) {
        [self closeUniMP];
    }
    if ([self.delegate respondsToSelector:@selector(defaultMenuItemClicked:identifier:)]) {
        [self.delegate defaultMenuItemClicked:appid identifier:identifier];
    }
}

// 闪屏页
- (UIView *)splashViewForApp:(NSString *)appid{
    if ([self.delegate respondsToSelector:@selector(splashViewForApp:)]) {
        return [self.delegate splashViewForApp:appid];
    }else{
        UIView *splashView = [[[NSBundle mainBundle] loadNibNamed:@"SplashView" owner:self options:nil] lastObject];
        return splashView;
    }
}

// 关闭小程序
- (void)uniMPOnClose:(NSString *)appid{
    self.uniMPInstance = nil;
    self.appid = @"";
    if ([self.delegate respondsToSelector:@selector(uniMPOnClose:)]) {
        [self.delegate uniMPOnClose:appid];
    }
}

// 3.3.7+ 支持
/// 小程序向原生发送事件回调方法
/// @param appid 对应小程序的appid
/// @param event 事件名称
/// @param data 数据：NSString 或 NSDictionary 类型
/// @param callback 回调数据给小程序
- (void)onUniMPEventReceive:(NSString *)appid event:(NSString *)event data:(id)data callback:(DCUniMPKeepAliveCallback)callback
{
    if ([self.delegate respondsToSelector:@selector(onUniMPEventReceive:event:data:callback:)]) {
        [self.delegate onUniMPEventReceive:appid event:event data:data callback:callback];
    }else{
        USO_UniDataManager *dataManager = [[USO_UniDataManager alloc] init];
        [dataManager onUniMPEventReceive:event data:data callback:callback];
        
    }
}

///  监听关闭按钮点击
- (void)closeButtonClicked:(NSString *)appid {
    if ([self.delegate respondsToSelector:@selector(closeButtonClicked:)]) {
        [self.delegate closeButtonClicked:appid];
    }
}

@end
