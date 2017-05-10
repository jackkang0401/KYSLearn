//
//  NSString+KYSAddition.h
//  KYSKitDemo
//
//  Created by Liu Zhao on 16/2/22.
//  Copyright © 2016年 Kang YongShuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (KYSAddition)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

- (CGFloat)widthForFont:(UIFont *)font;

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

@end
