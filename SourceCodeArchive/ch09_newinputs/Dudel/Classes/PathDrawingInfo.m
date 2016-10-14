//
//  PathDrawingInfo.m
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PathDrawingInfo.h"


@implementation PathDrawingInfo

@synthesize path, fillColor, strokeColor;

- (id)initWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s {
  if ((self = [self init])) {
    path = [p retain];
    fillColor = [f retain];
    strokeColor = [s retain];
  }
  return self;
}
+ (id)pathDrawingInfoWithPath:(UIBezierPath *)p fillColor:(UIColor *)f strokeColor:(UIColor *)s {
  return [[[self alloc] initWithPath:p fillColor:f strokeColor:s] autorelease];
}
- (void)dealloc {
  self.path = nil;
  self.fillColor = nil;
  self.strokeColor = nil;
  [super dealloc];
}

- (void)draw {
  if (self.fillColor) {
    [self.fillColor setFill];
    [self.path fill];
  }
  if (self.strokeColor) {
    [self.strokeColor setStroke];
    [self.path stroke];
  }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.path forKey:@"path"];
  [encoder encodeObject:self.fillColor forKey:@"fillColor"];
  [encoder encodeObject:self.strokeColor forKey:@"strokeColor"];
}

- (id)initWithCoder:(NSCoder *)decoder {
  if ((self = [self init])) {
    self.path = [decoder decodeObjectForKey:@"path"];
    self.fillColor = [decoder decodeObjectForKey:@"fillColor"];
    self.strokeColor = [decoder decodeObjectForKey:@"strokeColor"];
  }
  return self;
}

@end
