//
//  ZYXColorDescription.m
//  ZYXColorboard
//
//  Created by 卓酉鑫 on 16/4/15.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXColorDescription.h"

@implementation ZYXColorDescription

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _color = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        _name = @"Blue";
    }
    
    return self;
}


@end
