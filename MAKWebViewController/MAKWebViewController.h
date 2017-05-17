//
//  MAKWebViewController.h
//  MAKWebViewController
//
//  Created by Martin Klöpfel on 18.10.13.
//  Copyright (c) 2013 Martin Klöpfel. All rights reserved.
//

#import "MAKBaseViewController.h"

@interface MAKWebViewController : MAKBaseViewController <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic) BOOL allowZooming;
@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, strong) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title NS_DESIGNATED_INITIALIZER;

- (void)showLoadingView;
- (void)hideLoadingView;

@end
