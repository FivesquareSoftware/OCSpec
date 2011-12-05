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


@interface SpecRunnerAppDelegate()
- (void) runningSpecs;
- (void) stoppedSpecs;
- (void) runSpecsInAnotherThread;
@end

@implementation SpecRunnerAppDelegate

@synthesize window=window_;
@synthesize navigationController=navigationController_;
@synthesize overlayView=overlayView_;
@synthesize activityIndicator=activityIndicator_;
@synthesize specResultsController=specResultsController_;
@synthesize srunner=srunner_;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	  
	
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	specResultsController_ = [[SpecRunnerSpecResultsController alloc] initWithStyle:UITableViewStylePlain];
	navigationController_ = [[UINavigationController alloc] initWithRootViewController:specResultsController_];
	navigationController_.navigationBar.barStyle = UIBarStyleBlack;

	overlayView_ = [[UIView alloc] initWithFrame:window_.frame];
	overlayView_.backgroundColor = [UIColor blackColor];
	overlayView_.alpha = 0.f;
	[window_ addSubview:overlayView_];
	
	activityIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator_.hidden = YES;
	activityIndicator_.center = navigationController_.view.center;
	[window_ addSubview:activityIndicator_];
	
	[window_ insertSubview:navigationController_.view belowSubview:overlayView_];

	window_.backgroundColor = [UIColor blackColor];
	
	[window_ makeKeyAndVisible];

	srunner_ = [[OCSpecRunner alloc] initWithExampleGroups:[OCExampleGroup groups]];
	self.srunner.delegate = specResultsController_;
	[self runSpecs:self];
	
	return NO;
}

- (void) runSpecs:(id)sender {
	[self.specResultsController resetResultsData];
	[self runningSpecs];
	[NSThread detachNewThreadSelector:@selector(runSpecsInAnotherThread) toTarget:self withObject:nil];
}

- (void) runSpecsInAnotherThread {
	@autoreleasepool {
		[self.srunner run];
		[self performSelectorOnMainThread:@selector(stoppedSpecs) withObject:nil waitUntilDone:NO];
	}
}

- (void) runningSpecs {
	[UIView beginAnimations:nil context:nil];
	[activityIndicator_ startAnimating];
	overlayView_.alpha = 0.45f;
	[UIView commitAnimations];
}
	
- (void) stoppedSpecs {
	[UIView beginAnimations:nil context:nil];
	overlayView_.alpha = 0.f;
	[activityIndicator_ stopAnimating];
	[UIView commitAnimations];
}

@end
