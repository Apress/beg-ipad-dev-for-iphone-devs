//
//  MyWebViewController.m
//  MyWeb
//
//

#import "MyWebViewController.h"

@implementation MyWebViewController

@synthesize mywebView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.mywebView.delegate = self;
    [super viewDidLoad];
}

- (IBAction)urlbuttonTapped {
	// The button was tapped, so display the specified web site.
	NSURL *url = [NSURL URLWithString:@"http://www.apress.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.mywebView loadRequest:request];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Web View finished loading, so notify the user.
	UIAlertView *buttonAlert = [[UIAlertView alloc] initWithTitle:@"Welcome to Apress.com" message:@"The home page has finished loading. Thanks for visiting!" delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil];
	[buttonAlert show];
	[buttonAlert release];
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

- (void)dealloc {
	mywebView.delegate = nil;
    [mywebView release];
    [super dealloc];
}

@end
