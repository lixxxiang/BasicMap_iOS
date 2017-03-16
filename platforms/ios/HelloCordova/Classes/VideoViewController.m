//
//  VideoViewController.m
//  HelloCordova
//
//  Created by yyfwptz on 2017/2/20.
//
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [ NSURL URLWithString:@"http://10.10.90.6:8089/GetVideoList.ashx"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        if (data && !error) {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            for (NSDictionary *dic in obj[@"videos"][@"video"]) {
                NSString *array = [dic valueForKey:@"src"];
                _len++;
                if (_len == _flag)
                    _videoUrl = array;
            }
            NSLog(@"the url is:%@", _videoUrl);
        }
    }] resume];
    
//    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:_videoUrl]];
    NSString *fakeUrl = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:fakeUrl]];
    [_webView loadRequest:request2];
    _webView.allowsInlineMediaPlayback = YES;
    _webView.mediaPlaybackRequiresUserAction = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated成功");
    }];
}
@end
