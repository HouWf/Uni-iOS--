//
//  NetWorkDownLoadManager.h
//  TCStaticSDK_Demo
//
//  Created by hzhy001 on 2018/1/26.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorkDownLoadManager : NSObject

@property (nonatomic, strong) AFHTTPRequestSerializer *serializer;
@property (nonatomic, strong) NSURLSessionDownloadTask *downLoadOperation;


/**
 单例
 * 多任务可不用单例
 @return 对象
 */
+ (instancetype)getInstance;

#pragma mark -下载文件
/**
 根据url判断是否已经保存到本地了
 
 @param created 文件的创建时间  通过和fileName拼接成完整的文件路径
 @param fileName 文件的名字
 @return YES：本地已经存在，NO：本地不存在
 */
- (BOOL)isSavedFileToLocalWithCreated:(UInt32)created
                             fileName:(NSString *)fileName;

/**
 根据文件的创建时间 设置保存到本地的路径
 @param created  创建时间
 @param fileName 名字
 @return return value description
 */
-(NSString *)setPathOfDocumentsByFileCreated:(UInt32)created
                                    fileName:(NSString *)fileName;

/**
 根据文件类型、名字、创建时间获得本地文件的路径，当文件不存在时，返回nil
 @param fileName 文件名字
 @param created  文件在服务器创建的时间
 */
- (NSURL *)getLocalFilePathWithFileName:(NSString *)fileName
                            fileCreated:(UInt32)created;

/**
 @brief 下载文件
 @param requestURL 下载的url
 @param fileName   文件名字
 @param created    文件服务器创建时间
 */
- (void)downloadWithFileUrl:(NSString *)requestURL
                      fileName:(NSString *)fileName
                   fileCreated:(UInt32)created
               downloadComplate:(void (^)(NSURLResponse *response, NSError *error))complateBlock
                       progress:(void (^)(NSProgress *downloadProgress))progress;

- (void)downloadWithFileUrl:(NSString *)requestURL
                   filePath:(NSString *)filePath
           downloadComplate:(void (^)(NSURLResponse *response, NSError *error))complateBlock
                   progress:(void (^)(NSProgress *downloadProgress))progress;

/**
 取消下载，并删除本地已经下载了的部分
 @param created  文件在服务器创建的时间
 @param fileName 文件的名字
 */
- (void)cancleDownLoadFileWithServiceCreated:(UInt32)created
                                    fileName:(NSString *)fileName;

/**
 下载状态
 @return NSURLSessionTaskState
 */
- (NSURLSessionTaskState)isDownLoadExecuting;

/**
 下载暂停
 */
- (void)downLoadPause;

/**
 下载继续
 */
- (void)downLoadResume;

@end
