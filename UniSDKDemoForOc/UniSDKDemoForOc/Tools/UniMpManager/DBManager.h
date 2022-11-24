//
//  DBManager.h
//  App
//
//  Created by 张杨 on 2019/11/22.
//

// 小程序数据库
#import <Foundation/Foundation.h>
#import "USO_GSGztModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

+ (instancetype)shareManager;

/**
 创建Table
 */
- (void)createTable;


/**根据小程序唯一ID查询*/
- (USO_GSGztModel *)searchUniApModelWithUniAppId:(NSString *)uniAppId;

/**插入小程序信息*/
- (void)insertUniAppModel:(USO_GSGztModel *)model;

/**更新小程序信息*/
- (void)updateUniApModelWithUniAppId:(USO_GSGztModel *)model;

/**
 清空所有缓存数据
 */
- (void)clearAll;


@end

NS_ASSUME_NONNULL_END
