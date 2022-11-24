//
//  NetWorkDownLoadManager.m
//  TCStaticSDK_Demo
//
//  Created by hzhy001 on 2018/1/26.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import "NetWorkDownLoadManager.h"

@implementation NetWorkDownLoadManager
+ (instancetype)getInstance
{
    static NetWorkDownLoadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        manager.serializer = [AFHTTPRequestSerializer serializer];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self getInstance];
}

/**
 根据url判断是否已经保存到本地了
 */
- (BOOL)isSavedFileToLocalWithCreated:(UInt32)created fileName:(NSString *)fileName
{
    // 判断是否已经离线下载了
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d/%@", @"downLoad", created, fileName]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

/**
 根据文件的创建时间 设置保存到本地的路径
 */
-(NSString *)setPathOfDocumentsByFileCreated:(UInt32)created fileName:(NSString *)fileName
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d", @"downLoad", created]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:path]) {
        [filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/**
 根据文件类型、名字、创建时间获得本地文件的路径，当文件不存在时，返回nil
 */
- (NSURL *)getLocalFilePathWithFileName:(NSString *)fileName fileCreated:(UInt32)created
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d", @"downLoad", created]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *fileList = [filemanager subpathsOfDirectoryAtPath:path error:nil];
    
    if ([fileList containsObject:fileName]) {
        NSString *fileUrltemp = [NSString stringWithFormat:@"%@/%@", path, fileName];
        NSURL *url = [NSURL fileURLWithPath:fileUrltemp];
        return url;
    }
    return nil;
}

- (void)downloadWithFileUrl:(NSString *)requestURL
                   fileName:(NSString *)fileName
                fileCreated:(UInt32)created
           downloadComplate:(void (^)(NSURLResponse *response, NSError *error))complateBlock
                   progress:(void (^)(NSProgress *downloadProgress))progress{
    //沙盒路径
    NSString *localSavePath = [NSString stringWithFormat:@"%@/%@", [self setPathOfDocumentsByFileCreated:created fileName:fileName], fileName];
    //创建传话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    _downLoadOperation = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:localSavePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (complateBlock) {
            complateBlock(response,error);
        }
    }];
    [_downLoadOperation resume];
}

- (void)downloadWithFileUrl:(NSString *)requestURL
                   filePath:(NSString *)filePath
           downloadComplate:(void (^)(NSURLResponse *response, NSError *error))complateBlock
                   progress:(void (^)(NSProgress *downloadProgress))progress{
    //创建传话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    manager.securityPolicy = securityPolicy;
    
    _downLoadOperation = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (complateBlock) {
            complateBlock(response,error);
        }
    }];
    [_downLoadOperation resume];
}


/**
 取消下载，并删除本地已经下载了的部分
 */
- (void)cancleDownLoadFileWithServiceCreated:(UInt32)created fileName:(NSString *)fileName;
{
    [_downLoadOperation cancel];
    
    // 删除本地文件
    NSString *localSavePath = [NSString stringWithFormat:@"%@/%@", [self setPathOfDocumentsByFileCreated:created fileName:fileName], fileName];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:localSavePath]) {
        [filemanager removeItemAtPath:localSavePath error:nil];
    }
}

/**
 正在下载中
 */
- (NSURLSessionTaskState)isDownLoadExecuting
{
    return [_downLoadOperation state];
}

/**
 下载暂停
 */
- (void)downLoadPause
{
    [_downLoadOperation suspend];
}

/**
 下载继续
 */
- (void)downLoadResume
{
    [_downLoadOperation resume];
}

@end
