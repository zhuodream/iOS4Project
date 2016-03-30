//
//  ZYXContainer.m
//  ZYXRandomItems
//
//  Created by 卓酉鑫 on 16/2/21.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXContainer.h"

@interface ZYXContainer ()

@property (nonatomic, strong) NSMutableArray *mutableSubitems;

@end

@implementation ZYXContainer

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mutableSubitems = [NSMutableArray array];
        self.itemName = @"container";
        self.valueInDollars = 1;
        self.serialNumber = @"110";
        ZYXItem *item1 = [[ZYXItem alloc] initWithItemName:@"X" valueInDollars:10 serialNmuber:@"1"];
        ZYXItem *item2 = [[ZYXItem alloc] initWithItemName:@"Y" valueInDollars:20 serialNmuber:@"2"];
        ZYXItem *item3 = [[ZYXItem alloc] initWithItemName:@"Z" valueInDollars:30 serialNmuber:@"3"];
        [_mutableSubitems addObject:item1];
        [_mutableSubitems addObject:item2];
        [_mutableSubitems addObject:item3];
    }
    
    return self;
}

- (NSArray *)subitems
{
    _subitems = [_mutableSubitems copy];
    
    return _subitems;
}

- (void)addNewObject:(ZYXItem *)item
{
    [self.mutableSubitems addObject:item];
}

- (NSString *)description
{
    int totalValue = self.valueInDollars;
    NSString *itemDescription = @"";
    for (ZYXItem *item in self.mutableSubitems)
    {
        totalValue += item.valueInDollars;
        itemDescription = [itemDescription stringByAppendingString:[item description]];
    }
    NSString *descripionStr = [NSString stringWithFormat:@"ZYXContainer : %@, %d, %@", self.itemName, totalValue, itemDescription];
    
    return descripionStr;
}

@end
