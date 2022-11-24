//
//  USO_GSGztModel.h
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/23.
//

// 小程序数据对象
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USO_GSGztModel : NSObject

@property (strong, nonatomic) NSNumber *listId;
/**模块id*/
@property (copy, nonatomic) NSString *appId;
/**模块名*/
@property (copy, nonatomic) NSString *appName;
/**模块URL*/
@property (nonatomic, copy) NSString *fileUrl;
/**模块图标URL*/
@property (nonatomic, copy) NSString *logoId;
/**模块图标URL*/
@property (nonatomic, copy) NSString *logoURL;

@property (nonatomic, strong) NSNumber *type;
/**APP描述*/
@property (copy, nonatomic) NSString *appDesc;
/**APP版本号*/
@property (copy, nonatomic) NSString *version;
/**上次更新时间*/
@property (copy, nonatomic) NSString *lastUpdateBy;


@property (copy, nonatomic) NSString *iocnName;
@property (copy, nonatomic) NSString *uniAppId;

@property (copy, nonatomic) NSString *pre1;
/**0是新增，1是更新，2:最新版本*/
@property (nonatomic, strong) NSNumber *pre2;

@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *moduleId;

/**本地路径*/
@property (nonatomic, copy) NSString *localPath;

+ (USO_GSGztModel *)setValueWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
