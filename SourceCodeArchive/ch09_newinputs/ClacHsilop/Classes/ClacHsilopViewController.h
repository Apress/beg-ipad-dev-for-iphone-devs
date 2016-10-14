//
//  ClacHsilopViewController.h
//  ClacHsilop
//
//  Created by JN on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"

@interface ClacHsilopViewController : UIViewController <InputViewDelegate> {
  IBOutlet InputView *inputView;
  IBOutlet UITableView *stackTableView;
  NSNumberFormatter *decimalFormatter;
  NSMutableArray *stack;
}

@end

