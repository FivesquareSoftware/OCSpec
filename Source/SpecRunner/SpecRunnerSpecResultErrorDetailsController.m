//
//	SpecRunnerSpecResultErrorDetailsController.m
//	SpecRunner
//
//	Created by John Clayton on 12/24/2008.
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

#import "SpecRunnerSpecResultErrorDetailsController.h"

#import "SpecRunnerLabelValueCell.h"

static NSString *kResultErrorDetailsCellIdentifier = @"kResultErrorDetailsCellIdentifier";

enum  {
	kSpecRunnerSpecResultErrorDetailsControllerSectionErrorName
	, kSpecRunnerSpecResultErrorDetailsControllerSectionErrorReason
	, kSpecRunnerSpecResultErrorDetailsControllerSectionErrorInfo
	, kSpecRunnerSpecResultErrorDetailsControllerSectionErrorTrace
};

#define HEIGHT 45.0
#define TEXT_VPADDING 10.0

@implementation SpecRunnerSpecResultErrorDetailsController

// ========================================================================== //

#pragma mark - Properties


@synthesize error=error_;

- (void) setError:(NSException *)newError {
	if(error_ != newError) {
		error_ = newError;
		[self.tableView reloadData];
	}
}



// ========================================================================== //

#pragma mark - View Controller

- (void) viewDidLoad {	  
	[super viewDidLoad];
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

#pragma mark - Table View



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SpecRunnerLabelValueCell *cell;
	cell = (SpecRunnerLabelValueCell *)[tableView dequeueReusableCellWithIdentifier:kResultErrorDetailsCellIdentifier];
	if(cell == nil) {
        cell = [[SpecRunnerLabelValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResultErrorDetailsCellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.valueLabel.numberOfLines = 0; // unlimited
	}
	switch (indexPath.row) {
		case kSpecRunnerSpecResultErrorDetailsControllerSectionErrorName:
			cell.keyLabel.text = @"Name";
			cell.valueLabel.text = [self.error name];
			return cell;
		case kSpecRunnerSpecResultErrorDetailsControllerSectionErrorReason:
			cell.keyLabel.text = @"Reason";
			cell.valueLabel.text = [self.error reason];
			return cell;
		case kSpecRunnerSpecResultErrorDetailsControllerSectionErrorInfo:
			cell.keyLabel.text = @"Info";

			if([self.error userInfo]) {
				cell.valueLabel.text = [[self.error userInfo] description];
			} else {
				cell.valueLabel.text = @"";
			}
			return cell;
		case kSpecRunnerSpecResultErrorDetailsControllerSectionErrorTrace:
			cell.keyLabel.text = @"Trace";

			if([self.error callStackReturnAddresses]) {
				cell.valueLabel.text = [[self.error callStackSymbols] description];
			} else {
				cell.valueLabel.text = @"";
			}
			return cell;
		default:
			break;
	}
	return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	SpecRunnerLabelValueCell *cell = (SpecRunnerLabelValueCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	CGSize fitSize = [cell sizeThatFits:CGSizeZero];
	CGFloat height = fitSize.height;
	return height;
}





@end
