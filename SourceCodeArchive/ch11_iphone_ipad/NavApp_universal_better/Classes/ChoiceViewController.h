//
//  ChoiceView.h
//  NavApp
//
//  Created by JN on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChoiceViewController : UIViewController {
  NSString *choice;
  IBOutlet UILabel *choiceLabel;
  
  IBOutlet UIToolbar *toolbar;
  IBOutlet UILabel *topLabel;
  IBOutlet UILabel *bottomLabel;
}

@property (copy, nonatomic) NSString *choice;

@end
