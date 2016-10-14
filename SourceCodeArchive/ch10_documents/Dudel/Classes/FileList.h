//
//  FileList.h
//  Dudel
//
//  Created by JN on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FileListChanged @"FileListChanged"

@interface FileList : NSObject {
  NSMutableArray *allFiles;
  NSString *currentFile;
}

@property (nonatomic, readonly) NSArray *allFiles;
@property (nonatomic, copy) NSString *currentFile;

+ (FileList *)sharedFileList;

- (void)deleteCurrentFile;
- (void)renameFile:(NSString *)oldFilename to:(NSString *)newFilename;
- (void)renameCurrentFile:(NSString *)newFilename;
- (NSString *)createAndSelectNewUntitled;
- (void)importAndSelectFromURL:(NSURL *)url;
@end
