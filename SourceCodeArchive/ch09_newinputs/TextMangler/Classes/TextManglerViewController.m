//
//  TextManglerViewController.m
//  TextMangler
//
//  Created by JN on 4/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TextManglerViewController.h"

@implementation TextManglerViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  UIMenuItem *menuItem = [[[UIMenuItem alloc] init] autorelease];
  menuItem.title = @"Open URL in Safari";
  menuItem.action = @selector(openUrlInSafari:);
  [UIMenuController sharedMenuController].menuItems = [NSArray arrayWithObject:menuItem];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  if (action == @selector(openUrlInSafari:)) {
    NSString *selectedText = [textView.text substringWithRange:textView.selectedRange];
    NSURL *url = [NSURL URLWithString:selectedText];
    return [[UIApplication sharedApplication] canOpenURL:url];
  }
  return [super canPerformAction:action withSender:sender];
}

- (void)openUrlInSafari:(id)sender {
  NSString *selectedText = [textView.text substringWithRange:textView.selectedRange];
	NSURL *url = [NSURL URLWithString:selectedText];
	[[UIApplication sharedApplication] openURL:url];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
