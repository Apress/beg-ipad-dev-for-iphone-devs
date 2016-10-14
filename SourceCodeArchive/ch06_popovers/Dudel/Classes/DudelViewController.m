//
//  DudelViewController.m
//  Dudel
//
//  Created by JN on 2/23/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "DudelViewController.h"

#import "DudelView.h"

#import "PencilTool.h"
#import "LineTool.h"
#import "RectangleTool.h"
#import "EllipseTool.h"
#import "FreehandTool.h"
#import "TextTool.h"

#import "ColorGrid.h"

#import "FontListController.h"
#import "FontSizeController.h"
#import "StrokeWidthController.h"
#import "StrokeColorController.h"
#import "FillColorController.h"

@implementation DudelViewController

@synthesize currentTool, fillColor, strokeColor, font, strokeWidth, currentPopover;

- (void)deselectAllToolButtons {
	[textButton setImage:[UIImage imageNamed:@"button_text.png"]];
	[freehandButton setImage:[UIImage imageNamed:@"button_bezier.png"]];
	[ellipseButton setImage:[UIImage imageNamed:@"button_ellipse.png"]];
	[rectangleButton setImage:[UIImage imageNamed:@"button_rectangle.png"]];
	[lineButton setImage:[UIImage imageNamed:@"button_line.png"]];
	[pencilButton setImage:[UIImage imageNamed:@"button_cdots.png"]];
}

- (void)setCurrentTool:(id <Tool>)t {
  [currentTool deactivate];
  if (t != currentTool) {
    [currentTool release];
    currentTool = [t retain];
    currentTool.delegate = self;
    [self deselectAllToolButtons];
  }
  [currentTool activate];
  [dudelView setNeedsDisplay];
}

- (IBAction)touchTextItem:(id)sender {
  self.currentTool = [TextTool sharedTextTool];
	[textButton setImage:[UIImage imageNamed:@"button_text_selected.png"]];
}

- (IBAction)touchFreehandItem:(id)sender {
  self.currentTool = [FreehandTool sharedFreehandTool];
	[freehandButton setImage:[UIImage imageNamed:@"button_bezier_selected.png"]];
}

- (IBAction)touchEllipseItem:(id)sender {
  self.currentTool = [EllipseTool sharedEllipseTool];
	[ellipseButton setImage:[UIImage imageNamed:@"button_ellipse_selected.png"]];
}
- (IBAction)touchRectangleItem:(id)sender {
  self.currentTool = [RectangleTool sharedRectangleTool];
	[rectangleButton setImage:[UIImage imageNamed:@"button_rectangle_selected.png"]];
}
- (IBAction)touchLineItem:(id)sender {
  self.currentTool = [LineTool sharedLineTool];
	[lineButton setImage:[UIImage imageNamed:@"button_line_selected.png"]];
}
- (IBAction)touchPencilItem:(id)sender {
  self.currentTool = [PencilTool sharedPencilTool];
	[pencilButton setImage:[UIImage imageNamed:@"button_cdots_selected.png"]];
}

- (IBAction)touchSendPdfEmailItem:(id)sender {
  // set up PDF rendering context
  NSMutableData *pdfData = [NSMutableData data];
  UIGraphicsBeginPDFContextToData(pdfData, dudelView.bounds, nil);
  UIGraphicsBeginPDFPage();
  
  // tell our view to draw
  [dudelView drawRect:dudelView.bounds];
  
  // remove PDF rendering context
  UIGraphicsEndPDFContext();
  
  // send PDF data in mail message
  MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
  mailComposer.mailComposeDelegate = self;
  [mailComposer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"Dudel creation.pdf"];
  [self presentModalViewController:mailComposer animated:YES];
}

- (void)handleDismissedPopoverController:(UIPopoverController*)popoverController {
  if ([popoverController.contentViewController isMemberOfClass:[FontListController class]]) {
    // this is the font list, grab the new selection
    FontListController *flc = (FontListController *)popoverController.contentViewController;
    self.font = [UIFont fontWithName:flc.selectedFontName size:self.font.pointSize];
  } else if ([popoverController.contentViewController isMemberOfClass:[FontSizeController class]]) {
    FontSizeController *fsc = (FontSizeController *)popoverController.contentViewController;
    self.font = fsc.font;
  } else if ([popoverController.contentViewController isMemberOfClass:[StrokeWidthController class]]) {
    StrokeWidthController *swc = (StrokeWidthController *)popoverController.contentViewController;
    self.strokeWidth = swc.strokeWidth;
  } else if ([popoverController.contentViewController isMemberOfClass:[StrokeColorController class]]) {
    StrokeColorController *scc = (StrokeColorController *)popoverController.contentViewController;
    self.strokeColor = scc.selectedColor;
  } else if ([popoverController.contentViewController isMemberOfClass:[FillColorController class]]) {
    FillColorController *fcc = (FillColorController *)popoverController.contentViewController;
    self.fillColor = fcc.selectedColor;
  }
  self.currentPopover = nil;
}
- (void)setupNewPopoverControllerForViewController:(UIViewController *)vc {
  if (self.currentPopover) {
    [self.currentPopover dismissPopoverAnimated:YES];
    [self handleDismissedPopoverController:self.currentPopover];
  }
  self.currentPopover = [[[UIPopoverController alloc] initWithContentViewController:vc] autorelease];
  self.currentPopover.delegate = self;
}

- (IBAction)popoverStrokeWidth:(id)sender {
  StrokeWidthController *swc = [[[StrokeWidthController alloc] initWithNibName:nil bundle:nil] autorelease];
  swc.strokeWidth = self.strokeWidth;
  [self setupNewPopoverControllerForViewController:swc];
  self.currentPopover.popoverContentSize = swc.view.frame.size;
  [self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)doPopoverSelectColorController:(SelectColorController*)scc sender:(id)sender {
  [self setupNewPopoverControllerForViewController:scc];
  scc.container = self.currentPopover;
  self.currentPopover.popoverContentSize = scc.view.frame.size;
  
  // these have to be set after the view is already loaded (which happened
  // a couple of lines ago, thanks to scc.view...
  scc.colorGrid.columnCount = 3;
  scc.colorGrid.rowCount = 4;
  scc.colorGrid.colors = [NSArray arrayWithObjects:
                          [UIColor redColor],
                          [UIColor greenColor],
                          [UIColor blueColor],
                          [UIColor cyanColor],
                          [UIColor yellowColor],
                          [UIColor magentaColor],
                          [UIColor orangeColor],
                          [UIColor purpleColor],
                          [UIColor brownColor],
                          [UIColor whiteColor],
                          [UIColor lightGrayColor],
                          [UIColor blackColor],
                          nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorSelectionDone:) name:ColorSelectionDone object:scc];
  
  [self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)popoverStrokeColor:(id)sender {
  StrokeColorController *scc = [[[StrokeColorController alloc] initWithNibName:@"SelectColorController" bundle:nil] autorelease];
  scc.selectedColor = self.strokeColor;
  [self doPopoverSelectColorController:scc sender:sender];
}
- (IBAction)popoverFillColor:(id)sender {
  FillColorController *fcc = [[[FillColorController alloc] initWithNibName:@"SelectColorController" bundle:nil] autorelease];
  fcc.selectedColor = self.fillColor;
  [self doPopoverSelectColorController:fcc sender:sender];
}
- (IBAction)popoverFontName:(id)sender {
  FontListController *flc = [[[FontListController alloc] initWithStyle:UITableViewStylePlain] autorelease];
  flc.selectedFontName = self.font.fontName;
  [self setupNewPopoverControllerForViewController:flc];
  flc.container = self.currentPopover;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontListControllerDidSelect:) name:FontListControllerDidSelect object:flc];
  [self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)popoverFontSize:(id)sender {
  FontSizeController *fsc = [[[FontSizeController alloc] initWithNibName:nil bundle:nil] autorelease];
  fsc.font = self.font;
  [self setupNewPopoverControllerForViewController:fsc];
  self.currentPopover.popoverContentSize = fsc.view.frame.size;
  [self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [currentTool touchesBegan:touches withEvent:event];
  [dudelView setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [currentTool touchesCancelled:touches withEvent:event];
  [dudelView setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [currentTool touchesEnded:touches withEvent:event];
  [dudelView setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [currentTool touchesMoved:touches withEvent:event];
  [dudelView setNeedsDisplay];
}

#pragma mark Color Grid notifications
- (void)colorSelectionDone:(NSNotification *)notification {
  SelectColorController *object = [notification object];
  UIPopoverController *popoverController = object.container;
  [popoverController dismissPopoverAnimated:YES];
  [self handleDismissedPopoverController:popoverController];
}
#pragma mark Popover controller delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  [self handleDismissedPopoverController:popoverController];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark ToolDelegate

- (void)addDrawable:(id <Drawable>)d {
  [dudelView.drawables addObject:d];
  [dudelView setNeedsDisplay];
}

- (UIView *)viewForUseWithTool:(id <Tool>)t {
  return dudelView;
}

#pragma mark DudelViewDelegate
- (void)drawTemporary {
  [self.currentTool drawTemporary];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
#pragma popover callbacks
- (void)fontListControllerDidSelect:(NSNotification *)notification {
  FontListController *flc = [notification object];
  UIPopoverController *popoverController = flc.container;
  [popoverController dismissPopoverAnimated:YES];
  [self handleDismissedPopoverController:popoverController];
  self.currentPopover = nil;
}
#pragma mark view life-cycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  self.currentTool = [PencilTool sharedPencilTool];
	[pencilButton setImage:[UIImage imageNamed:@"button_cdots_selected.png"]];
  self.fillColor = [UIColor lightGrayColor];
  self.strokeColor = [UIColor blackColor];
  self.font = [UIFont systemFontOfSize:24.0];
  self.strokeWidth = 2.0;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
  self.currentPopover = nil;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
  [self.currentPopover dismissPopoverAnimated:NO];
  self.currentPopover = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
  self.currentTool = nil;
  self.fillColor = nil;
  self.strokeColor = nil;
  self.currentPopover = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}

@end
