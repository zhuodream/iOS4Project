//
//  ZYXItem.h
//  ZYXRandomItems
//
//  Created by 卓酉鑫 on 16/2/20.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZYXItem : NSObject <NSCoding>

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic, assign) int valueInDollars;
@property (nonatomic, strong, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;

//ZYXItem的指定初始化方法
- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNmuber:(NSString *)sNumber;
- (instancetype)initWithItemName:(NSString *)name;
- (void)setThumbnailFromImage:(UIImage *)image;

//中级练习
- (instancetype)initWithItemName:(NSString *)name serialNum:(NSString *)serialNum;

+ (instancetype)randomItem;



@end
