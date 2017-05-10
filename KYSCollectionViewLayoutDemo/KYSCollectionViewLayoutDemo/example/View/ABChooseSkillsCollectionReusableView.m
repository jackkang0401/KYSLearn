//
//  ABChooseSkillsCollectionReusableView.m
//  flashServes
//
//  Created by Liu Zhao on 16/3/17.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABChooseSkillsCollectionReusableView.h"

@implementation ABChooseSkillsCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        _titleLabel=[[UILabel alloc] init];
        CGFloat space = 12.0*([UIScreen mainScreen].bounds.size.width/375.0);
        _titleLabel.frame=CGRectMake(space, 0, self.frame.size.width, self.frame.size.height);
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.textColor=[UIColor darkGrayColor];
        _titleLabel.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:_titleLabel];
    }
    return self;
}


@end
