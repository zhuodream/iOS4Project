//
//  main.m
//  ZYXRandomItems
//
//  Created by 卓酉鑫 on 16/2/20.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYXContainer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:@"One"];
        [items addObject:@"Two"];
        [items addObject:@"Three"];
        
        [items insertObject:@"Zero" atIndex:0];
        
        for (NSString *item in items)
        {
            NSLog(@"%@", item);
        }
        
        items = nil;
        
        ZYXContainer *container = [[ZYXContainer alloc] init];
        ZYXContainer *test = [[ZYXContainer alloc] init];
        [container addNewObject:test];
        NSLog(@"container log = %@", [container description]);
}
    return 0;
}
