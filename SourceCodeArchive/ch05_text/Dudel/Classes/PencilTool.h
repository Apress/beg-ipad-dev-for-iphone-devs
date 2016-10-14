//
//  PencilTool.h
//  Dudel
//
//  Created by JN on 2/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tool.h"

@interface PencilTool : NSObject <Tool> {
  id <ToolDelegate> delegate;
  NSMutableArray *trackingTouches;
  NSMutableArray *startPoints;
  NSMutableArray *paths;
}

+(PencilTool*)sharedPencilTool;

@end
