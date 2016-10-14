//
//  FileRenameViewController.h
//  Dudel
//
//  Created by JN on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileRenameViewControllerDelegate;

@interface FileRenameViewController : UIViewController {
	id <FileRenameViewControllerDelegate> delegate;
  NSString *originalFilename;
  NSString *changedFilename;
  IBOutlet UILabel *textLabel;
  IBOutlet UITextField *textField;
}

@property (nonatomic, retain) id <FileRenameViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *originalFilename;
@property (nonatomic, copy) NSString *changedFilename;

@end

@protocol FileRenameViewControllerDelegate
- (void)fileRenameViewController:(FileRenameViewController *)c didRename:(NSString *)oldFilename to:(NSString *)newFilename;
@end