//
//  TextTool.h
//  Dudel
//
//  Created by JN on 3/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tool.h"

@interface TextTool : NSObject <Tool, UITextViewDelegate> {
  id <ToolDelegate> delegate;
  NSMutableArray *trackingTouches;
  NSMutableArray *startPoints;
  UIBezierPath *completedPath;
}

@property (retain, nonatomic) UIBezierPath *completedPath;

+(TextTool*)sharedTextTool;

@end
