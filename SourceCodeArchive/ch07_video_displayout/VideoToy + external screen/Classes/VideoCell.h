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
  id delegate;
}

@property (retain, nonatomic) UIView *movieViewContainer;
@property (retain, nonatomic) NSString *urlPath;
@property (retain, nonatomic) MPMoviePlayerController *mpc;
@property (assign, nonatomic) id delegate;

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeight;

@end

@protocol VideoCellDelegate
- (void)videoCellStartedPlaying:(VideoCell *)cell;
@end