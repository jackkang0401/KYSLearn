//
//  ABChooseSkillCollectionViewCell.m
//  flashServes
//
//  Created by Liu Zhao on 16/3/17.
//  Copyright © 2016年 002. All rights reserved.
//

#import "ABChooseSkillCollectionViewCell.h"
@interface ABChooseSkillCollectionViewCell()


@end

@implementation ABChooseSkillCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.layer.borderWidth=1.0;
    _titleLabel.layer.borderColor=[UIColor colorWithRed:255/255.0 green:168/255.0 blue:65/255.0 alpha:1].CGColor;
    _titleLabel.layer.cornerRadius=2.0;
    _titleLabel.layer.masksToBounds=YES;
}

- (void)setTitle:(NSString *)title{
    _titleLabel.font=[UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width>320?14:13];
    _titleLabel.text=title;
}

- (void)setHasSelected:(BOOL)hasSelected{
    if (hasSelected) {
        _titleLabel.backgroundColor=[UIColor colorWithRed:255/255.0 green:168/255.0 blue:65/255.0 alpha:1];
        _titleLabel.textColor=[UIColor whiteColor];
    }else{
        _titleLabel.backgroundColor=[UIColor whiteColor];
        _titleLabel.textColor=[UIColor colorWithRed:255/255.0 green:168/255.0 blue:65/255.0 alpha:1];
    }
    _hasSelected=hasSelected;
}

@end
