//
//  DudelAppDelegate.h
//  Dudel
//
//  Created by JN on 2/23/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DudelViewController;
@class FileListViewController;

@interface DudelAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  DudelViewController *viewController;
  FileListViewController *fileListController;
  UISplitViewController *splitViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DudelViewController *viewController;
@property (nonatomic, retain) IBOutlet FileListViewController *fileListController;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@end

