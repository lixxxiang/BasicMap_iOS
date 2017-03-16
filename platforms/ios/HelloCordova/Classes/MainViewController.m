#import "MainViewController.h"
#import "Video3ViewController.h"

NSMutableArray *Array;

@implementation MainViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {}
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)seg:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [self.commandDelegate evalJs:[NSString stringWithFormat:@"selectLayers(%lu)",(unsigned long)0]];
            break;
        case 1:
            [self.commandDelegate evalJs:[NSString stringWithFormat:@"selectLayers(%lu)",(unsigned long)1]];
            break;
        case 2:
            [self.commandDelegate evalJs:[NSString stringWithFormat:@"selectLayers(%lu)",(unsigned long)2]];
            break;
        default:
            break;
    }
}


- (IBAction)layer:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"The categories you want to browse are:"message:@"您要浏览的种类是："preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *archiveAction1 = [UIAlertAction actionWithTitle:@"图层信息"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        /*
         获取后台数据
         */
        NSMutableArray *tempArray = [NSMutableArray array];
        NSURL *url = [ NSURL URLWithString:@"http://10.10.90.6:8080/GetInitialLayers.do?xmlname=LayersCollection"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (data && !error) {
                id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                NSDictionary *dict = obj[@"layers"];
                NSDictionary *dict2 = dict[@"layer"];
                NSString *url = [dict2 valueForKey:@"credit"];
                [tempArray addObject:url];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CHOOSE LAYER PLEASE"message:@"请选择图层"preferredStyle: UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                /*
                 添加alertsheet
                 */
                
                for(int i = 0; i < (unsigned long)[[tempArray objectAtIndex:0] count]; i++)
                    [alertController addAction:[UIAlertAction actionWithTitle:[[tempArray objectAtIndex:0] objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [self.commandDelegate evalJs:[NSString stringWithFormat:@"selectMap(%i)",i]];
                    }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }] resume];
        
    }];
    
    UIAlertAction *archiveAction2 = [UIAlertAction actionWithTitle:@"视频信息"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        /*
         获取视频名称
         */
        NSMutableArray *tempArray2 = [NSMutableArray array];
        NSURL *url2 = [ NSURL URLWithString:@"http://10.10.90.6:8080/GetVideoList.do"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url2];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (data && !error) {
                id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                NSDictionary *dict = obj[@"videos"];
                NSDictionary *dict2 = dict[@"video"];
                NSString *url2 = [dict2 valueForKey:@"name"];
                [tempArray2 addObject:url2];
                
                /*
                 添加alertsheet
                 */
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    // reload data on collection view or table view
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CHOOSE VIDEO PLEASE"message:@"请选择视频"preferredStyle: UIAlertControllerStyleActionSheet];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    for(int i = 0; i < (unsigned long)[[tempArray2 objectAtIndex:0] count]; i++)
                        [alertController addAction:[UIAlertAction actionWithTitle:[[tempArray2 objectAtIndex:0] objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            /*
                             添加是否播放视频
                             */
                            
                            [self.commandDelegate evalJs:[NSString stringWithFormat:@"selectVideo(%i)", i]];
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否立刻播放视频"message:@"注：该视频为测试视频"preferredStyle: UIAlertControllerStyleActionSheet];
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
                            
                            UIAlertAction *archiveAction1 = [UIAlertAction actionWithTitle:@"是"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                Video3ViewController *video3ViewController = [[Video3ViewController alloc] initWithNibName:@"Video3ViewController" bundle:nil];
                                video3ViewController.flag = 1;
                                [self presentViewController:video3ViewController animated:YES completion:nil];
                            }];
                            
                            UIAlertAction *archiveAction2 = [UIAlertAction actionWithTitle:@"否"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
                            
                            [alertController addAction:cancelAction];
                            [alertController addAction:archiveAction1];
                            [alertController addAction:archiveAction2];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                        }]];
                });
            }
        }] resume];

    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:archiveAction1];
    [alertController addAction:archiveAction2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)satellite:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意"message:@"卫星轨道功能要求设备级别较高，建议iPhone6以上机型保持开启，若播放卡顿，请点击关闭；若载入较慢，请耐心等待，勿重复点击"preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了"style:UIAlertActionStyleCancel handler:nil];
    
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"satellite()"]];
    
}

- (IBAction)home:(id)sender {
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"backHome()"]];
}

- (IBAction)compass:(id)sender {
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"compass(compass)"]];
}

- (IBAction)locate:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意"message:@"抱歉，功能暂未开放"preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
 in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
 in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

-(void)playVideo
{
    
}

@end
