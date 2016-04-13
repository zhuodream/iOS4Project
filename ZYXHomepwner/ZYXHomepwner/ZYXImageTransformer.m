//
//  ZYXImageTransformer.m
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/4/13.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXImageTransformer.h"

@implementation ZYXImageTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    if (!value)
    {
        return nil;
    }
    if ([value isKindOfClass:[NSData class]])
    {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
