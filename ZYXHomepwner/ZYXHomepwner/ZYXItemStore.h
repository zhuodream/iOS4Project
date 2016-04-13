//
//  ZYXItemStore.h
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/3/1.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYXItem.h"

@interface ZYXItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;
+ (instancetype)sharedStore;
- (ZYXItem *)createItem;
- (void)removeItem:(ZYXItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (BOOL)saveChanges;
- (NSArray *)allAssetTypes;
@end
