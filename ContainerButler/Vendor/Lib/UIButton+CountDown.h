//
//  UIButton+CountDown.h
//  TeHuiNong
//
//  Created by Seven-Augus on 2016/10/25.
//  Copyright © 2016年 com.huaiyi.TeHuiN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CountDown)

- (void)startWithTime:(NSInteger)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
            normalColor:(UIColor *)normalColor
           countColor:(UIColor *)countColor;

@end
