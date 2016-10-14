//
//  VideoToyViewController.m
//  VideoToy
//
//  Created by JN on 6/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "VideoToyViewController.h"

#import "VideoCell.h"

@implementation VideoToyViewController

@synthesize urlPaths;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

#pragma mark Tableview delegate/datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [VideoCell rowHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [urlPaths count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:[VideoCell reuseIdentifier]];
  if (!cell) {
    NSLog(@"loading VideoCell from nib");
    [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
    cell = videoCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [videoCell autorelease];
    videoCell = nil;
  } else {
    NSLog(@"Re-using previous VideoCell");
  }
  cell.urlPath = [urlPaths objectAtIndex:indexPath.row];
  return cell;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
  self.urlPaths = nil;
  [super dealloc];
}

@end
