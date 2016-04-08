//
//  ZYXItemCell.m
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/4/7.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXItemCell.h"

@implementation ZYXItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock)
    {
        self.actionBlock();
    }
}

@end
