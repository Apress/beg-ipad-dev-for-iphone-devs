//
//  DudelViewController.h
//  Dudel
//
//  Created by JN on 2/23/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Tool.h"
#import "DudelView.h"
#import "ModalWebViewController.h"
#import "FileRenameViewController.h"

@interface DudelViewController : UIViewController <ToolDelegate, DudelViewDelegate, MFMailComposeViewControllerDelegate, UIPopoverControllerDelegate, ModalWebViewControllerDelegate, FileRenameViewControllerDelegate, UIDocumentInteractionControllerDelegate> {
  id <Tool> currentTool;
  IBOutlet DudelView *dudelView;
  IBOutlet UIBarButtonItem *textButton;
  IBOutlet UIBarButtonItem *freehandButton;
  IBOutlet UIBarButtonItem *ellipseButton;
  IBOutlet UIBarButtonItem *rectangleButton;
  IBOutlet UIBarButtonItem *lineButton;
  IBOutlet UIBarButtonItem *pencilButton;
  IBOutlet UIToolbar *toolbar;
  UIColor *strokeColor;
  UIColor *fillColor;
  UIFont *font;
  UIPopoverController *currentPopover;
  CGFloat strokeWidth;
  IBOutlet UIBarButtonItem *actionsMenuButton;
}

@property (retain, nonatomic) id <Tool> currentTool;
@property (retain, nonatomic) UIColor *strokeColor;
@property (retain, nonatomic) UIColor *fillColor;
@property (retain, nonatomic) UIFont *font;
@property (retain, nonatomic) UIPopoverController *currentPopover;
@property (assign, nonatomic) CGFloat strokeWidth;

- (IBAction)touchTextItem:(id)sender;
- (IBAction)touchFreehandItem:(id)sender;
- (IBAction)touchEllipseItem:(id)sender;
- (IBAction)touchRectangleItem:(id)sender;
- (IBAction)touchLineItem:(id)sender;
- (IBAction)touchPencilItem:(id)sender;

- (IBAction)popoverStrokeWidth:(id)sender;
- (IBAction)popoverStrokeColor:(id)sender;
- (IBAction)popoverFillColor:(id)sender;
- (IBAction)popoverFontName:(id)sender;
- (IBAction)popoverFontSize:(id)sender;
- (IBAction)popoverActionsMenu:(id)sender;

- (BOOL)loadFromFile:(NSString *)filename;
- (BOOL)saveCurrentToFile:(NSString *)filename;

@end

