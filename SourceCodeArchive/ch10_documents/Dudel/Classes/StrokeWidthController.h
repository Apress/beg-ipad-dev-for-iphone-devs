//
//  StrokeWidthController.h
//  Dudel
//
//  Created by JN on 3/17/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StrokeDemoView;

@interface StrokeWidthController : UIViewController {
  IBOutlet UISlider *slider;
  IBOutlet UILabel *label;
  IBOutlet StrokeDemoView *strokeDemoView;
  CGFloat strokeWidth;
}

@property (assign, nonatomic) CGFloat strokeWidth;

- (void)takeIntValueFrom:(id)sender;

@end
