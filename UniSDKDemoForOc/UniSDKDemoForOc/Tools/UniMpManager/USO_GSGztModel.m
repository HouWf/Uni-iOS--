//
//  USO_GSGztModel.m
//  UniSDKDemoForOc
//
//  Created by 候文福 on 2022/9/23.
//

#import "USO_GSGztModel.h"

@implementation USO_GSGztModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (USO_GSGztModel *)setValueWithDic:(NSDictionary *)dic{
    USO_GSGztModel *model = [[USO_GSGztModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return  model;
}

@end
