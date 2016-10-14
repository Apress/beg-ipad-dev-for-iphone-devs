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

@interface DudelViewController : UIViewController <ToolDelegate, DudelViewDelegate, MFMailComposeViewControllerDelegate> {
  id <Tool> currentTool;
  IBOutlet DudelView *dudelView;
  IBOutlet UIBarButtonItem *textButton;
  IBOutlet UIBarButtonItem *freehandButton;
  IBOutlet UIBarButtonItem *ellipseButton;
  IBOutlet UIBarButtonItem *rectangleButton;
  IBOutlet UIBarButtonItem *lineButton;
  IBOutlet UIBarButtonItem *pencilButton;
  UIColor *strokeColor;
  UIColor *fillColor;
  CGFloat strokeWidth;
  UIFont *font;
}

@property (retain, nonatomic) id <Tool> currentTool;
@property (retain, nonatomic) UIColor *strokeColor;
@property (retain, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) CGFloat strokeWidth;
@property (retain, nonatomic) UIFont *font;

- (IBAction)touchTextItem:(id)sender;
- (IBAction)touchFreehandItem:(id)sender;
- (IBAction)touchEllipseItem:(id)sender;
- (IBAction)touchRectangleItem:(id)sender;
- (IBAction)touchLineItem:(id)sender;
- (IBAction)touchPencilItem:(id)sender;
- (IBAction)touchSendPdfEmailItem:(id)sender;

@end

