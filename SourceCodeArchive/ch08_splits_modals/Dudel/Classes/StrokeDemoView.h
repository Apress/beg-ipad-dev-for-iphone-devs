//
//  StrokeDemoView.h
//  Dudel
//
//  Created by JN on 3/17/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StrokeDemoView : UIView {
  CGFloat strokeWidth;
  UIBezierPath *drawPath;
}

@property (assign, nonatomic) CGFloat strokeWidth;

@end
