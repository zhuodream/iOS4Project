//
//  ZYXDrawViewController.m
//  ZYXTouchTracker
//
//  Created by 卓酉鑫 on 16/3/16.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXDrawViewController.h"
#import "ZYXDrawView.h"

@interface ZYXDrawViewController ()

@end

@implementation ZYXDrawViewController

- (void)loadView
{
    self.view = [[ZYXDrawView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
