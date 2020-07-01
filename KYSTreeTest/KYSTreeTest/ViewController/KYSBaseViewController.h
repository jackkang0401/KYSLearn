//
//  KYSBaseViewController.h
//  KYSTreeTest
//
//  Created by yongshuai.kang on 2020/7/1.
//  Copyright © 2020 kkk.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYSBaseViewController : UIViewController

@property(nonatomic,strong,readonly)NSArray *baseDataArray;

// 子类覆写
- (void)clickIndex:(NSInteger)index content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
