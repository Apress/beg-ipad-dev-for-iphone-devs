//
//  VideoCell.h
//  VideoToy
//
//  Created by JN on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoCell : UITableViewCell {
  IBOutlet UIView *movieViewContainer;
  IBOutlet UILabel *urlLabel;
  NSString *urlPath;
  MPMoviePlayerController *mpc;
}

@property (retain, nonatomic) NSString *urlPath;
@property (retain, nonatomic) MPMoviePlayerController *mpc;

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeight;

@end
