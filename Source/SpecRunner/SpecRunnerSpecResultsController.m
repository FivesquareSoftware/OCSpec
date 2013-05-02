//
//	SpecRunnerSpecResultsController.m
//	SpecRunner
//
//	Created by John Clayton on 12/23/2008.
//	Copyright 2008 Fivesquare Software, LLC. All rights reserved.
//

/* 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE. */


#import "SpecRunnerSpecResultsController.h"

#import "SpecRunnerAppDelegate.h"
#import "SpecRunnerExampleResultCell.h"
#import "SpecRunnerSpecResultDetailsController.h"

//#import	 "SpecRunnerGroupResults.h"
#import "OCSpec.h"


static NSString *kExampleResultCellIdentifier = @"kExampleResultCellIdentifier";


@interface SpecRunnerSpecResultsController()
@property (nonatomic, strong) NSMutableSet *groups;
@property (nonatomic, readonly) BOOL hasResults;
@end


@implementation SpecRunnerSpecResultsController


// ========================================================================== //

#pragma mark - Properties

@dynamic hasResults;
- (BOOL) hasResults {
	return [self.groups count] > 0;
}


// ========================================================================== //

#pragma mark - Object



- (void) initialize {
	// Initialization code
	_groups = [NSMutableSet new];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
		[self initialize];
    }
    return self;
}





// ========================================================================== //

#pragma mark - View Controller

- (void) viewDidLoad {	  
	[super viewDidLoad];
	
	self.title = @"Spec Results";
	
	UIBarButtonItem *runButton = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(runSpecs:)];
	self.navigationItem.rightBarButtonItem = runButton;
	
	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.f, 25.f)];
	_headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.50];
	
	_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 0, 302.f, 25.f)];
	_headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_headerLabel.textColor = [UIColor whiteColor];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	[self.tableView registerClass:[SpecRunnerExampleResultCell class] forCellReuseIdentifier:kExampleResultCellIdentifier];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animate {
	[super setEditing:editing animated:animate];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}



// ========================================================================== //

#pragma mark - Table View Data Source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	NSUInteger count = [self.groups count];
	return count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSUInteger count = 0;
	if([self hasResults]) {
		OCExampleGroup *group = [self groupAtIndex:section];
		 count = [group numberOfResults];
	}
	return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	OCExampleResult *resultAtIndex = [self resultAtIndexPath:indexPath];
	SpecRunnerExampleResultCell *cell = (SpecRunnerExampleResultCell *)[tableView dequeueReusableCellWithIdentifier:kExampleResultCellIdentifier];
	[cell updateWithResult:resultAtIndex];
	return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	OCExampleResult *resultAtIndex = [self resultAtIndexPath:indexPath];

	SpecRunnerSpecResultDetailsController *detailViewController = [[SpecRunnerSpecResultDetailsController alloc] initWithStyle:UITableViewStylePlain];
	detailViewController.result = resultAtIndex;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if([self hasResults]) {
		UIView *hview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 22.0)];
		hview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		hview.backgroundColor = [UIColor blackColor];
		hview.alpha = 0.5;
		UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0, 308.0, 22.0)];
		aLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		aLabel.opaque = NO;
		aLabel.backgroundColor = [UIColor clearColor];
		aLabel.font = [UIFont boldSystemFontOfSize:14.0];
		aLabel.textAlignment = NSTextAlignmentLeft;
		aLabel.textColor = [UIColor whiteColor]; 
		aLabel.text = [[[self groupAtIndex:section] class] description];
		[hview addSubview:aLabel];
		return hview;
	}
	return nil;
}





// ========================================================================== //

#pragma mark - Spec Runner Delegate

- (void) exampleGroupDidStart:(OCExampleGroup *)group {
	[self insertGroup:group];
}

- (void) exampleDidStart:(OCExampleResult *)result {
	[self insertResult:result];
}

- (void) exampleDidFinish:(OCExampleResult *)result {
	[self reloadResult:result];
}
	 
- (void) exampleGroupDidFailWithError:(NSError *)error {
	
	NSDictionary *errorInfo = [error userInfo];
	Class group = [errorInfo objectForKey:kOCErrorInfoKeyGroup];
//	  NSString *msg = [errorInfo objectForKey:kOCErrorInfoKeyMessage];
	
	NSString *alertMsg = [NSString stringWithFormat:@"Could not run group '%@'",group];
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle:@"Spec Error" 
						  message:alertMsg 
						  delegate:self 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
}
	 

// ========================================================================== //

#pragma mark - Model Access

- (void) resetResultsData {
	[self.groups removeAllObjects];
	[self.tableView reloadData];
}

- (OCExampleGroup *) groupAtIndex:(NSUInteger)index {
	NSSet *objects = [_groups objectsPassingTest:^BOOL(OCExampleGroup *obj, BOOL *stop) {
		return obj.index == index;
	}];
	OCExampleGroup *group = [objects anyObject];
	return group;
}

- (OCExampleResult *) resultAtIndexPath:(NSIndexPath *)indexPath {
	OCExampleGroup *group = [self groupAtIndex:indexPath.section];
	return [group resultAtIndex:indexPath.row];
}

- (void) insertGroup:(OCExampleGroup *)group {
	dispatch_async(dispatch_get_main_queue(), ^{
//		NSInteger numberOfSections = [self.tableView numberOfSections];
		[_groups addObject:group];
//		if (group.index >= numberOfSections) {
//			NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:group.index];
//			[self.tableView beginUpdates];
//			[self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//			[self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//			[self.tableView endUpdates];
//		}
		[self.tableView reloadData];
	});
}

- (void) insertResult:(OCExampleResult *)result {
	dispatch_async(dispatch_get_main_queue(), ^{
//		NSIndexPath *indexPath = result.example.indexPath;
//		NSInteger numberOfRows = [self.tableView numberOfRowsInSection:indexPath.section];
//		if (indexPath.row >= numberOfRows) {
//			[self.tableView beginUpdates];
//			[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//			[self.tableView endUpdates];
//			[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//		}
//		NSIndexPath *indexPath = result.example.indexPath;
//		[self.tableView beginUpdates];
//		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//		[self.tableView endUpdates];
		[self.tableView reloadData];
	});
}

- (void) reloadResult:(OCExampleResult *)result {
	dispatch_async(dispatch_get_main_queue(), ^{
		NSIndexPath *indexPath = result.example.indexPath;
//		[self.tableView beginUpdates];
//		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//		[self.tableView endUpdates];
		[self.tableView reloadData];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	});
}

@end

