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
- (void) runSpecsInAnotherThread;
@end

@implementation SpecRunnerAppDelegate

@synthesize window;
@synthesize specResultsController;
@synthesize srunner;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {	  
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	specResultsController = [[SpecRunnerSpecResultsController alloc] initWithStyle:UITableViewStylePlain];
	navigationController = [[UINavigationController alloc] initWithRootViewController:specResultsController];
	navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	// Override point for customization after app launch	
	[window addSubview:[navigationController view]];

	specResultsController.view.alpha = 0.0;
	window.backgroundColor = [UIColor blackColor];
	
	[window makeKeyAndVisible];

	srunner = [[OCSpecRunner alloc] initWithExampleGroups:[OCExampleGroup groups]];
	self.srunner.delegate = specResultsController;
	[self runSpecs:self];
	
	return NO;
}


- (void) dealloc {
	[specResultsController release];
	[window release];
	[srunner release];
	[super dealloc];
}

- (void) runSpecs:(id)sender {
	[self.specResultsController resetResultsData];
	[self runningSpecs];
	[NSThread detachNewThreadSelector:@selector(runSpecsInAnotherThread) toTarget:self withObject:nil];
}

- (void) runSpecsInAnotherThread {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[self.srunner run];
	[self performSelectorOnMainThread:@selector(stoppedSpecs) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (void) runningSpecs {
	[UIView beginAnimations:nil context:nil];
	[activityIndicator startAnimating];
	specResultsController.view.alpha = 0.0;
	[UIView commitAnimations];
}
	
- (void) stoppedSpecs {
	[UIView beginAnimations:nil context:nil];
	specResultsController.view.alpha = 1.0;
	[activityIndicator stopAnimating];
	[UIView commitAnimations];
}

@end
