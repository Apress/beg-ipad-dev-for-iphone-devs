//
//  ClacHsilopViewController.m
//  ClacHsilop
//
//  Created by JN on 4/13/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ClacHsilopViewController.h"

@implementation ClacHsilopViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  stack = [[NSMutableArray alloc] init];
  decimalFormatter = [[NSNumberFormatter alloc] init];
  decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
  [stackTableView reloadData];
  [inputView becomeFirstResponder];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}
- (void)dealloc {
  [stack release];
  [decimalFormatter release];
  [super dealloc];
}
#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [stack count];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  cell.detailTextLabel.text = [decimalFormatter stringFromNumber:[stack objectAtIndex:indexPath.row]];
  
  return cell;
}
#pragma mark calculator methods
- (void)handleError {
  // in case of an error, push the current number onto the stack instead of just tossing it
  NSDecimalNumber *inputNumber = [NSDecimalNumber decimalNumberWithString:inputView.text];
  [stack insertObject:inputNumber atIndex:0];
  inputView.text = @"Error";  
}
- (void)doEnter {
  NSDecimalNumber *inputNumber = [NSDecimalNumber decimalNumberWithString:inputView.text];
  [stack insertObject:inputNumber atIndex:0];
  [stackTableView reloadData];
  inputView.text = @"0";
}
- (void)doDecimalArithmetic:(SEL)method {
  if ([stack count] > 0) {
    NSDecimalNumber *inputNumber = [NSDecimalNumber decimalNumberWithString:inputView.text];
    NSDecimalNumber *stackNumber = [stack objectAtIndex:0];
    NSDecimalNumber *result = [stackNumber performSelector:method withObject:inputNumber];
    inputView.text = [decimalFormatter stringFromNumber:result];
    [stack removeObjectAtIndex:0];
  } else {
    [self handleError];
  }
  [stackTableView reloadData];
}
#pragma mark InputViewDelegate
- (void)doTaggedAction:(ActionTag)tag forInputView:(InputView *)iv {
  switch (tag) {
    case ActionEnter:
      [self doEnter];
      break;
    case ActionDivide:
      [self doDecimalArithmetic:@selector(decimalNumberByDividingBy:)];
      break;
    case ActionMultiply:
      [self doDecimalArithmetic:@selector(decimalNumberByMultiplyingBy:)];
      break;
    case ActionSubtract:
      [self doDecimalArithmetic:@selector(decimalNumberBySubtracting:)];
      break;
    case ActionAdd:
      [self doDecimalArithmetic:@selector(decimalNumberByAdding:)];
      break;
    default:
      break;
  }
}

@end
