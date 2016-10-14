//
//  StrokeColorController.h
//  Dudel
//
//  Created by JN on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorGrid;

// a notification name
#define ColorSelectionDone @"ColorSelectionDone"

@interface SelectColorController : UIViewController {
  IBOutlet ColorGrid *colorGrid;
  IBOutlet UIView *selectedColorSwatch;
  UIColor *selectedColor;
  UIPopoverController *container;
}

@property (retain, nonatomic) ColorGrid *colorGrid;
@property (retain, nonatomic) UIColor *selectedColor;
@property (assign, nonatomic) UIPopoverController *container;

@end
