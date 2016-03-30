//
//  ZYXImageStore.h
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/3/15.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYXImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
