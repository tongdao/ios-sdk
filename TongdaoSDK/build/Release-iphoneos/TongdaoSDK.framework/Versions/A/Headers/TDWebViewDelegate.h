//
//  TDWebViewDelegate.h
//  TongdaoSDK
//
//  Created by Alex on 24/02/2017.
//  Copyright © 2017 Tongdao. All rights reserved.
//


@interface TDWebViewDelegate : UIViewController<UIWebViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
