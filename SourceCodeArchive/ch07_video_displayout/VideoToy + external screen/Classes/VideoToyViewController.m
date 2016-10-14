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

@synthesize urlPaths, externalWindow, selectedCell;

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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateExternalWindow];
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(updateExternalWindow) 
                                               name:UIScreenDidConnectNotification 
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(updateExternalWindow) 
                                               name:UIScreenDidDisconnectNotification 
                                             object:nil];
}

#pragma mark UIScreen notifications
- (void)updateExternalWindow {
  if ([[UIScreen screens] count] > 1) {
    UIScreen *externalScreen = [[UIScreen screens] lastObject];
    UIScreenMode *highestScreenMode = [[externalScreen availableModes] lastObject];
    CGRect externalWindowFrame = CGRectMake(0, 0, [highestScreenMode size].width, [highestScreenMode size].height);
    
    self.externalWindow = [[[UIWindow alloc] initWithFrame:externalWindowFrame] autorelease];
    externalWindow.screen = externalScreen;
    [externalWindow.screen setCurrentMode:highestScreenMode];
    [externalWindow makeKeyAndVisible];
    if (selectedCell) {
      [externalWindow addSubview:selectedCell.mpc.view];
      selectedCell.mpc.view.frame = externalWindow.bounds;
    }
  } else if ([[UIScreen screens] count] == 1) {
    if ([[externalWindow subviews] count] > 0) {
      UIView *v = [[externalWindow subviews] lastObject];
      v.frame = selectedCell.movieViewContainer.bounds;
      [selectedCell.movieViewContainer addSubview:v];
    }
    self.externalWindow.screen = nil;
    self.externalWindow = nil;
  }
}
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
    cell.delegate = self;
    [videoCell autorelease];
    videoCell = nil;
  } else {
    NSLog(@"Re-using previous VideoCell");
  }
  cell.urlPath = [urlPaths objectAtIndex:indexPath.row];
  return cell;
}

- (void)videoCellStartedPlaying:(VideoCell *)cell {
  if (selectedCell != cell) {
    if ([[UIScreen screens] count] > 1) {
      // switching external from one video (or blank) to another
      UIScreen *externalScreen = [[UIScreen screens] lastObject];
      UIScreenMode *highestScreenMode = [[externalScreen availableModes] lastObject];
      CGRect externalWindowFrame = CGRectMake(0, 0, [highestScreenMode size].width, [highestScreenMode size].height);
      
      if ([[externalWindow subviews] count] > 0) {
        // there's already a movie there... put its view back in the cell
        UIView *v = [[externalWindow subviews] lastObject];
        v.frame = selectedCell.movieViewContainer.bounds;
        [selectedCell.movieViewContainer addSubview:v];
      }
      
      self.selectedCell = cell;
            
      self.externalWindow = [[[UIWindow alloc] initWithFrame:externalWindowFrame] autorelease];
      externalWindow.screen = externalScreen;
      [externalWindow.screen setCurrentMode:highestScreenMode];
      [externalWindow makeKeyAndVisible];
      if (selectedCell) {
        [externalWindow addSubview:selectedCell.mpc.view];
        selectedCell.mpc.view.frame = externalWindow.bounds;
      }
    } else if ([[UIScreen screens] count] == 1) {
      
      if ([[externalWindow subviews] count] > 0) {
        UIView *v = [[externalWindow subviews] lastObject];
        v.frame = selectedCell.movieViewContainer.bounds;
        [selectedCell.movieViewContainer addSubview:v];
      }
      self.externalWindow.screen = nil;
      self.externalWindow = nil;

      self.selectedCell = cell;
    }
  }
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
  self.externalWindow = nil;
  self.selectedCell = nil;
  [super dealloc];
}

@end
