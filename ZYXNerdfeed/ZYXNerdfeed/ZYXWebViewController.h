//
//  ZYXWebViewController.h
//  ZYXNerdfeed
//
//  Created by 卓酉鑫 on 16/4/12.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYXWebViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *title;

@end
