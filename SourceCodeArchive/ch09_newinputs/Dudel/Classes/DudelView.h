//
//  DudelView.h
//  Dudel
//
//  Created by JN on 2/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DudelViewDelegate
- (void)drawTemporary;
@end

@interface DudelView : UIView {
  NSMutableArray *drawables;
  IBOutlet id <DudelViewDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray *drawables;

@end
