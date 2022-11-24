//
//  TostaObject.h
//  AutoLayoutForCell
//
//  Created by hzhy001 on 2018/5/11.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TostaObject : NSObject

+ (void) makeToast:(NSString *) toast;
+ (void) makeToast:(NSString *)toast duration:(NSTimeInterval) duration;


+ (instancetype)make:(NSString *)text;
- (TostaObject *)bottom;
- (TostaObject *)top;
- (TostaObject *)center;
- (TostaObject *(^)(CGFloat))yOffset;
- (TostaObject *(^)(NSTimeInterval))duration;
- (void)toast;


@end
