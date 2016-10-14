//
//  VideoToyAppDelegate.m
//  VideoToy
//
//  Created by JN on 6/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "VideoToyAppDelegate.h"
#import "VideoToyViewController.h"

@implementation VideoToyAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  // Override point for customization after app launch    
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];

  viewController.urlPaths = [NSMutableArray arrayWithObjects:
                             [[NSBundle mainBundle] pathForResource:@"looking_for_my_leopard" ofType:@"mp4"],
                             [[NSBundle mainBundle] pathForResource:@"knight_rider_season2intro" ofType:@"mp4"],
                             [[NSBundle mainBundle] pathForResource:@"muppets" ofType:@"mp4"],
                             [[NSBundle mainBundle] pathForResource:@"opengl" ofType:@"mp4"],
                             nil];
  [viewController.tableView reloadData];

	return YES;
}


- (void)dealloc {
  [viewController release];
  [window release];
  [super dealloc];
}


@end
