//
//  TextManglerAppDelegate.h
//  TextMangler
//
//  Created by JN on 4/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextManglerViewController;

@interface TextManglerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TextManglerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TextManglerViewController *viewController;

@end

