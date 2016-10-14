//
//  FileListController.h
//  Dudel
//
//  Created by JN on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// notification name
#define FileListControllerSelectedFile @"FileListControllerSelectedFile"
#define FileListControllerFilename @"FileListControllerFilename"

@interface FileListViewController : UITableViewController {
  NSString *currentDocumentFilename;
  NSArray *documents;
}

@property (nonatomic, copy) NSString *currentDocumentFilename;
@property (nonatomic, retain) NSArray *documents;

@end
