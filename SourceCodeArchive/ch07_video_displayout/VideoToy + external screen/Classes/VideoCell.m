//
//  VideoCell.m
//  VideoToy
//
//  Created by JN on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VideoCell.h"


@implementation VideoCell

@synthesize urlPath, mpc, movieViewContainer, delegate;

+ (NSString *)reuseIdentifier {
  return @"VideoCell";
}
+ (CGFloat)rowHeight {
  return 200;
}

- (void)setupMpc {
  if (mpc) {
    // we've already got one of these, time to get rid of it
    [mpc.view removeFromSuperview];
    self.mpc = nil;
  }
  if (urlPath) {
    NSURL *url = [NSURL fileURLWithPath:self.urlPath];
    self.mpc = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
    mpc.shouldAutoplay = NO;
    NSLog(@"In %@, player view is %@", self, mpc.view);
    mpc.view.frame = movieViewContainer.bounds;
    [movieViewContainer addSubview:mpc.view];
  }
}
- (void)setUrlPath:(NSString *)p {
  if (![p isEqual:urlPath]) {
    [urlPath autorelease];
    urlPath = [p retain];
    if (urlPath && !mpc) {
      [self setupMpc];
    }
    urlLabel.text = urlPath;
  }
}
- (void)awakeFromNib {
  if (urlPath && !mpc) {
    [self setupMpc];
  }
  urlLabel.text = urlPath;
}

- (void)dealloc {
  self.urlPath = nil;
  self.mpc = nil;
  self.movieViewContainer = nil;
  [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  
  [super setSelected:selected animated:animated];
  
  if ([delegate respondsToSelector:@selector(videoCellStartedPlaying:)]) {
    [delegate videoCellStartedPlaying:self];
  }
  
  // Configure the view for the selected state
  [mpc play];
}

@end
