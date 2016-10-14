//
//  EllipseTool.m
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "EllipseTool.h"
#import "PathDrawingInfo.h"

#import "SynthesizeSingleton.h"

@implementation EllipseTool

@synthesize delegate;

SYNTHESIZE_SINGLETON_FOR_CLASS(EllipseTool);

- init {
  if ((self = [super init])) {
    trackingTouches = [[NSMutableArray arrayWithCapacity:100] retain];
    startPoints = [[NSMutableArray arrayWithCapacity:100] retain];
  }
  return self;
}
- (void)activate {
}

- (void)deactivate {
  [trackingTouches removeAllObjects];
  [startPoints removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [delegate viewForUseWithTool:self];
  for (UITouch *touch in [event allTouches]) {
    // remember the touch, and its original start point, for future
    [trackingTouches addObject:touch];
    CGPoint location = [touch locationInView:touchedView];
    [startPoints addObject:[NSValue valueWithCGPoint:location]];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [delegate viewForUseWithTool:self];
  for (UITouch *touch in [event allTouches]) {
    // make a line from the start point to the current point
    NSUInteger touchIndex = [trackingTouches indexOfObject:touch];
    // only if we actually remember the start of this touch...
    if (touchIndex != NSNotFound) {
      CGPoint startPoint = [[startPoints objectAtIndex:touchIndex] CGPointValue];
      CGPoint endPoint = [touch locationInView:touchedView];
      CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
      UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
      path.lineWidth = delegate.strokeWidth;
      PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path fillColor:delegate.fillColor strokeColor:delegate.strokeColor];
      [delegate addDrawable:info];
      [trackingTouches removeObjectAtIndex:touchIndex];
      [startPoints removeObjectAtIndex:touchIndex];
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)drawTemporary {
  UIView *touchedView = [delegate viewForUseWithTool:self];
  for (int i = 0; i<[trackingTouches count]; i++) {
    UITouch *touch = [trackingTouches objectAtIndex:i];
    CGPoint startPoint = [[startPoints objectAtIndex:i] CGPointValue];
    CGPoint endPoint = [touch locationInView:touchedView];
    CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    path.lineWidth = delegate.strokeWidth;
    [delegate.fillColor setFill];
    [path fill];
    [delegate.strokeColor setStroke];
    [path stroke];
  }
}

- (void)dealloc {
  [trackingTouches release];
  [startPoints release];
  self.delegate = nil;
  [super dealloc];
}

@end
