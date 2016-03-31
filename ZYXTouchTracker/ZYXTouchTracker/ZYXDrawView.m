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
@property (nonatomic, strong) NSMutableArray *finishedLines;

@property (nonatomic, weak) ZYXLine *selectedLine;

@end

@implementation ZYXDrawView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.lineInprogress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [NSKeyedUnarchiver unarchiveObjectWithFile:[self linesArchivePath]];
        if (!self.finishedLines)
        {
             self.finishedLines = [[NSMutableArray alloc] init];
        }
       
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTabRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTabRecognizer.numberOfTapsRequired = 2;
        doubleTabRecognizer.delaysTouchesBegan = YES;
        
        //防止手势冲突
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTabRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        [self addGestureRecognizer:doubleTabRecognizer];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor blackColor] set];
    for (ZYXLine *line in self.finishedLines)
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
    
    if (self.selectedLine)
    {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
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

- (ZYXLine *)lineAtPoint:(CGPoint)p
{
    for (ZYXLine *l in self.finishedLines)
    {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        //检查线条的若干点进行比较
        for (float t = 0.0; t < 1.0; t += 0.5)
        {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            //hypotf函数可以接受负数，所得结果还是正数
            if (hypotf(x - p.x, y - p.y) < 20.0)
            {
                return l;
            }
        }
    }
    
    return nil;
}

- (NSString *)linesArchivePath
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [documentPath stringByAppendingPathComponent:@"lines.archive"];
    return path;
}

- (void)archivedLine
{
    [NSKeyedArchiver archiveRootObject:self.finishedLines toFile:[self linesArchivePath]];
}

#pragma mark - GestureRecognizer Method
- (void)doubleTap:(UITapGestureRecognizer *)gr
{
    [self.lineInprogress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)tap:(UITapGestureRecognizer *)gr
{
    NSLog(@"Recognized tap");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    [self setNeedsDisplay];
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
        [self.finishedLines addObject:line];
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
