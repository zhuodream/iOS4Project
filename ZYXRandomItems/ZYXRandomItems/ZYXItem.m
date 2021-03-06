//
//  ZYXItem.m
//  ZYXRandomItems
//
//  Created by 卓酉鑫 on 16/2/20.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXItem.h"

@implementation ZYXItem

- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNmuber:(NSString *)sNumber
{
    self = [super init];
    
    //在初始化方法中直接设定属性的值，不使用存取方法
    if (self)
    {
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        
        _dateCreated = [[NSDate alloc] init];
    }
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNmuber:@""];
}

- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}

- (instancetype)initWithItemName:(NSString *)name serialNum:(NSString *)serialNum
{
    return [self initWithItemName:name valueInDollars:0 serialNmuber:serialNum];
}

+ (instancetype)randomItem
{
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounLst = @[@"Bear", @"Spork", @"Mac"];
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounLst count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomNounLst objectAtIndex:nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0'+arc4random()%10, 'A'+arc4random()%26, '0'+arc4random()%10, 'A'+arc4random()%26, '0'+arc4random()%10];
    
    //在静态方法（类方法）中，self代表类
    ZYXItem *item = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNmuber:randomSerialNumber];
    
    return item;
}

//覆盖父类的description方法
- (NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"%@(%@): Worth $%d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    
    return descriptionString;
}

@end
