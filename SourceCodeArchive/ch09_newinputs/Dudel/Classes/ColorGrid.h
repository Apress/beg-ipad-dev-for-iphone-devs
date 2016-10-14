//
//  ColorGrid.h
//  Dudel
//
//  Created by JN on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ColorGridTouchedOrDragged @"ColorGridTouchedOrDragged"
#define ColorGridTouchEnded @"ColorGridTouchEnded"
#define ColorGridLatestTouchedColor @"ColorGridLatestTouchedColor"

@interface ColorGrid : UIView {
  NSArray *colors;
  NSUInteger columnCount;
  NSUInteger rowCount;
}
@property (retain, nonatomic) NSArray *colors;
@property (nonatomic) NSUInteger columnCount;
@property (nonatomic) NSUInteger rowCount;
@end
