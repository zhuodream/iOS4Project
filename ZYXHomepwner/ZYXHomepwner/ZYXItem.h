//
//  ZYXItem.h
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/4/13.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYXItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

#import "ZYXItem+CoreDataProperties.h"
