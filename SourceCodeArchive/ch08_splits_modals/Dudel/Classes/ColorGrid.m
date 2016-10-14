//
//  ColorGrid.m
//  Dudel
//
//  Created by JN on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ColorGrid.h"


@implementation ColorGrid

@synthesize colors, columnCount, rowCount;

- (void)drawRect:(CGRect)rect {
  CGRect b = self.bounds;
  CGContextRef myContext = UIGraphicsGetCurrentContext();
  CGFloat columnWidth = b.size.width / columnCount;
  CGFloat rowHeight = b.size.height / rowCount;
  for (NSUInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
    for (NSUInteger columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      NSUInteger colorIndex = rowIndex * columnCount + columnIndex;
      UIColor *color = [self.colors count] > colorIndex ? [self.colors objectAtIndex:colorIndex] : [UIColor whiteColor];
      CGRect r = CGRectMake(b.origin.x + columnIndex * columnWidth,
                            b.origin.y + rowIndex * rowHeight,
                            columnWidth, rowHeight);
      CGContextSetFillColorWithColor(myContext, color.CGColor);
      CGContextFillRect(myContext, r);
    }
  }
}

- (UIColor *)colorAtPoint:(CGPoint)point {
  if (!CGRectContainsPoint(self.bounds, point)) return nil;
  
  CGRect b = self.bounds;
  CGFloat columnWidth = b.size.width / columnCount;
  CGFloat rowHeight = b.size.height / rowCount;

  NSUInteger rowIndex = point.y / rowHeight;
  NSUInteger columnIndex = point.x / columnWidth;
  NSUInteger colorIndex = rowIndex * columnCount + columnIndex;
  return [self.colors count] > colorIndex ? 
           [self.colors objectAtIndex:colorIndex] :
           nil;
}
- (void)dealloc {
  self.colors = nil;
  [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint location = [[touches anyObject] locationInView:self];
  UIColor *color = [self colorAtPoint:location];
  if (color) {
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:color forKey:ColorGridLatestTouchedColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:ColorGridTouchedOrDragged object:self userInfo:userDict];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [self touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint location = [[touches anyObject] locationInView:self];
  UIColor *color = [self colorAtPoint:location];
  if (color) {
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:color forKey:ColorGridLatestTouchedColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:ColorGridTouchEnded object:self userInfo:userDict];
  }
}


@end
