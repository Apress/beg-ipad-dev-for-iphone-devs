//
//  TextDrawingInfo.m
//  Dudel
//
//  Created by JN on 3/10/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TextDrawingInfo.h"
#import <CoreText/CoreText.h>

static NSString *fontFaceNameFromString(NSString *attrData) {
  NSScanner *attributeDataScanner = [NSScanner scannerWithString:attrData];
  NSString *faceName = nil;
  if ([attributeDataScanner scanUpToString:@"face=\"" intoString:NULL]) {
    [attributeDataScanner scanString:@"face=\"" intoString:NULL];
    if ([attributeDataScanner scanUpToString:@"\"" intoString:&faceName]) {
      return faceName;
    }
  }
  return nil;
}
static CGFloat fontSizeFromString(NSString *attrData) {
  NSScanner *attributeDataScanner = [NSScanner scannerWithString:attrData];
  NSString *sizeString = nil;
  if ([attributeDataScanner scanUpToString:@"size=\"" intoString:NULL]) {
    [attributeDataScanner scanString:@"size=\"" intoString:NULL];
    if ([attributeDataScanner scanUpToString:@"\"" intoString:&sizeString]) {
      return [sizeString floatValue];
    }
  }
  return 0.0;
}
static UIColor *fontColorFromString(NSString *attrData) {
  return nil;
}

@implementation TextDrawingInfo

@synthesize path, strokeColor, font, text;

- initWithPath:(UIBezierPath*)p text:(NSString*)t strokeColor:(UIColor*)s font:(UIFont*)f {
  if ((self = [self init])) {
    path = [p retain];
    strokeColor = [s retain];
    font = [f retain];
    text = [t copy];
  }
  return self;
}
+ (id)textDrawingInfoWithPath:(UIBezierPath *)p text:t strokeColor:(UIColor *)s font:(UIFont *)f {
  return [[[self alloc] initWithPath:p text:t strokeColor:s font:f] autorelease];
}
- (void)dealloc {
  self.path = nil;
  self.strokeColor = nil;
  self.font = nil;
  self.text = nil;
  [super dealloc];
}
- (NSAttributedString *)attributedStringFromMarkup:(NSString *)markup {
  NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
  NSString *nextTextChunk = nil;
  NSScanner *markupScanner = [NSScanner scannerWithString:markup];
  CGFloat fontSize = 0.0;
  NSString *fontFace = nil;
  UIColor *fontColor = nil;
  while (![markupScanner isAtEnd]) {
    [markupScanner scanUpToString:@"<" intoString:&nextTextChunk];
    [markupScanner scanString:@"<" intoString:NULL];
    if ([nextTextChunk length] > 0) {
      CTFontRef currentFont = CTFontCreateWithName((CFStringRef)(fontFace ? fontFace : self.font.fontName),
                                            (fontSize != 0.0 ? fontSize : self.font.pointSize),
                                            NULL);
      UIColor *color = fontColor ? fontColor : self.strokeColor;
      NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                             (id)color.CGColor, kCTForegroundColorAttributeName,
                             (id)currentFont, kCTFontAttributeName, 
                             nil];
      NSLog(@"defining attributes for '%@'", nextTextChunk);
      NSAttributedString *newPiece = [[[NSAttributedString alloc] initWithString:nextTextChunk attributes:attrs] autorelease];
      [attrString appendAttributedString:newPiece];
      CFRelease(currentFont);
    }
    NSString *elementData = nil;
    [markupScanner scanUpToString:@">" intoString:&elementData];
    [markupScanner scanString:@">" intoString:NULL];
    if (elementData) {
      NSLog(@"encountered element data %@", elementData);
      if ([elementData length] > 3 && [[elementData substringToIndex:4] isEqual:@"font"]) {
        fontFace = fontFaceNameFromString(elementData);
        fontSize = fontSizeFromString(elementData);
        fontColor = fontColorFromString(elementData);
      } else if ([elementData length] > 4 && [[elementData substringToIndex:5] isEqual:@"/font"]) {
        // reset all values
        fontSize = 0.0;
        fontFace = nil;
        fontColor = nil;
      }
    }
  }
  return attrString;
}

- (void)draw {
  CGContextRef context = UIGraphicsGetCurrentContext();

  //NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:self.text] autorelease];
  //[attrString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.strokeColor.CGColor range:NSMakeRange(0, [self.text length])];
  NSAttributedString *attrString = [self attributedStringFromMarkup:self.text];
  CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
  
  CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), self.path.CGPath, NULL);
  CFRelease(framesetter);
  //CFRelease(attrString);
  if (frame) {
    CGContextSaveGState(context);
    
    // Core Text wants to draw our text upside-down!  This flips it the 
    // right way.
    CGContextTranslateCTM(context, 0, path.bounds.origin.y);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -(path.bounds.origin.y + path.bounds.size.height));

    CTFrameDraw(frame, context);

    CGContextRestoreGState(context);

    CFRelease(frame);
  } else {
    NSLog(@"no frame!");
  }
}

@end
