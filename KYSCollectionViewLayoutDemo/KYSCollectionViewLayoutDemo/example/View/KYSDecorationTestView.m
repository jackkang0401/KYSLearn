//
//  KYSDecorationTestView.m
//  KYSCollectionViewLayoutDemo
//
//  Created by 康永帅 on 2017/5/4.
//  Copyright © 2017年 康永帅. All rights reserved.
//

#import "KYSDecorationTestView.h"

@implementation KYSDecorationTestView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        //设置背景色是没用的
        self.backgroundColor=[UIColor redColor];
        UIView *view=[[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor=[UIColor greenColor];
        [self addSubview:view];
        
        
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        btn.backgroundColor=[UIColor blueColor];
        [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)btnAction{
    NSLog(@"btn chick");
}

@end
