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

@implementation DudelViewController

@synthesize currentTool, fillColor, strokeColor, strokeWidth, font;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  self.currentTool = [PencilTool sharedPencilTool];
	[pencilButton setImage:[UIImage imageNamed:@"button_cdots_selected.png"]];
  self.fillColor = [UIColor lightGrayColor];
  self.strokeColor = [UIColor blackColor];
  self.strokeWidth = 2.0;
  self.font = [UIFont systemFontOfSize:24.0];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
  self.currentTool = nil;
  self.fillColor = nil;
  self.strokeColor = nil;
  [super dealloc];
}

@end
