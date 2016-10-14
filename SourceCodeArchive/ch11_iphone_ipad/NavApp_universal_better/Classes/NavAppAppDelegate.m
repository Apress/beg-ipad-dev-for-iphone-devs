//
//  NavAppAppDelegate.m
//  NavApp
//
//  Created by JN on 4/27/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NavAppAppDelegate.h"
#import "RootViewController.h"


@implementation NavAppAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize splitViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    [window addSubview:[splitViewController view]];
  } else {
    [window addSubview:[navigationController view]];
  }

  [window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

