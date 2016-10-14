//
//  DudelAppDelegate.m
//  Dudel
//
//  Created by JN on 2/23/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "DudelAppDelegate.h"
#import "DudelViewController.h"
#import "FileListViewController.h"

#import "FileList.h"

@implementation DudelAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize fileListController;
@synthesize splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {   
  // Override point for customization after app launch    
  [window addSubview:splitViewController.view];
  [window makeKeyAndVisible];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileListControllerSelectedFile:) name:FileListControllerSelectedFile object:fileListController];
  
	return YES;
}

- (void)fileListControllerSelectedFile:(NSNotification *)n {
  NSString *oldFilename = [FileList sharedFileList].currentFile;
  NSLog(@"saving to old file %@", oldFilename);
  [viewController saveCurrentToFile:oldFilename];
  NSString *filename = [[n userInfo] objectForKey:FileListControllerFilename];
  [FileList sharedFileList].currentFile = filename;
  NSLog(@"reading from new file %@", filename);
  [viewController loadFromFile:filename];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [splitViewController release];
  [window release];
  [super dealloc];
}

@end
