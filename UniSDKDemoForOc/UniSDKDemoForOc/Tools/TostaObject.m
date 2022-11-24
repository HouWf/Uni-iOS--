//
//  TostaObject.m
//  AutoLayoutForCell
//
//  Created by hzhy001 on 2018/5/11.
//  Copyright © 2018年 hzhy001. All rights reserved.
//

#import "TostaObject.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSUInteger,TostaObjectPostion) {
    Center = 0,
    Bottom = 1,
    Top = 2
};


@interface TostaObject ()

@end

static NSMutableArray *toastWindowArray;
static CGFloat keyboardHeight;
@implementation TostaObject{
    NSString *_text;
    NSTimeInterval _duration;
    TostaObjectPostion _postion;
    CGFloat _offset;
}


+ (void)initialize{
    if(self == [TostaObject self]){
        toastWindowArray = [NSMutableArray array];
        
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *nt){
            keyboardHeight = [((NSValue *)nt.userInfo[UIKeyboardFrameEndUserInfoKey]) CGRectValue].size.height;
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *nt){
            keyboardHeight = 0;
        }];
        
    }
    
}

#pragma mark convenient

+ (void) makeToast:(NSString *) toast{
    [self makeToast:toast duration:2];
}
+ (void) makeToast:(NSString *)toast duration:(NSTimeInterval) duration{
    [[TostaObject make:toast].duration(duration) toast];
}


#pragma mark instanct public
+ (instancetype)make:(NSString *)text{
    TostaObject *toast = [[TostaObject alloc] init];
    [toast setText:text];
    return toast;
}

- (instancetype) init{
    if (self = [super init]) {
        _duration = 2;
        _offset   = 0;
        _postion  = Bottom;
    }
    return self;
}
- (TostaObject *)bottom{
    _postion = Bottom;
    return self;
}
- (TostaObject *)top{
    _postion = Top;
    return self;
}
- (TostaObject *)center{
    _postion = Center;
    return self;
}
- (TostaObject *(^)(CGFloat))yOffset{
    return ^TostaObject *(CGFloat offset){
        _offset = offset;
        return self;
    };
}
- (TostaObject *(^)(NSTimeInterval))duration{
    return ^TostaObject *(NSTimeInterval duration){
        _duration = duration;
        return self;
    };
}
- (void)toast{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text            = _text;
        label.font            = attr[NSFontAttributeName];
        label.textColor       = attr[NSForegroundColorAttributeName];
        label.backgroundColor = [UIColor colorWithRed:0.21 green:0.23 blue:0.24 alpha:1];
        label.textAlignment   = NSTextAlignmentCenter;
        label.numberOfLines   = 0;
        
        label.layer.cornerRadius  = 5;
        label.layer.masksToBounds = YES;
        label.layer.opacity       = 0.;
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        CGSize size = [label sizeThatFits:CGSizeMake(screenRect.size.width*.8, 50)];
        size.width += 30;
        size.height += 10;
        label.frame = CGRectMake(0, 0, size.width, size.height);
        CGRect windowFrame = CGRectMake((screenRect.size.width-size.width)*.5,
                                        (screenRect.size.height - size.height - 30),
                                        size.width,
                                        size.height);
        
        UIWindow *window = [[UIWindow alloc] initWithFrame:windowFrame];
        window.windowLevel = UIWindowLevelAlert;
        window.backgroundColor = [UIColor clearColor];
        window.hidden = NO;
        [window addSubview:label];
        [toastWindowArray addObject:window];
        CGFloat centerY = 0.f;
        switch (_postion) {
            case Center: {
                centerY = (screenRect.size.height - keyboardHeight) *.5 + _offset;
                break;
            }
            case Bottom: {
                centerY = (screenRect.size.height - keyboardHeight) - 44 - windowFrame.size.height*.5 + _offset;
                break;
            }
            case Top: {
                centerY = 64 + windowFrame.size.height*.5 + _offset;
                break;
            }
        }
        window.center = CGPointMake(screenRect.size.width*.5, centerY);
        
        
        [UIView animateWithDuration:0.25 animations:^{
            label.layer.opacity = 1.;
        }];
        
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(handleTap:)]];
        label.userInteractionEnabled = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideView:label];
        });
    });
}


#pragma mark private
- (void)setText:(NSString *)text{
    _text = text;
}

- (void) handleTap:(UITapGestureRecognizer*) gr{
    [self hideView:gr.view];
}

- (void) hideView:(UIView*) view{
    [UIView animateWithDuration:.25 animations:^{
        view.layer.opacity = .0;
    } completion:^(BOOL finish){
        UIWindow *window = view.superview;
        [view removeFromSuperview];
        [toastWindowArray removeObject:window];
    }];
}

@end
