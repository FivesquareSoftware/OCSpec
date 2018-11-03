//
//	SpecRunnerAppDelegate.m
//	SpecRunner
//
//	Created by John Clayton on 12/23/2008.
//	Copyright Fivesquare Software, LLC 2008. All rights reserved.
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

#import "SpecRunnerAppDelegate.h"

#import "SpecRunnerSpecResultsController.h"

#import "OCSpec.h"
#import <QuartzCore/QuartzCore.h>

@interface SpecRunnerAppDelegate()
@end

@implementation SpecRunnerAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	  
	
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	_specResultsController = [[SpecRunnerSpecResultsController alloc] initWithStyle:UITableViewStylePlain];
	_navigationController = [[UINavigationController alloc] initWithRootViewController:_specResultsController];
	_navigationController.navigationBar.barStyle = UIBarStyleBlack;

	_window.rootViewController = _navigationController;

	_overlayView = [[UIView alloc] initWithFrame:_window.frame];
	_overlayView.backgroundColor = [UIColor blackColor];
	_overlayView.alpha = 0.f;
	[_navigationController.view addSubview:_overlayView];
	
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_activityIndicator.hidden = YES;
	_activityIndicator.center = _navigationController.view.center;
	[_navigationController.view addSubview:_activityIndicator];
	
	_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _window.bounds.size.width*.9, 32.f)];
	_statusLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.65];
	_statusLabel.layer.cornerRadius = 7.f;
	_statusLabel.font = [UIFont boldSystemFontOfSize:17.f];
//	_statusLabel.numberOfLines = 2;
	_statusLabel.textColor = [UIColor whiteColor];
	_statusLabel.textAlignment = NSTextAlignmentCenter;
	_statusLabel.center = CGPointMake(CGRectGetMidX(_window.bounds), CGRectGetMaxY(_window.bounds)-_statusLabel.bounds.size.height);
	[_navigationController.view addSubview:_statusLabel];
	
//	[_window insertSubview:_navigationController.view belowSubview:_overlayView];

	_window.backgroundColor = [UIColor blackColor];
	if ([_window respondsToSelector:@selector(setTintColor:)]) {
		_window.tintColor = [UIColor whiteColor];
	}
	
	[_window makeKeyAndVisible];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runningSpec:) name:kOCSpecRunnerNotificationExampleStarted object:nil];

	_specRunner = [[OCSpecRunner alloc] initWithExampleGroups:[OCExampleGroup subclasses]];
	self.specRunner.delegate = _specResultsController;
	[self runSpecs:self];
	
	return NO;
}



// ========================================================================== //

#pragma mark - Control


- (void) runSpecsInAnotherThread {
	@autoreleasepool {
		[self.specRunner run];
		[self performSelectorOnMainThread:@selector(stoppedSpecs) withObject:nil waitUntilDone:NO];
	}
}

- (void) runningSpecs {
	[UIView beginAnimations:nil context:nil];
	[_activityIndicator startAnimating];
	_overlayView.alpha = 0.45f;
	_statusLabel.alpha = 1.f;
	[UIView commitAnimations];
}

- (void) runningSpec:(NSNotification *)notification {
	dispatch_async(dispatch_get_main_queue(), ^{
		self.statusLabel.text = [NSString stringWithFormat:@"-> %@",[[notification object] name]];
		//	_statusLabel.text = [notification object];
	});
}
	
- (void) stoppedSpecs {
	[UIView beginAnimations:nil context:nil];
	_overlayView.alpha = 0.f;
	[_activityIndicator stopAnimating];
	_statusLabel.alpha = 0.f;
	[UIView commitAnimations];
}


// ========================================================================== //

#pragma mark - Mail Compose Delegate




// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [_window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}



// ========================================================================== //

#pragma mark - Actions


- (void) emailResults:(id)sender {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		mailComposer.mailComposeDelegate = self;
		
		[mailComposer setSubject:@"<Name> spec results"];
		NSString *results = [self.specRunner toHTML];
		[mailComposer setMessageBody:results isHTML:YES];
		[_window.rootViewController presentViewController:mailComposer animated:YES completion:nil];
	}
}

- (void) runSpecs:(id)sender {
	[self.specResultsController resetResultsData];
	[self runningSpecs];
	[NSThread detachNewThreadSelector:@selector(runSpecsInAnotherThread) toTarget:self withObject:nil];
}




@end
