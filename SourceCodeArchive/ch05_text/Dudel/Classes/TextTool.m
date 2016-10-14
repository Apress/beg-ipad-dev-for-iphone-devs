//
//  TextTool.m
//  Dudel
//
//  Created by JN on 3/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TextTool.h"
#import "TextDrawingInfo.h"

#import "SynthesizeSingleton.h"

#define SHADE_TAG 10000

static CGFloat distanceBetween(const CGPoint p1, const CGPoint p2) {
  return sqrt(pow(p1.x-p2.x, 2) + pow(p1.y-p2.y, 2));
}

@implementation TextTool

@synthesize delegate, completedPath;

SYNTHESIZE_SINGLETON_FOR_CLASS(TextTool);

- init {
  if ((self = [super init])) {
    trackingTouches = [[NSMutableArray arrayWithCapacity:100] retain];
    startPoints = [[NSMutableArray arrayWithCapacity:100] retain];
  }
  return self;
}

- (void)activate {
}

- (void)deactivate {
  [trackingTouches removeAllObjects];
  [startPoints removeAllObjects];
  self.completedPath = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"touchesBegan");
  UIView *touchedView = [delegate viewForUseWithTool:self];
  [touchedView endEditing:YES];
  // we only track one touch at a time for this tool.
  UITouch *touch = [[event allTouches] anyObject];
  // remember the touch, and its original start point, for future
  [trackingTouches addObject:touch];
  CGPoint location = [touch locationInView:touchedView];
  [startPoints addObject:[NSValue valueWithCGPoint:location]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UIView *touchedView = [delegate viewForUseWithTool:self];
  for (UITouch *touch in [event allTouches]) {
    // make a rect from the start point to the current point
    NSUInteger touchIndex = [trackingTouches indexOfObject:touch];
    // only if we actually remember the start of this touch...
    if (touchIndex != NSNotFound) {
      CGPoint startPoint = [[startPoints objectAtIndex:touchIndex] CGPointValue];
      CGPoint endPoint = [touch locationInView:touchedView];
      [trackingTouches removeObjectAtIndex:touchIndex];
      [startPoints removeObjectAtIndex:touchIndex];
      
      // detect short taps that are too small to contain any text;
      // these are probably accidents
      if (distanceBetween(startPoint, endPoint) < 5.0) return;
      
      CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
      self.completedPath = [UIBezierPath bezierPathWithRect:rect];
      
      // draw a shaded area over the entire view, so that the user can
      // easily see where to focus their attention.
      UIView *backgroundShade = [[[UIView alloc] initWithFrame:touchedView.bounds] autorelease];
      backgroundShade.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
      backgroundShade.tag = SHADE_TAG;
      backgroundShade.userInteractionEnabled = NO;
      [touchedView addSubview:backgroundShade];
      
      // now comes the fun part.  we make a temporary UITextView for the
      // actual text input.
      UITextView *textView = [[[UITextView alloc] initWithFrame:rect] autorelease];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
      
      textView.delegate = self;
      [touchedView addSubview:textView];
      textView.editable = NO;
      textView.editable = YES;
      [touchedView becomeFirstResponder];
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
}

- (void)drawTemporary {
  if (self.completedPath) {
    [delegate.strokeColor setStroke];
    [self.completedPath stroke];
  } else {
    UIView *touchedView = [delegate viewForUseWithTool:self];
    for (int i = 0; i<[trackingTouches count]; i++) {
      UITouch *touch = [trackingTouches objectAtIndex:i];
      CGPoint startPoint = [[startPoints objectAtIndex:i] CGPointValue];
      CGPoint endPoint = [touch locationInView:touchedView];
      CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
      UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
      [delegate.strokeColor setStroke];
      [path stroke];
    }
  }
}

- (void)dealloc {
  self.completedPath = nil;
  [trackingTouches release];
  [startPoints release];
  self.delegate = nil;
  [super dealloc];
}

#pragma mark Sliding the view

#ifdef FIX_THIS_SLIDING_BUSINESS
// this isn't quite working right.  will revisit this later.
// for now, just going to plough ahead as if it works.
- (void)keyboardWillShow:(NSNotification *)aNotification {	
  UIInterfaceOrientation orientation = ((UIViewController*)delegate).interfaceOrientation;
	[UIView beginAnimations:@"viewSlideUp" context:NULL];
  UIView *view = [delegate viewForUseWithTool:self];
  CGRect frame = [view frame];
  switch (orientation) {
    case UIInterfaceOrientationLandscapeLeft:
      frame.origin.x -= 60; 
      break;
    case UIInterfaceOrientationLandscapeRight:
      frame.origin.x += 60; 
      break;
    case UIInterfaceOrientationPortrait:
      frame.origin.y -= 60; 
      break;
    case UIInterfaceOrientationPortraitUpsideDown:
      frame.origin.y += 60; 
      break;
    default:
      break;
  }
  [view setFrame:frame];
	[UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)aNotification {
  UIInterfaceOrientation orientation = ((UIViewController*)delegate).interfaceOrientation;
	[UIView beginAnimations:@"viewSlideDown" context:NULL];
  UIView *view = [delegate viewForUseWithTool:self];
  CGRect frame = [view frame];
  switch (orientation) {
    case UIInterfaceOrientationLandscapeLeft:
      frame.origin.x += 60; 
      break;
    case UIInterfaceOrientationLandscapeRight:
      frame.origin.x -= 60; 
      break;
    case UIInterfaceOrientationPortrait:
      frame.origin.y += 60; 
      break;
    case UIInterfaceOrientationPortraitUpsideDown:
      frame.origin.y -= 60; 
      break;
    default:
      break;
  }
  [view setFrame:frame];
	[UIView commitAnimations];
}
#else
- (void)keyboardWillShow:(NSNotification *)aNotification {}
- (void)keyboardWillHide:(NSNotification *)aNotification {}
#endif

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
  NSLog(@"textViewDidBeginEditing");
}

// This is called when the user taps outside the textView, or dismisses
// the keyboard.
- (void)textViewDidEndEditing:(UITextView *)textView {
  NSLog(@"textViewDidEndEditing");
  TextDrawingInfo *info = [TextDrawingInfo textDrawingInfoWithPath:completedPath text:textView.text strokeColor:delegate.strokeColor font:delegate.font];
  [delegate addDrawable:info];
  self.completedPath = nil;
  UIView *superView = [textView superview];
  [[superView viewWithTag:SHADE_TAG] removeFromSuperview];
  [textView resignFirstResponder];
  [textView removeFromSuperview];
}

@end
