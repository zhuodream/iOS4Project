//
//  ZYXContainer.h
//  ZYXRandomItems
//
//  Created by 卓酉鑫 on 16/2/21.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

//高级练习
#import <Foundation/Foundation.h>
#import "ZYXItem.h"

@interface ZYXContainer : ZYXItem

@property (nonatomic, strong) NSArray *subitems;

- (void)addNewObject:(ZYXItem *)item;

@end
