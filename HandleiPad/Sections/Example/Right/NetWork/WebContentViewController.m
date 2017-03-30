//
//  WebContentViewController.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "WebContentViewController.h"
#import <SafariServices/SafariServices.h>
@interface WebContentViewController ()<SFSafariViewControllerDelegate>

@property (nonatomic, copy) SFSafariViewController *safariViewController;

@end

@implementation WebContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeVC:) name:WEBLIST_DISAPPEAR_NOTIFICATION object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews
{
    self.safariViewController.view.frame = self.view.bounds;
}

- (void)setSafariURL:(NSURL *)safariURL
{
    
    _safariURL = safariURL;
    
    if (_safariViewController)
    {
        [self.safariViewController removeFromParentViewController];
        [self.safariViewController.view removeFromSuperview];
        self.safariViewController = nil;
    }
    
    _safariViewController = [[SFSafariViewController alloc] initWithURL:self.safariURL];
    self.safariViewController.delegate = self;
    [self addChildViewController:self.safariViewController];
    [self.view addSubview:self.safariViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)closeVC:(NSNotification *)noti
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WEB_URL_TAP_NOTIFICATION object:nil];
}

/*! @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller is dismissed modally. */
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WEB_URL_TAP_NOTIFICATION object:nil];
}

/*! @abstract Invoked when the initial URL load is complete.
 @param success YES if loading completed successfully, NO if loading failed.
 @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
 to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
 */
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully
{
    
}


@end
