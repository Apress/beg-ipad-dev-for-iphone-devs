//
//  MyWebViewController.h
//  MyWeb
//
//

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController <UIWebViewDelegate> {
	UIBarButtonItem *urlButton;
	UIWebView *mywebView;
}

@property (nonatomic, retain) IBOutlet UIWebView *mywebView;

-(IBAction)urlbuttonTapped;

@end

