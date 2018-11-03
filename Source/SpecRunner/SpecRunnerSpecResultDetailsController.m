//
//	SpecRunnerSpecResultDetailsController.m
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

#import "SpecRunnerSpecResultDetailsController.h"

#import "SpecRunnerLabelValueCell.h"
#import "SpecRunnerSpecResultErrorDetailsController.h"

#import "OCExampleResult.h"


static NSString *kResultDetailsCellIdentifier = @"kResultDetailsCellIdentifier";

enum  {
	kSpecRunnerSpecResultDetailsControllerSectionGroup
	, kSpecRunnerSpecResultDetailsControllerSectionExampleName
	, kSpecRunnerSpecResultDetailsControllerSectionExampleContext
	, kSpecRunnerSpecResultDetailsControllerSectionExampleTime
	, kSpecRunnerSpecResultDetailsControllerSectionExampleStatus
	, kSpecRunnerSpecResultDetailsControllerSectionExampleError
};

@implementation SpecRunnerSpecResultDetailsController

// ========================================================================== //

#pragma mark - Properties


- (void) setResult:(OCExampleResult *)newResult {
	if(_result != newResult){
		_result = newResult;
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
	return YES;
}



// ========================================================================== //

#pragma mark - Table View 

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return kSpecRunnerSpecResultDetailsControllerSectionExampleError+1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SpecRunnerLabelValueCell *cell = (SpecRunnerLabelValueCell *)[tableView dequeueReusableCellWithIdentifier:kResultDetailsCellIdentifier];
	if(cell == nil) {
		cell = [[SpecRunnerLabelValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kResultDetailsCellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	switch (indexPath.row) {
		case kSpecRunnerSpecResultDetailsControllerSectionGroup:
			cell.keyLabel.text = @"Group";
			cell.valueLabel.text = [self.result.example.group description];
			break;
		case kSpecRunnerSpecResultDetailsControllerSectionExampleName:
			cell.keyLabel.text = @"Example";
			cell.valueLabel.text = self.result.example.name;
			break;
		case kSpecRunnerSpecResultDetailsControllerSectionExampleContext:
			cell.keyLabel.text = @"Context";
			cell.valueLabel.text = self.result.context;
			break;
		case kSpecRunnerSpecResultDetailsControllerSectionExampleTime:
			cell.keyLabel.text = @"Elapsed";
			cell.valueLabel.text = [NSString stringWithFormat:@"%.2fs",self.result.elapsed];
			break;
		case kSpecRunnerSpecResultDetailsControllerSectionExampleStatus:
			cell.keyLabel.text = @"Status";
			cell.valueLabel.text = self.result.success ? @"Success" : @"Fail";
			break;
		case kSpecRunnerSpecResultDetailsControllerSectionExampleError:
			cell.keyLabel.text = @"Error";
			if(self.result.error) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				cell.valueLabel.text = [self.result.error name];
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.valueLabel.text = @"";
			}
			break;
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

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == kSpecRunnerSpecResultDetailsControllerSectionExampleError) {
		return indexPath;
	}
	return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(self.result.error) {
		SpecRunnerSpecResultErrorDetailsController *errorDetailsController = [[SpecRunnerSpecResultErrorDetailsController alloc] initWithStyle:UITableViewStylePlain];
		errorDetailsController.error = self.result.error;
		[self.navigationController pushViewController:errorDetailsController animated:YES];
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	SpecRunnerLabelValueCell *cell = (SpecRunnerLabelValueCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	CGSize fitSize = [cell sizeThatFits:CGSizeZero];
	CGFloat height = fitSize.height;
	return height;
}




@end

