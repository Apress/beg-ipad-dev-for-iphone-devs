    //
//  ModalWebViewController.m
//  BookPromo
//
//  Created by Dave Wooldridge on 3/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ModalWebViewController.h"


@implementation ModalWebViewController

@synthesize delegate;
@synthesize webView;

- (void)viewDidLoad {
	// Load the bookInfo.html file into the UIWebView.
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bookInfo" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

    [super viewDidLoad];
}

- (IBAction)done {
	// The Done button was tapped, so close Modal Web View.
	[self.delegate modalWebViewControllerDidFinish:self];	
}

- (IBAction)apressSite {
	// The More Info or Buy eBook button was tapped, so 
	// go to the Apress.com book web page in Mobile Safari.
	NSURL *url = [NSURL URLWithString:@"http://www.apress.com/book/view/9781430230212"];
	[[UIApplication sharedApplication] openURL:url];
}

- (IBAction)amazonSite {
	// The Buy Print Book button was tapped, so go to
	// the Amazon.com book web page in Mobile Safari.
	NSURL *url = [NSURL URLWithString:@"http://www.amazon.com/Beginning-iPad-Development-iPhone-Developers/dp/1430230215/"];
	[[UIApplication sharedApplication] openURL:url];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [webView release];
    [super dealloc];
}


@end
