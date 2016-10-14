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
}

@property (copy, nonatomic) NSString *choice;

@end
