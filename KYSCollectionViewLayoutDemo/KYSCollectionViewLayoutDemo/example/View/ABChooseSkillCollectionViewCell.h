//
//  ABChooseSkillCollectionViewCell.h
//  flashServes
//
//  Created by Liu Zhao on 16/3/17.
//  Copyright © 2016年 002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABChooseSkillCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,assign)BOOL hasSelected;

- (void)setTitle:(NSString *)title;

@end
