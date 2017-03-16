//
//  Video3ViewController.m
//  HelloCordova
//
//  Created by yyfwptz on 2017/3/13.
//
//

#import "Video3ViewController.h"
#include "avformat.h"
#include "avcodec.h"
#import "KxMovieViewController.h"

@interface Video3ViewController ()

@end

@implementation Video3ViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    //    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    self.tableView.backgroundColor = [UIColor whiteColor];
    //    //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
    //    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //
    //    [self.view addSubview:self.tableView];
}

- (BOOL)prefersStatusBarHidden { return YES; }


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [ NSURL URLWithString:@"http://10.10.90.6:8080/GetVideoList.do"];
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
            NSString *prefix = @"http://10.10.90.6:8080";
            NSLog(@"the url is:%@", prefix);
            _path = [NSString stringWithFormat:@"%@%@", prefix, _videoUrl];
            NSLog(@"the url is:%@", _path);
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            if ([_path.pathExtension isEqualToString:@"wmv"])
                parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
            
            KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:_path parameters:parameters];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }] resume];
    
    //    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:_videoUrl]];
    //    NSString *fakeUrl = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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

@end
