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

#import	 "SpecRunnerGroupResults.h"
#import "OCSpec.h"


static NSString *kExampleResultCellIdentifier = @"kExampleResultCellIdentifier";


@interface SpecRunnerSpecResultsController()
- (SpecRunnerGroupResults *) resultsForGroup:(Class)aGroup index:(NSUInteger *)index;
- (void) addResult:(OCExampleResult *)result;
@end


@implementation SpecRunnerSpecResultsController


// ========================================================================== //

#pragma mark - Properties


@synthesize tableData=tableData_;
@synthesize headerView=headerView_;
@synthesize headerLabel=headerLabel_;




// ========================================================================== //

#pragma mark - View Controller

- (void) viewDidLoad {	  
	[super viewDidLoad];
	
	self.title = @"Spec Results";
	
	UIBarButtonItem *runButton = [[UIBarButtonItem alloc] initWithTitle:@"Run" style:UIBarButtonItemStyleBordered target:[[UIApplication sharedApplication] delegate] action:@selector(runSpecs:)];
	self.navigationItem.rightBarButtonItem = runButton;
	
	headerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.f, 25.f)];
	headerView_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	headerView_.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.50];
	
	headerLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 0, 302.f, 25.f)];
	headerLabel_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	headerLabel_.textColor = [UIColor whiteColor];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
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
	return [self.tableData count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if([self hasResults]) {
		SpecRunnerGroupResults *resultsAtIndex = (SpecRunnerGroupResults *)[self.tableData objectAtIndex:section];
		return [resultsAtIndex numberOfResults];
	}
	return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SpecRunnerGroupResults *groupAtIndex = (SpecRunnerGroupResults *)[self.tableData objectAtIndex:indexPath.section];
	OCExampleResult *resultAtIndex = [groupAtIndex resultAtIndex:indexPath.row];
	SpecRunnerExampleResultCell *cell = (SpecRunnerExampleResultCell *)[tableView dequeueReusableCellWithIdentifier:kExampleResultCellIdentifier];
	if(cell == nil) {
        cell = [[SpecRunnerExampleResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kExampleResultCellIdentifier];
	}
	cell.result = resultAtIndex;
	return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SpecRunnerGroupResults *groupAtIndex = (SpecRunnerGroupResults *)[self.tableData objectAtIndex:indexPath.section];
	OCExampleResult *resultAtIndex = [groupAtIndex resultAtIndex:indexPath.row];

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
		aLabel.textAlignment = UITextAlignmentLeft;
		aLabel.textColor = [UIColor whiteColor]; 
		aLabel.text = [(SpecRunnerGroupResults *)[self.tableData objectAtIndex:section] description];
		[hview addSubview:aLabel];
		return hview;
	}
	return nil;
}





// ========================================================================== //

#pragma mark - Spec Runner Delegate


- (void) exampleDidFinish:(OCExampleResult *)result {
	[self addResult:result];
}
	 
- (void) errorRunningGroup:(NSDictionary *)errorInfo {
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

#pragma mark - Helpers

- (void) resetResultsData {
	self.tableData = [NSMutableArray new];
}

- (BOOL) hasResults {
	return [self.tableData count] > 0;
}

- (SpecRunnerGroupResults *) resultsForGroup:(Class)aGroup index:(NSUInteger *)index {
	__block SpecRunnerGroupResults *foundGroup = nil;	
	[self.tableData enumerateObjectsUsingBlock:^(SpecRunnerGroupResults *results, NSUInteger idx, BOOL *stop) {
		if (results.group == aGroup) {
			foundGroup = results;
			if (index) {
				*index = idx;
			}
			*stop = YES;
		}
	}];
	if (nil == foundGroup) {
		NSUInteger idx = [self.tableData count];
		if (index) {
			*index = idx;
		}
		foundGroup = [SpecRunnerGroupResults withGroup:aGroup];
		[self.tableData addObject:foundGroup];
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self.tableView beginUpdates];
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:idx] withRowAnimation:UITableViewRowAnimationNone];
			[self.tableView endUpdates];
		});
		
	}
	return foundGroup;
}

- (void) addResult:(OCExampleResult *)result {	  
	NSUInteger section;
	SpecRunnerGroupResults *groupResults = [self resultsForGroup:result.group index:&section];
	NSUInteger row = [groupResults numberOfResults];
	[groupResults addResult:result];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
	dispatch_sync(dispatch_get_main_queue(), ^{
		[self.tableView beginUpdates];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
		[self.tableView endUpdates];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	});

}

@end

