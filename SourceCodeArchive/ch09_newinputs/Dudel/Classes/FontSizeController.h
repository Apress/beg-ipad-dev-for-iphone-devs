//
//  FontSizeController.h
//  Dudel
//
//  Created by JN on 3/17/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FontSizeController : UIViewController {
  IBOutlet UITextView *textView;
  IBOutlet UISlider *slider;
  IBOutlet UILabel *label;
  UIFont *font;
}

@property (retain, nonatomic) UIFont *font;

- (void)takeIntValueFrom:(id)sender;

@end
