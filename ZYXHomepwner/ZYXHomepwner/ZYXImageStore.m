//
//  ZYXImageStore.m
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/3/15.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXImageStore.h"

@interface ZYXImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation ZYXImageStore

+ (instancetype)sharedStore
{
    static ZYXImageStore *sharedStore = nil;
    
    if (!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [ZYXImageStore sharedStore]" userInfo:nil];
    
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key
{
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key
{
    [self.dictionary removeObjectForKey:key];
}

@end
