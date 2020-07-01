//
//  KYSBaseViewController.m
//  KYSTreeTest
//
//  Created by yongshuai.kang on 2020/7/1.
//  Copyright © 2020 kkk.cn. All rights reserved.
//

#import "KYSBaseViewController.h"

@interface KYSBaseViewController ()

@property(nonatomic,strong)NSMutableArray *textFieldArray;

@end

@implementation KYSBaseViewController

- (NSArray *)baseDataArray{
    return @[
        @{@"title":@"查   找",},
        @{@"title":@"插   入",},
        @{@"title":@"删   除",},
    ];
}

- (NSMutableArray *)textFieldArray{
    if (!_textFieldArray) {
        _textFieldArray = [[NSMutableArray alloc] init];
    }
    return _textFieldArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    CGFloat btnX = 30.f;
    CGFloat btnY = statusBarHeight + 44.f + 20.f;
    CGFloat btnWidth = 60.f;
    CGFloat btnHeight = 30.f;
    CGFloat textFieldX = btnX + btnWidth +20.f;
    CGFloat textFieldWidth = self.view.frame.size.width - btnX*2.f - btnWidth - 20.f;
    
    int i = 0;
    for (NSDictionary *dic in self.baseDataArray) {
        NSString *title = dic[@"title"];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)];
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, btnY, textFieldWidth, 30.f)];
        textField.backgroundColor = [UIColor lightGrayColor];
        textField.placeholder = @"请输入数字";
        textField.font = [UIFont systemFontOfSize:12.f];
        [self.view addSubview:textField];
        [self.textFieldArray addObject:textField];
        
        btnY += (btnHeight+10.f);
        i++;
    }
    
    
}

#pragma mark - Action

- (void)searchAction:(UIButton *)btn{
    NSInteger index = btn.tag;
    UITextField *textField = self.textFieldArray[index];
    NSString *content = [textField.text copy];
    textField.text = nil;
    [self clickIndex:index content:content];
}

- (void)clickIndex:(NSInteger)index content:(NSString *)content{
    
}


@end
