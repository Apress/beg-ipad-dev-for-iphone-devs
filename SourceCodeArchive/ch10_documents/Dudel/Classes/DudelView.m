//
//  DudelView.m
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "DudelView.h"

#import "Drawable.h"

@implementation DudelView

@synthesize drawables;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    drawables = [[NSMutableArray alloc] initWithCapacity:100];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    drawables = [[NSMutableArray alloc] initWithCapacity:100];    
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  for (<Drawable> d in drawables) {
    [d draw];
  }
  [delegate drawTemporary];
}

- (void)dealloc {
  [drawables release];
  [super dealloc];
}


@end
