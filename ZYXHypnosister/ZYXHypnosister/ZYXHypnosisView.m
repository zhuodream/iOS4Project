//
//  ZYXHypnosisView.m
//  ZYXHypnosister
//
//  Created by 卓酉鑫 on 16/2/23.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXHypnosisView.h"

@interface ZYXHypnosisView ()

@property (nonatomic, strong) UIColor *circleColor;

@end

@implementation ZYXHypnosisView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    NSLog(@"set color");
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

//空实现对视图的动画是不利的
- (void)drawRect:(CGRect)rect {
    CGPoint centerPoint;
    centerPoint.x = self.bounds.origin.x + self.bounds.size.width/2.0;
    centerPoint.y = self.bounds.origin.y + self.bounds.size.height/2.0;
    
    float maxRadius = hypotf(self.bounds.size.width, self.bounds.size.height) / 2.0;

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20)
    {
        [path addArcWithCenter:centerPoint radius:currentRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [path moveToPoint:CGPointMake(centerPoint.x + currentRadius - 20, centerPoint.y)];
    }
    
    path.lineWidth = 10;
    [self.circleColor setStroke];
    [path stroke];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);
    
    [logoImage drawInRect:rect];
    CGContextRestoreGState(currentContext);
    
    CGContextSaveGState(currentContext);
    UIBezierPath *myPath = [UIBezierPath bezierPath];
    [myPath moveToPoint:CGPointMake(centerPoint.x, 0)];
    [myPath addLineToPoint:CGPointMake(0, self.bounds.origin.y)];
    [myPath addLineToPoint:CGPointMake(self.bounds.origin.x, centerPoint.y)];
    [myPath addClip];
    
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = { 0.0, 1.0, 0.0, 1.0,
                            1.0, 1.0, 0.0, 1.0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(centerPoint.x, 0);
    CGPoint endPoint = CGPointMake(0, self.bounds.origin.y);
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(currentContext);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch began");
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 /100.0;
    float blue = arc4random() % 100 / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.circleColor = randomColor;
}

@end
