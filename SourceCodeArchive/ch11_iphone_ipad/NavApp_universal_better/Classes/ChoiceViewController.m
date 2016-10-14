//
//  ChoiceView.m
//  NavApp
//
//  Created by JN on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChoiceViewController.h"


@implementation ChoiceViewController

@synthesize choice;

- (void)setChoice:(NSString *)c {
  if (![c isEqual:choice]) {
    [choice release];
    choice = [c copy];
    self.navigationItem.title = self.choice;
    choiceLabel.text = choice;
    topLabel.hidden = FALSE;
    bottomLabel.hidden = FALSE;
  }
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (self.choice) {
    self.navigationItem.title = self.choice;
    choiceLabel.text = choice;
    topLabel.hidden = FALSE;
    bottomLabel.hidden = FALSE;
  } else {
    choiceLabel.text = @"Make your choice!";
    topLabel.hidden = TRUE;
    bottomLabel.hidden = TRUE;
  }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
  return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  self.choice = nil;
  [super dealloc];
}

#pragma mark UISplitViewControllerDelegate
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
  NSArray *newItems = [toolbar.items arrayByAddingObject:barButtonItem];
  [toolbar setItems:newItems animated:YES];
  
  // configure display of the button
  barButtonItem.title = @"Choices";
}
- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button {
  // remove the button, and the spacer that is beside it 
  NSMutableArray *newItems = [[toolbar.items mutableCopy] autorelease];
  if ([newItems containsObject:button]) {
    [newItems removeObject:button];
    [toolbar setItems:newItems animated:YES];
  }
}
/*
- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController {
  // we don't create this popover on our own, but we want to notice it so that we can dismiss any other popovers, and also remove it later.
  if (self.currentPopover) {
    [self.currentPopover dismissPopoverAnimated:YES];
    [self handleDismissedPopoverController:self.currentPopover];
  }
  self.currentPopover = pc;
}
 */

@end
