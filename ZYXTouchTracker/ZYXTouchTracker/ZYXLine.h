//
//  ZYXLine.h
//  ZYXTouchTracker
//
//  Created by 卓酉鑫 on 16/3/16.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYXLine : NSObject<NSCoding>

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

- (void)saveAllActiveLine;

@end
