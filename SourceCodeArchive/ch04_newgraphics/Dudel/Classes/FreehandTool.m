//
//  FreehandTool.m
//  Dudel
//
//  Created by JN on 2/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "FreehandTool.h"
#import "PathDrawingInfo.h"

#import "SynthesizeSingleton.h"

@implementation FreehandTool

@synthesize delegate, workingPath;

SYNTHESIZE_SINGLETON_FOR_CLASS(FreehandTool);

- init {
  if ((self = [super init])) {
  }
  return self;
}
- (void)activate {
  self.workingPath = [UIBezierPath bezierPath];
  settingFirstPoint = YES;
}

- (void)deactivate {
  // this is where we finally tell about our path
  PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:self.workingPath fillColor:delegate.fillColor strokeColor:delegate.strokeColor];
  [delegate addDrawable:info];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  isDragging = YES;
  UIView *touchedView = [delegate viewForUseWithTool:self];
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchPoint = [touch locationInView:touchedView];
  // set nextSegmentPoint2
  nextSegmentPoint2 = touchPoint;
  // establish nextSegmentCp2
  nextSegmentCp2 = touchPoint;
  if (workingPath.empty) {
    // this is the first touch in a path, so set the "1" variables as well
    nextSegmentCp1 = touchPoint;
    nextSegmentPoint1 = touchPoint;
    [workingPath moveToPoint:touchPoint];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  isDragging = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  isDragging = NO;
  UIView *touchedView = [delegate viewForUseWithTool:self];
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchPoint = [touch locationInView:touchedView];
  nextSegmentCp2 = touchPoint;
  // complete segment and add to list.
  if (settingFirstPoint) {
    // the first touch'n'drag doesn't complete a segment, we just
    // note the change of state and move along
    settingFirstPoint = NO;
  } else {
    // nextSegmentCp2, which we've
    // been dragging around, is translated around nextSegmentPoint2 
    // for creation of this segment.
    CGPoint shiftedNextSegmentCp2 = CGPointMake(
      nextSegmentPoint2.x + (nextSegmentPoint2.x - nextSegmentCp2.x),
      nextSegmentPoint2.y + (nextSegmentPoint2.y - nextSegmentCp2.y));
    [workingPath addCurveToPoint:nextSegmentPoint2 controlPoint1:nextSegmentCp1 controlPoint2:shiftedNextSegmentCp2];
    // the "2" values are now copied to the "1" variables
    nextSegmentPoint1 = nextSegmentPoint2;
    nextSegmentCp1 = nextSegmentCp2;
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [delegate viewForUseWithTool:self];
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchPoint = [touch locationInView:touchedView];
  if (settingFirstPoint) {
    nextSegmentCp1 = touchPoint;
  } else {
    // adjust nextSegmentCp2
    nextSegmentCp2 = touchPoint;
  }
}

- (void)drawTemporary {
  // draw all the segments we've finished so far
  [workingPath stroke];
  if (isDragging) {
    // draw the current segment that's being created.
    if (settingFirstPoint) {
      // just draw a line
      UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
      [currentWorkingSegment moveToPoint:nextSegmentPoint1];
      [currentWorkingSegment addLineToPoint:nextSegmentCp1];
      [[delegate strokeColor] setStroke];
      [currentWorkingSegment stroke];
    } else {
      // nextSegmentCp2, which we've
      // been dragging around, is translated around nextSegmentPoint2 
      // for creation of this segment.      
      CGPoint shiftedNextSegmentCp2 = CGPointMake(
                                                  nextSegmentPoint2.x + (nextSegmentPoint2.x - nextSegmentCp2.x),
                                                  nextSegmentPoint2.y + (nextSegmentPoint2.y - nextSegmentCp2.y));
      UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
      [currentWorkingSegment moveToPoint:nextSegmentPoint1];
      [currentWorkingSegment addCurveToPoint:nextSegmentPoint2 controlPoint1:nextSegmentCp1 controlPoint2:shiftedNextSegmentCp2];
      [[delegate strokeColor] setStroke];
      [currentWorkingSegment stroke];
    }
  }
  if (!CGPointEqualToPoint(nextSegmentCp2, nextSegmentPoint2) && !settingFirstPoint) {
    // draw the guideline to the next segment
    //CGContextSaveGState(UIGraphicsGetCurrentContext());
    UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
    [currentWorkingSegment moveToPoint:nextSegmentCp2];
    CGPoint shiftedNextSegmentCp2 = CGPointMake(
                                                nextSegmentPoint2.x + (nextSegmentPoint2.x - nextSegmentCp2.x),
                                                nextSegmentPoint2.y + (nextSegmentPoint2.y - nextSegmentCp2.y));
    [currentWorkingSegment addLineToPoint:shiftedNextSegmentCp2];
    float dashPattern[] = {10.0, 7.0};
    [currentWorkingSegment setLineDash:dashPattern count:2 phase:0.0];
    [[UIColor redColor] setStroke];
    [currentWorkingSegment stroke];    
    //CGContextRestoreGState(UIGraphicsGetCurrentContext());
  }
}

- (void)dealloc {
  self.workingPath = nil;
  self.delegate = nil;
  [super dealloc];
}

@end
