//
//  VideoViewController.h
//  HelloCordova
//
//  Created by yyfwptz on 2017/2/20.
//
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)back:(id)sender;
@property(nonatomic) NSInteger flag;
@property(nonatomic) NSInteger len;
@property(assign) NSString* videoUrl;
@end
