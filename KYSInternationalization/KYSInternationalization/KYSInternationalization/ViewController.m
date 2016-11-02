//
//  ViewController.m
//  KYSInternationalization
//
//  Created by 康永帅 on 2016/10/31.
//  Copyright © 2016年 康永帅. All rights reserved.
//


/*
 当你发现，你改变了你的storyboard上面的控件之后，strings国际化文件没有变化，这确实是一个问题，目前有个解决办
 法是这样的。把你的新界面与现有的 MainStoryboard.strings 合并首先，启动“终端”应用程序。然后cd到项目文件夹
 的 Base.lproj 目录。例如：cd /Users/UserName/Projects/HelloWorld/HelloWorld/Base.lproj 在提示
 符后输入以下命令：ibtool MainStoryboard.storyboard --generate-strings-file New.strings
 */

/*
 NSLocalizedString 会读取 Localizable.strings 的内容
 NSLocalizedStringFromTable 会读取指定文件名的内容
 */


#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.testLabel.text = NSLocalizedStringFromTable(@"label.text",@"Internationalization",nil);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
