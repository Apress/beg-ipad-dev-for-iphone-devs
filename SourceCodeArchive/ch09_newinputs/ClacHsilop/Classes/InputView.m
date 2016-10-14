//
//  InputView.m
//  ClacHsilop
//
//  Created by JN on 4/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InputView.h"

@implementation InputView

- (void)dealloc {
  [inputView release];
  [super dealloc];
}

- (UIView *)inputView {
  if (!inputView) {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RpnKeyboard" owner:self options:nil];
    NSLog(@"loaded objects from nib: %@", objects);
    inputView = [[objects objectAtIndex:0] retain];
  }
  return inputView;
}

- (IBAction)takeInputFromTitle:(id)sender {
  // remove the initial "0";
  if ([self.text isEqual:@"0"]) {
    self.text = @"";
  }
  self.text = [self.text stringByReplacingCharactersInRange:self.selectedRange
    withString:((UIButton *)sender).currentTitle];
}
   
- (IBAction)doDelete:(id)sender {
  NSRange r = self.selectedRange;
  if (r.length > 0) {
    // the user has highlighted some text, fall through to delete it
  } else {
    // there's just an insertion point
    if (r.location == 0) {
      // cursor is at the beginning, forget about it.
      return;
    } else {
      r.location -= 1;
      r.length = 1;
    }
  }
  self.text = [self.text stringByReplacingCharactersInRange:r withString:@""];
  r.length = 0;
  self.selectedRange = r;
}

- (IBAction)doTaggedAction:(id)sender {
  ActionTag tag = [sender tag];
  [ivDelegate doTaggedAction:tag forInputView:self];
}

@end
