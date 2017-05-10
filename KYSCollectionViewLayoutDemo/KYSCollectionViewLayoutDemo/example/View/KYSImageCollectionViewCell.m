//
//  KYSImageCollectionViewCell.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/2.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSImageCollectionViewCell.h"

@interface KYSImageCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation KYSImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.borderWidth = 4;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.cornerRadius = 7;
    self.imageView.layer.masksToBounds = YES;
}

- (void)setImageName:(NSString *)imageName{
    _imageName=imageName;
    self.imageView.image=[UIImage imageNamed:imageName];
}

@end
