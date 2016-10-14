//
//  StrokeDemoView.m
//  Dudel
//
//  Created by JN on 3/17/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "StrokeDemoView.h"


@implementation StrokeDemoView

@synthesize strokeWidth;

- (void)setStrokeWidth:(CGFloat)f {
  strokeWidth = f;
  drawPath.lineWidth = f;
  [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    drawPath = [[UIBezierPath bezierPathWithRect:CGRectMake(10, 10, 145, 100)] retain];
    [drawPath appendPath:
     [UIBezierPath bezierPathWithOvalInRect:CGRectMake(165, 10, 145, 100)]];
    
    [drawPath moveToPoint:CGPointMake(10, 120)];
    [drawPath addLineToPoint:CGPointMake(310, 120)];
    
    [drawPath moveToPoint:CGPointMake(110, 140)];
    [drawPath addLineToPoint:CGPointMake(310, 200)];
    
    [drawPath moveToPoint:CGPointMake(100, 180)];
    [drawPath addLineToPoint:CGPointMake(310, 140)];
    
    [drawPath moveToPoint:CGPointMake(90, 200)];
    [drawPath addCurveToPoint:CGPointMake(300, 230) controlPoint1:CGPointMake(0, 0) controlPoint2:CGPointMake(-100, 300)];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // Drawing code
  [[UIColor blackColor] setStroke];
  [drawPath stroke];
}

- (void)dealloc {
  [drawPath dealloc];
  [super dealloc];
}


@end
