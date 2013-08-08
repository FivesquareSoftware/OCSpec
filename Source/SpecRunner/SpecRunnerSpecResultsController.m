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
#import "SpecRunnerExampleGroupHeader.h"

//#import	 "SpecRunnerGroupResults.h"
#import "OCSpec.h"


static NSString *kExampleResultCellIdentifier = @"kExampleResultCellIdentifier";
static NSString *kExampleSectionHeaderViewIdentifier = @"kExampleSectionHeaderViewIdentifier";
#define kSpecResultsControllerTableHeaderHeight 22.f


@interface SpecRunnerSpecResultsController()
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableDictionary *resultsByGroup;
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
	_groups = [NSMutableArray new];
	_resultsByGroup = [NSMutableDictionary new];
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
		
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	
	[self.tableView registerClass:[SpecRunnerExampleResultCell class] forCellReuseIdentifier:kExampleResultCellIdentifier];
	[self.tableView registerClass:[SpecRunnerExampleGroupHeader class] forHeaderFooterViewReuseIdentifier:kExampleSectionHeaderViewIdentifier];
	self.tableView.sectionHeaderHeight = kSpecResultsControllerTableHeaderHeight;
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
	NSMutableArray *results = [self resultsForSection:section];
	NSUInteger count = [results count];
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
	SpecRunnerExampleGroupHeader *headerView;
	if ([self.tableView respondsToSelector:@selector(dequeueReusableHeaderFooterViewWithIdentifier:)]) {
		headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kExampleSectionHeaderViewIdentifier];
	}
	else {
		headerView = [[SpecRunnerExampleGroupHeader alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.sectionHeaderHeight)];
	}
	headerView.textLabel.text = [[[_groups objectAtIndex:section] class] description];
	return headerView;
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
	[_groups removeAllObjects];
	[_resultsByGroup removeAllObjects];
	[self.tableView reloadData];
}

- (NSMutableArray *) resultsForSection:(NSUInteger)section {
	NSMutableArray *results = nil;
	if (section < [_groups count]) {
		OCExampleGroup *group = [_groups objectAtIndex:section];
		results = [self resultsForGroup:group];
	}
	return results;
}

- (NSMutableArray *) resultsForGroup:(OCExampleGroup *)group {
	NSString *key = [[group class] description];
	NSMutableArray *results = _resultsByGroup[key];
	if (results == nil) {
		results = [NSMutableArray new];
		_resultsByGroup[key] = results;
	}
	return results;
}

- (OCExampleResult *) resultAtIndexPath:(NSIndexPath *)indexPath {
	OCExampleResult *result = nil;
	OCExampleGroup *group = [_groups objectAtIndex:indexPath.section];
	if (group) {
		NSMutableArray *results = [self resultsForGroup:group];
		if ([results count] > indexPath.row ) {
			result = results[indexPath.row];
		}
	}
	return result;
}

- (NSIndexPath *) indexPathOfResult:(OCExampleResult *)result {
	OCExampleGroup *group = result.example.group;
	NSUInteger sectionIndex = [_groups indexOfObject:group];
	NSIndexPath *indexPath = nil;
	if (sectionIndex != NSNotFound) {
		NSUInteger resultIndex = [[self resultsForGroup:group] indexOfObject:result];
		if (resultIndex != NSNotFound) {
			indexPath = [NSIndexPath indexPathForRow:resultIndex inSection:sectionIndex];
		}
	}
	return indexPath;
}

- (void) insertGroup:(OCExampleGroup *)group {
	dispatch_async(dispatch_get_main_queue(), ^{
		NSUInteger sectionIndex = [_groups count];
		[_groups addObject:group];
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
		[self.tableView beginUpdates];
		[self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
		[self.tableView endUpdates];
	});
}

- (void) insertResult:(OCExampleResult *)result {
	dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableArray *results = [self resultsForGroup:result.example.group];
		[results addObject:result];
		NSIndexPath *indexPath = [self indexPathOfResult:result];
		if (indexPath) {
			[self.tableView beginUpdates];
			[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
			[self.tableView endUpdates];
			[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		}
	});
}

- (void) reloadResult:(OCExampleResult *)result {
	dispatch_async(dispatch_get_main_queue(), ^{
		NSIndexPath *indexPath = [self indexPathOfResult:result];
		if (indexPath) {
			[self.tableView beginUpdates];
			[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			[self.tableView endUpdates];
		}
	});
}

@end

