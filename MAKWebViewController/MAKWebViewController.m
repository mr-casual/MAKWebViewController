//
//  MAKWebViewController.h
//  MAKWebViewController
//
//  Created by Martin Klöpfel on 18.10.13.
//  Copyright (c) 2013 Martin Klöpfel. All rights reserved.
//

#if !__has_feature(objc_arc)
#error "This file requires ARC!"
#endif


#import "MAKWebViewController.h"

@interface MAKWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UIButton *loadingOverlay;

@property (nonatomic) BOOL firstLoad;

@end


@implementation MAKWebViewController

#pragma mark - Initializers

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    return [self initWithURL:nil title:nil];
}

- (id)initWithURL:(NSURL *)url title:(NSString *)title
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        self.url = url;
        self.title = title;
        self.firstLoad = YES;
        self.allowZooming = YES;
    }
    return self;
}


#pragma mark - Private Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.webView];
    if (self.url)
        self.webView.alpha = 0.0f;
    
    self.loadingOverlay = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loadingOverlay.frame = self.webView.frame;
    self.loadingOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.loadingOverlay];
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    self.loadingView.center = CGPointMake(floorf(self.view.frame.size.width/2.0f), floorf(self.view.frame.size.height/2.0f));
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.loadingView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.loadingView.bounds];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    backgroundView.layer.cornerRadius = 16.0f;
    [self.loadingView addSubview:backgroundView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.center = CGPointMake(floorf(self.loadingView.frame.size.width/2.0f), floorf(self.loadingView.frame.size.height/2.0f));
    [self.loadingView addSubview:self.activityIndicatorView];
    
    self.loadingView.alpha = 0.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.firstLoad && self.url)
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)showLoadingView
{
    [self.activityIndicatorView startAnimating];
    self.loadingOverlay.hidden = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.loadingView.alpha = 1.0f;
    }];
}

- (void)hideLoadingView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.webView.alpha = 1.0f;
        self.loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.loadingOverlay.hidden = YES;
        [self.activityIndicatorView stopAnimating];
    }];
}


#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingView];
    self.firstLoad = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoadingView];
    self.firstLoad = NO;
}


#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.webView respondsToSelector:@selector(scrollViewDidScroll:)])
        [self.webView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.webView respondsToSelector:@selector(scrollViewDidZoom:)])
        [self.webView scrollViewDidZoom:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.webView respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        [self.webView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.webView respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        [self.webView scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.webView respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [self.webView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.webView respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [self.webView scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.webView respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [self.webView scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.webView respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [self.webView scrollViewDidEndScrollingAnimation:scrollView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (!self.allowZooming)
        return nil;
    
    if ([self.webView respondsToSelector:@selector(viewForZoomingInScrollView:)])
        return [self.webView viewForZoomingInScrollView:scrollView];
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([self.webView respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)])
        [self.webView scrollViewWillBeginZooming:scrollView withView:view];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.webView respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        [self.webView scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([self.webView respondsToSelector:@selector(scrollViewShouldScrollToTop:)])
        return [self.webView scrollViewShouldScrollToTop:scrollView];
    return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.webView respondsToSelector:@selector(scrollViewDidScrollToTop:)])
        [self.webView scrollViewDidScrollToTop:scrollView];
}

@end
