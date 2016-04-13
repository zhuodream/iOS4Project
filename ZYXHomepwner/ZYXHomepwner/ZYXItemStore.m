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
@import CoreData;

@interface ZYXItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation ZYXItemStore

+ (instancetype)sharedStore
{
    static ZYXItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
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
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
        {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories.firstObject;
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful)
    {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (ZYXItem *)createItem
{
   // ZYXItem *item = [ZYXItem randomItem];
    double order;
    if ([self.allItems count] == 0)
    {
        order = 1.0;
    }
    else
    {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %ld items, order = %.2f", (long)[self.privateItems count], order);
    ZYXItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"ZYXItem" inManagedObjectContext:self.context];
    NSLog(@"item ============== %@", item);
    item.orderingValue = order;
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(ZYXItem *)item
{
    NSString *key = item.itemKey;
    if (key)
    {
        [[ZYXImageStore sharedStore] deleteImageForKey:key];
    }
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    NSLog(@"fromIndex = %ld, toIndex = %ld", fromIndex, toIndex);
    if (fromIndex == toIndex)
    {
        return;
    }
    ZYXItem *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    double lowerBound = 0.0;
    if (toIndex > 0)
    {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    }
    else
    {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    NSLog(@"lowerBound = %f", lowerBound);
    double upperBound = 0.0;
    if (toIndex < [self.privateItems count] -1)
    {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    }
    else
    {
        upperBound = [self.privateItems[toIndex - 1] orderingValue] +2.0;
    }
    NSLog(@"upperBound = %f", upperBound);
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (void)loadAllItems
{
    if (!self.privateItems)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZYXItem" inManagedObjectContext:self.context];
        request.entity = e;
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        
        request.sortDescriptors = @[sd];
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result)
        {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}


- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZYXAssetType" inManagedObjectContext:self.context];
        request.entity = e;
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if (!result)
        {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    if ([_allAssetTypes count] == 0)
    {
        NSManagedObject *type;
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZYXAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZYXAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZYXAssetType" inManagedObjectContext:self.context];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    
    return _allAssetTypes;
}

@end
