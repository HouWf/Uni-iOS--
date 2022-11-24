//
//  AppDelegate.m
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/22.
//

#import "AppDelegate.h"
#import "DCUniMP.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self loadUniMPSDK];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    UIViewController *vc = [[NSClassFromString(@"ViewController") alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)loadUniMPSDK{
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    options[@"debug"] = @(YES);
    [DCUniMPSDKEngine initSDKEnvironmentWithLaunchOptions:options];
}

#pragma  mark - App 生命周期
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [DCUniMPSDKEngine applicationDidBecomeActive:application];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [DCUniMPSDKEngine applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [DCUniMPSDKEngine applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [DCUniMPSDKEngine applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application{
    [DCUniMPSDKEngine destory];
}

#pragma mark - url scheme
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [DCUniMPSDKEngine application:app openURL:url options:options];
    return  YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    [DCUniMPSDKEngine application:application continueUserActivity:userActivity];
    return  YES;
}

@end
