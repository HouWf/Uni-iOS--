//
//  USO_UniDataManager.m
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/22.
//

#import "USO_UniDataManager.h"
#import "NetWorkDownLoadManager.h"
#import "MBProgressHUD.h"

@interface USO_UniDataManager ()

@property (nonatomic, copy) KeepAliveCallback callBack;

@property (nonatomic, strong) MBProgressHUD *downLoadHud;

@end

@implementation USO_UniDataManager

- (void)onUniMPEventReceive:(NSString *)event data:(id)data callback:(KeepAliveCallback)callback{
    NSLog(@"收到小程序调用方法 event：%@  data：%@", event, data);
    self.callBack = callback;
    self.callBack(@"收到拉", NO);
}

- (void)downloadWithUrl:(NSString *)url uniMp:(NSString *)appid complate:(DownloadCallback)callback{
    NSString *fileName = appid;
    if (![fileName containsString:@".wgt"]) {
        fileName = [NSString stringWithFormat:@"%@.wgt", appid];
    }
    if (!self.downLoadHud) {
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        self.downLoadHud = [[MBProgressHUD alloc] initWithView:window];
        self.downLoadHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    }
    
    [self.downLoadHud showAnimated:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = paths[0];
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    
    __weak typeof(self) weakSelf = self;
    [[NetWorkDownLoadManager getInstance] downloadWithFileUrl:@"" filePath:filePath downloadComplate:^(NSURLResponse *response, NSError *error) {
        if (weakSelf.downLoadHud) {
            self.downLoadHud.hidden = YES;
            [self.downLoadHud removeFromSuperview];
            self.downLoadHud = nil;
        }
        callback(filePath, error);
        
        } progress:^(NSProgress *downloadProgress) {
            NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
            if (self.downLoadHud) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.downLoadHud.progress = downloadProgress.fractionCompleted;
                    self.downLoadHud.label.text = [NSString stringWithFormat:@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100];
                });
            }
        }];
}

@end
