//
//  FileRenameViewController.m
//  Dudel
//
//  Created by JN on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileRenameViewController.h"

#import "FileList.h"

@implementation FileRenameViewController

@synthesize delegate;
@synthesize originalFilename;
@synthesize changedFilename;

- (void)viewDidLoad {
  [super viewDidLoad];
  UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 77.0)];
  inputAccessoryView.backgroundColor = [UIColor darkGrayColor];
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  cancelButton.frame = CGRectMake(20.0, 20.0, 100.0, 37.0);
  [cancelButton setTitle: @"Cancel" forState:UIControlStateNormal];
  [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(cancel:)
       forControlEvents:UIControlEventTouchUpInside];
  [inputAccessoryView addSubview:cancelButton];
  textField.inputAccessoryView = inputAccessoryView;
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  textField.text = [[originalFilename lastPathComponent] stringByDeletingPathExtension];
  textLabel.text = @"Please enter a new file name for the current Dudel."; 
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [textField becomeFirstResponder];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}
- (void)dealloc {
  self.delegate = nil;
  self.originalFilename = nil;
  self.changedFilename = nil;
  [super dealloc];
}
- (void)textFieldDidEndEditing:(UITextField *)tf {
  NSString *dirPath = [originalFilename stringByDeletingLastPathComponent];
  self.changedFilename = [[dirPath stringByAppendingPathComponent:tf.text] stringByAppendingPathExtension:@"dudeldoc"];
  if ([[FileList sharedFileList].allFiles containsObject:self.changedFilename]) {
    textLabel.text = @"A file with that name already exists! Please enter a different file name."; 
  } else {
    [[FileList sharedFileList] renameFile:self.originalFilename to:self.changedFilename];
    [delegate fileRenameViewController:self didRename:originalFilename to:changedFilename];
  }
}
- (BOOL)textFieldShouldReturn:(UITextField *)tf {
  [tf endEditing:YES];
  return YES;
}
- (void)cancel:(id)sender {
  [delegate fileRenameViewController:self didRename:originalFilename to:originalFilename];
}

@end