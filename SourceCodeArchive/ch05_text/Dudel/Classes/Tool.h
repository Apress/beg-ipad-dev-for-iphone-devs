//
//  Tool.h
//  Dudel
//
//  Created by JN on 2/24/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolDelegate;
@protocol Drawable;

@protocol Tool <NSObject>

@property (assign, nonatomic) id <ToolDelegate> delegate;
- (void)activate;
- (void)deactivate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)drawTemporary;
@end

@protocol ToolDelegate

- (void)addDrawable:(id <Drawable>)d;
- (UIView *)viewForUseWithTool:(id <Tool>)t;
- (UIColor *)strokeColor;
- (UIColor *)fillColor;
- (CGFloat)strokeWidth; 
- (UIFont *)font;

@end
