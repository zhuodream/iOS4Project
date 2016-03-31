//
//  ZYXLine.m
//  ZYXTouchTracker
//
//  Created by 卓酉鑫 on 16/3/16.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXLine.h"

#define BEGINPOINT @"beginPoint"
#define ENDPOINT @"endPoint"

@implementation ZYXLine

- (instancetype)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];
    if (self)
    {
        self.begin = [aCoder decodeCGPointForKey:BEGINPOINT];
        self.end = [aCoder decodeCGPointForKey:ENDPOINT];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGPoint:self.begin forKey:BEGINPOINT];
    [aCoder encodeCGPoint:self.end forKey:ENDPOINT];
}


@end
