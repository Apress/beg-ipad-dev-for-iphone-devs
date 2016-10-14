//
//  ActionsMenuController.h
//  Dudel
//
//  Created by JN on 3/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ActionsMenuControllerDidSelect @"ActionsMenuControllerDidSelect"

typedef enum SelectedActionType {
  NoAction = -1,
  NewDocument,
  RenameDocument,
  DeleteDocument,
  EmailPdf,
  ShowAppInfo
} SelectedActionType;

@interface ActionsMenuController : UITableViewController {
  SelectedActionType selection;
  UIPopoverController *container;
}

@property (readonly) SelectedActionType selection;
@property (assign, nonatomic) UIPopoverController *container;


@end
