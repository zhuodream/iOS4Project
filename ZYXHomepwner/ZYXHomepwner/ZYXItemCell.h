//
//  ZYXItemCell.h
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/4/7.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYXItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic, copy) void (^actionBlock)(void);

@end
