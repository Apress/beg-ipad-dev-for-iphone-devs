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

#import "FileList.h"

#import "FontListController.h"
#import "FontSizeController.h"
#import "StrokeWidthController.h"
#import "StrokeColorController.h"
#import "FillColorController.h"
#import "ActionsMenuController.h"
#import "DudelEditController.h"

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

- (void)createDocument {
  [self saveCurrentToFile:[FileList sharedFileList].currentFile];
  [[FileList sharedFileList] createAndSelectNewUntitled];
  dudelView.drawables = [NSMutableArray array];
  [dudelView setNeedsDisplay];
}
- (void)renameCurrentDocument {
	FileRenameViewController *controller = [[FileRenameViewController alloc] initWithNibName:@"FileRenameViewController" bundle:nil];
	controller.delegate = self;
	
	// UIModalPresentationFormSheet has a fixed 540 pixel width and 620 pixel height.
	controller.modalPresentationStyle = UIModalPresentationFormSheet;
  controller.originalFilename = [FileList sharedFileList].currentFile;
	
	[self presentModalViewController:controller animated:YES];
	[controller release];
}
- (void)deleteCurrentDocumentWithConfirmation {
  [[[[UIAlertView alloc] initWithTitle:@"Delete current Dudel" message:@"This will remove your current drawing completely.  Are you sure you want to do that?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete it!", nil] autorelease] show];
}
- (void)sendDudelDocEmail {
  NSString *filepath = [FileList sharedFileList].currentFile;
  
  [self saveCurrentToFile:filepath];
  NSData *fileData = [NSData dataWithContentsOfFile:filepath];
  
  MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
  mailComposer.mailComposeDelegate = self;
  [mailComposer addAttachmentData:fileData mimeType:@"application/octet-stream" fileName:[filepath lastPathComponent]];
  [self presentModalViewController:mailComposer animated:YES];
}
- (NSData *)pdfDataForCurrentDocument {
  // set up PDF rendering context
  NSMutableData *pdfData = [NSMutableData data];
  UIGraphicsBeginPDFContextToData(pdfData, dudelView.bounds, nil);
  UIGraphicsBeginPDFPage();
  
  // tell our view to draw
  [dudelView drawRect:dudelView.bounds];
  
  // remove PDF rendering context
  UIGraphicsEndPDFContext();
  
  return pdfData;
}
- (void)sendPdfEmail {
  NSData *pdfData = [self pdfDataForCurrentDocument];
  
  // send PDF data in mail message
  MFMailComposeViewController *mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
  mailComposer.mailComposeDelegate = self;
  [mailComposer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"Dudel creation.pdf"];
  [self presentModalViewController:mailComposer animated:YES];
}
- (void)openPdfElsewhere {
  NSData *pdfData = [self pdfDataForCurrentDocument];
  NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Dudel creation.pdf"];
  NSURL *fileURL = [NSURL fileURLWithPath:filePath];
  NSError *writeError = nil;
  [pdfData writeToURL:fileURL options:0 error:&writeError];
  if (writeError) {
    NSLog(@"Error writing file '%@' :\n%@", filePath, writeError);
    return;
  }

  UIDocumentInteractionController *docController =
  [UIDocumentInteractionController interactionControllerWithURL:fileURL];
  docController.delegate = self;
  //BOOL result = [docController presentOptionsMenuFromBarButtonItem:actionsMenuButton animated:YES];
  BOOL result = [docController presentOpenInMenuFromBarButtonItem:actionsMenuButton animated:YES];
  [docController retain];
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
  return self;
}
- (void)showAppInfo {
	// The About the Book button was tapped, so display the Modal Web View.
	ModalWebViewController *controller = [[ModalWebViewController alloc] initWithNibName:@"ModalWebViewController" bundle:nil];
	controller.delegate = self;
	
	// UIModalPresentationFormSheet has a fixed 540 pixel width and 620 pixel height.
	controller.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)modalWebViewControllerDidFinish:(ModalWebViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
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
  } else if ([popoverController.contentViewController isMemberOfClass:[ActionsMenuController class]]) {
    ActionsMenuController *amc = (ActionsMenuController *)popoverController.contentViewController;
    switch (amc.selection) {
      case NewDocument:
        [self createDocument];
        break;
      case RenameDocument:
        [self renameCurrentDocument];
        break;
      case DeleteDocument:
        [self deleteCurrentDocumentWithConfirmation];
        break;
      case EmailDudelDoc:
        [self sendDudelDocEmail];
        break;
      case EmailPdf:
        [self sendPdfEmail];
        break;
      case OpenPdfElsewhere:
        [self openPdfElsewhere];
        break;
      case ShowAppInfo:
        [self showAppInfo];
        break;
      default:
        break;
    }
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
- (IBAction)popoverActionsMenu:(id)sender {
  ActionsMenuController *amc = [[[ActionsMenuController alloc] initWithNibName:nil bundle:nil] autorelease];
  [self setupNewPopoverControllerForViewController:amc];
  amc.container = self.currentPopover;
  self.currentPopover.popoverContentSize = CGSizeMake(320, 44*7);
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionsMenuControllerDidSelect:) name:ActionsMenuControllerDidSelect object:amc];
  [self.currentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesBegan");
  [currentTool touchesBegan:touches withEvent:event];
  [dudelView setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesCancelled");
  [currentTool touchesCancelled:touches withEvent:event];
  [dudelView setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesEnded");
  [currentTool touchesEnded:touches withEvent:event];
  [dudelView setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesMoved");
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
- (void)actionsMenuControllerDidSelect:(NSNotification *)notification {
  ActionsMenuController *amc = [notification object];
  UIPopoverController *popoverController = amc.container;
  [popoverController dismissPopoverAnimated:YES];
  [self handleDismissedPopoverController:popoverController];
  self.currentPopover = nil;
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

#pragma mark AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  // we're only using one UIAlertView right now, so no need to check which one this is
  if (buttonIndex == 1) {
    [[FileList sharedFileList] deleteCurrentFile];
    [self loadFromFile:[FileList sharedFileList].currentFile];
    //dudelView.drawables = [NSMutableArray array];
    //[dudelView setNeedsDisplay];
  }
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
- (BOOL)loadFromFile:(NSString *)filename {
  id root = nil;
  @try {
    root = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
  }
  @catch (NSException * e) {
    // do nothing
  }
  @finally {
    // nothing here
  }
  if (root) {
    dudelView.drawables = root;
  } else {
    dudelView.drawables = [NSMutableArray array];
  }
  [dudelView setNeedsDisplay];
  return (root != nil);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  self.currentTool = [PencilTool sharedPencilTool];
	[pencilButton setImage:[UIImage imageNamed:@"button_cdots_selected.png"]];
  self.fillColor = [UIColor lightGrayColor];
  self.strokeColor = [UIColor blackColor];
  self.font = [UIFont systemFontOfSize:12.0];
  self.strokeWidth = 2.0;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
  
  // reload default document
  NSString *filename = [FileList sharedFileList].currentFile;
  [self loadFromFile:filename];
  
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleLongPress:)];
  [dudelView addGestureRecognizer:longPress];
  [longPress release];
}
- (void)dudelEditControllerSelectedDelete:(NSNotification *)n {
  DudelEditController *c = [n object];
  UIPopoverController *popoverController = c.container;
  [popoverController dismissPopoverAnimated:YES];
  [self handleDismissedPopoverController:popoverController];
  self.currentPopover = nil;
  if ([dudelView.drawables count] > 0) {
    [dudelView.drawables removeLastObject];
    [dudelView setNeedsDisplay];
  }
}
- (void)handleLongPress:(UIGestureRecognizer *)gr {
  //NSLog(@"Long Press from recognizer %@", gr);
  if (gr.state == UIGestureRecognizerStateBegan) {
    NSLog(@"show the panel");

    DudelEditController *c = [[[DudelEditController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self setupNewPopoverControllerForViewController:c];
    self.currentPopover.popoverContentSize = CGSizeMake(320, 44*1);
    c.container = self.currentPopover;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dudelEditControllerSelectedDelete:) name:DudelEditControllerDelete object:c];
    CGRect popoverRect = CGRectZero;
    popoverRect.origin = [gr locationInView:dudelView];
    [self.currentPopover presentPopoverFromRect:popoverRect inView:dudelView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
  }
}
- (BOOL)saveCurrentToFile:(NSString *)filename {
  NSLog(@"about to save to %@ with archiver", filename);
  return [NSKeyedArchiver archiveRootObject:dudelView.drawables toFile:filename];
}
- (void)applicationWillTerminate:(NSNotification *)n {
  NSString *filename = [FileList sharedFileList].currentFile;
  [self saveCurrentToFile:filename];
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

#pragma mark UISplitViewControllerDelegate
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
  
  // insert the new item and a spacer into the toolbar
  NSMutableArray *newItems = [[toolbar.items mutableCopy] autorelease];
  [newItems insertObject:barButtonItem atIndex:0];
  UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
  [newItems insertObject:spacer atIndex:1];
  [toolbar setItems:newItems animated:YES];
  
  // configure display of the button
  barButtonItem.title = @"My Dudels";
}
- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button {
  // remove the button, and the spacer that is beside it 
  NSMutableArray *newItems = [[toolbar.items mutableCopy] autorelease];
  if ([newItems containsObject:button]) {
    [newItems removeObject:button];
    [newItems removeObjectAtIndex:0];
    [toolbar setItems:newItems animated:YES];
  }
}
- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController {
  // we don't create this popover on our own, but we want to notice it so that we can dismiss any other popovers, and also remove it later.
  if (self.currentPopover) {
    [self.currentPopover dismissPopoverAnimated:YES];
    [self handleDismissedPopoverController:self.currentPopover];
  }
  self.currentPopover = pc;
}


- (void)fileRenameViewController:(FileRenameViewController *)c didRename:(NSString *)oldFilename to:(NSString *)newFilename {
	[self dismissModalViewControllerAnimated:YES];
}

@end
