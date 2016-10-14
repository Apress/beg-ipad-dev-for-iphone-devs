//
//  VideoToyAppDelegate.h
//  VideoToy
//
//  Created by JN on 6/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoToyViewController;

@interface VideoToyAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    VideoToyViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet VideoToyViewController *viewController;

@end

