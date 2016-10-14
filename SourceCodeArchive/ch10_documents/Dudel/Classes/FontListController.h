//
//  FontListController.h
//  Dudel
//
//  Created by JN on 3/17/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// we'll use a notification with this name, to let the main
// view controller know that something was selected here.
#define FontListControllerDidSelect @"FontListControllerDidSelect"

@interface FontListController : UITableViewController {
  NSArray *fonts;
  NSString *selectedFontName;
  UIPopoverController *container;
}

@property (retain, nonatomic) NSArray *fonts;
@property (copy, nonatomic) NSString *selectedFontName;
@property (assign, nonatomic) UIPopoverController *container;

@end
