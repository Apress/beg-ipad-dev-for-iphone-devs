//
//  RectangleTool.h
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tool.h"

@interface RectangleTool : NSObject <Tool> {
  id <ToolDelegate> delegate;
  NSMutableArray *trackingTouches;
  NSMutableArray *startPoints;
}

+(RectangleTool*)sharedRectangleTool;

@end
