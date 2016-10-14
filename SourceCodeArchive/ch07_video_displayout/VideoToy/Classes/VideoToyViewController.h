//
//  VideoToyViewController.h
//  VideoToy
//
//  Created by JN on 6/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class VideoCell;

@interface VideoToyViewController : UITableViewController {
  NSMutableArray *urlPaths;
  
  IBOutlet VideoCell *videoCell;
}

@property (retain, nonatomic) NSMutableArray *urlPaths;

@end

