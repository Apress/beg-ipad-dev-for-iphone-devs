//
//  ClacHsilopAppDelegate.h
//  ClacHsilop
//
//  Created by JN on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClacHsilopViewController;

@interface ClacHsilopAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ClacHsilopViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ClacHsilopViewController *viewController;

@end

