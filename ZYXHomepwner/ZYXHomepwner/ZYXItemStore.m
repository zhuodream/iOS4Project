//
//  ZYXItemStore.m
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/3/1.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXItemStore.h"
#import "ZYXItem.h"
#import "ZYXImageStore.h"

@interface ZYXItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation ZYXItemStore

+ (instancetype)sharedStore
{
    static ZYXItemStore *sharedStore = nil;
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ZYXItemStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (ZYXItem *)createItem
{
    ZYXItem *item = [ZYXItem randomItem];
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(ZYXItem *)item
{
    NSString *key = item.itemKey;
    [[ZYXImageStore sharedStore] deleteImageForKey:key];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    ZYXItem *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}
@end
