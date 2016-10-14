//
//  MyWebAppDelegate.h
//  MyWeb
//
//

#import <UIKit/UIKit.h>

@class MyWebViewController;

@interface MyWebAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MyWebViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MyWebViewController *viewController;

@end

