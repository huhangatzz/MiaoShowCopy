//
//  MB_HomeWebViewController.m
//  MiaoShow
//
//  Created by huhang on 16/9/7.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeWebViewController.h"

@interface MB_HomeWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation MB_HomeWebViewController

- (UIWebView *)webView{

    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        
        webView.delegate = self;
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (instancetype)initWithUrlStr:(NSString *)urlStr{

    if (self = [super init]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
    return self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.progressHud show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.progressHud hide:YES];
}

@end
