//
//  DudelEditController.h
//  Dudel
//
//  Created by JN on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DudelEditControllerDelete @"DudelEditControllerDelete"

@interface DudelEditController : UITableViewController {
  UIPopoverController *container;
}
@property (assign, nonatomic) UIPopoverController *container;

@end
