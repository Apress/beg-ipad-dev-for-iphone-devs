//
//  ModalWebViewController.h
//  BookPromo
//
//  Created by Dave Wooldridge on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalWebViewControllerDelegate;

@interface ModalWebViewController : UIViewController {
	id <ModalWebViewControllerDelegate> delegate;
	UIWebView *webView;

}

@property (nonatomic, assign) id <ModalWebViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
- (IBAction)done;
- (IBAction)apressSite;
- (IBAction)amazonSite;

@end


@protocol ModalWebViewControllerDelegate
- (void)modalWebViewControllerDidFinish:(ModalWebViewController *)controller;
@end
