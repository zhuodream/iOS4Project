//
//  ZYXDrawView.m
//  ZYXTouchTracker
//
//  Created by 卓酉鑫 on 16/3/16.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXDrawView.h"
#import "ZYXLine.h"

@interface ZYXDrawView ()

@property (nonatomic, strong) NSMutableDictionary *lineInprogress;
@property (nonatomic, strong) NSMutableArray *finishedLine;

@end

@implementation ZYXDrawView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.lineInprogress = [[NSMutableDictionary alloc] init];
        self.finishedLine = [NSKeyedUnarchiver unarchiveObjectWithFile:[self linesArchivePath]];
        if (!self.finishedLine)
        {
             self.finishedLine = [[NSMutableArray alloc] init];
        }
       
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor blackColor] set];
    for (ZYXLine *line in self.finishedLine)
    {
        [self strokeLine:line];
    }
    
    if (self.lineInprogress)
    {
        [[UIColor redColor] set];
        for (NSValue *key in self.lineInprogress)
        {
            [self strokeLine:self.lineInprogress[key]];
        }
    }
}

- (void)strokeLine:(ZYXLine *)line
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 10;
    path.lineCapStyle = kCGLineCapRound;
    
    [path moveToPoint:line.begin];
    [path addLineToPoint:line.end];
    [path stroke];
}

- (NSString *)linesArchivePath
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [documentPath stringByAppendingPathComponent:@"lines.archive"];
    return path;
}

- (void)archivedLine
{
    [NSKeyedArchiver archiveRootObject:self.finishedLine toFile:[self linesArchivePath]];
}

#pragma mark - Touches Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:self];
        
        ZYXLine *line = [[ZYXLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.lineInprogress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        ZYXLine *line = self.lineInprogress[key];
        
        line.end = [t locationInView:self];
        
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        ZYXLine *line = self.lineInprogress[key];
        [self.finishedLine addObject:line];
        [self.lineInprogress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.lineInprogress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}


@end
