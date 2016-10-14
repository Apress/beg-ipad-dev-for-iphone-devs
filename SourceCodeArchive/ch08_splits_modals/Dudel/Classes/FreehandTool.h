//
//  FreehandTool.h
//  Dudel
//
//  Created by JN on 2/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tool.h"

@interface FreehandTool : NSObject <Tool> {
  id <ToolDelegate> delegate;
  UIBezierPath *workingPath;
  CGPoint nextSegmentPoint1;
  CGPoint nextSegmentPoint2;
  CGPoint nextSegmentCp1;
  CGPoint nextSegmentCp2;
  BOOL isDragging;
  BOOL settingFirstPoint;
}

@property (retain, nonatomic) UIBezierPath *workingPath;

+(FreehandTool*)sharedFreehandTool;

@end
