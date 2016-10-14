    //
//  StrokeColorController.m
//  Dudel
//
//  Created by JN on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectColorController.h"

#import "ColorGrid.h"

@implementation SelectColorController

@synthesize colorGrid, selectedColor, container;

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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorGridTouchedOrDragged:) name:ColorGridTouchedOrDragged object:colorGrid];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorGridTouchEnded:) name:ColorGridTouchEnded object:colorGrid];
  selectedColorSwatch.backgroundColor = self.selectedColor;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
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
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.colorGrid = nil;
  [super dealloc];
}


- (void)colorGridTouchedOrDragged:(NSNotification *)notification {
  NSDictionary *userDict = [notification userInfo];
  self.selectedColor = [userDict objectForKey:ColorGridLatestTouchedColor];
  selectedColorSwatch.backgroundColor = self.selectedColor;
}

- (void)colorGridTouchEnded:(NSNotification *)notification {
  NSDictionary *userDict = [notification userInfo];
  self.selectedColor = [userDict objectForKey:ColorGridLatestTouchedColor];
  selectedColorSwatch.backgroundColor = self.selectedColor;
  [[NSNotificationCenter defaultCenter] postNotificationName:ColorSelectionDone object:self];
}

@end
