//
//  TLAboutViewController.m
//  ThirdLimb
//
//  Created by Keith Lee on 1/25/14.
//  Copyright (c) 2014 Motu Presse. All rights reserved.
//

#import "TLAboutViewController.h"
#import "TLWebViewController.h"

@interface TLAboutViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation TLAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
	// Do any additional setup after loading the view.
  [self.webView setDelegate:self];
  NSBundle *bundle = [NSBundle mainBundle];
  NSURL *indexFileURL = [bundle URLForResource:@"About" withExtension:@"html"];
  [self.webView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
  [self.webView setScalesPageToFit:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [self.webView reload];
  [self.webView stringByEvaluatingJavaScriptFromString:@"var e = document.createEvent('Events'); e.initEvent('orientationchange', true, false); document.dispatchEvent(e);"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Split view methods

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
  // Create image for bar button item!
  barButtonItem.title = NSLocalizedString(@"Third Limb", @"Third Limb");
  [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
  self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  // Called when the view is shown again in the split view, invalidating the button and popover controller.
  [self.navigationItem setLeftBarButtonItem:nil animated:YES];
  self.masterPopoverController = nil;
}


#pragma mark -
#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    if ([request.URL.scheme isEqualToString:@"mailto"]) {
      if ([MFMailComposeViewController canSendMail]) {
        // Create controller
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setToRecipients:@[@"support@motupresse.com"]];
        [picker setSubject:@"Third Limb Support"];
        
        // Present view
        picker.navigationBar.barStyle = UIBarStyleBlack;
        [self presentViewController:picker animated:YES completion:NULL];
      }
      return NO;
    }
    if ([request.URL.scheme isEqualToString:@"file"]) {
      NSBundle *bundle = [NSBundle mainBundle];
      NSString *path;
      NSScanner *scanner = [NSScanner scannerWithString:request.URL.pathComponents[1]];
      [scanner scanUpToString:@"." intoString:&path];
      NSURL *indexFileURL = [bundle URLForResource:path withExtension:@"html"];
      [self performSegueWithIdentifier:@"WebViewSegue"
                                sender:indexFileURL];
      return NO;
    }
  }
  return YES;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
  // Notifies users about errors associated with the interface
  switch (result)
  {
    case MFMailComposeResultCancelled:
    case MFMailComposeResultSaved:
    case MFMailComposeResultSent:
    case MFMailComposeResultFailed:
      break;
    default:
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles: nil];
      [alert show];
    }
      break;
  }
  [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -
#pragma mark - Segue method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"WebViewSegue"]) {
    TLWebViewController *viewController = segue.destinationViewController;
    viewController.url = sender;
  }
}

@end