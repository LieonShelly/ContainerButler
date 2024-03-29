//
//  UIButton+CountDown.m
//  TeHuiNong
//
//  Created by Seven-Augus on 2016/10/25.
//  Copyright © 2016年 com.huaiyi.TeHuiN. All rights reserved.
//

#import "UIButton+CountDown.h"

@implementation UIButton (CountDown)

- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle normalColor:(UIColor *)normalColor countColor:(UIColor *)countColor {
    
    // 倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitleColor:normalColor forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        } else {
            NSInteger seconds = timeOut;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitleColor:countColor forState:UIControlStateNormal];
                [self setTitle:[NSString stringWithFormat:@"%@%@", timeStr, subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
