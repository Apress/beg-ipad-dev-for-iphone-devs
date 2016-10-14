//
//  InputView.h
//  ClacHsilop
//
//  Created by JN on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ActionTag {
  ActionEnter = 0,
  ActionDivide,
  ActionMultiply,
  ActionSubtract,
  ActionAdd
} ActionTag;

@protocol InputViewDelegate;

@interface InputView : UITextView {
  UIView *inputView;
  id <InputViewDelegate> ivDelegate;
}

- (IBAction)takeInputFromTitle:(id)sender;
- (IBAction)doDelete:(id)sender;
- (IBAction)doTaggedAction:(id)sender;

@end

@protocol InputViewDelegate
- (void)doTaggedAction:(ActionTag)tag forInputView:(InputView *)iv;
@end