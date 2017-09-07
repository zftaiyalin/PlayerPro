//
//  WifiViewController.m
//  XiaoShuoTool
//
//  Created by 曾富田 on 2017/5/17.
//  Copyright © 2017年 TheLastCode. All rights reserved.
//

#import "WifiViewController.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHttpConnection.h"
#import "HTTPConnection.h"

#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
//#import "wwanconnect.h//frome apple 你可能没有哦
#import <SystemConfiguration/SystemConfiguration.h>
#import "UploadViewController.h"
#import "AppLocaVideoModel.h"
#import "WifiVideoTableViewCell.h"
#import "MoviePlayerViewController.h"


static const int ddLogLevel = LOG_LEVEL_VERBOSE;/*打乱代码结构*/

@interface WifiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
   	HTTPServer *httpServer;/*打乱代码结构*/
    UITableView *_tableView;/*打乱代码结构*/
    UILabel *label;/*打乱代码结构*/
    NSMutableArray *videoArray;/*打乱代码结构*/
}

@end

@implementation WifiViewController
- (NSString *) localWiFiIPAddress
{
    BOOL success;/*打乱代码结构*/
    struct ifaddrs * addrs;/*打乱代码结构*/
    const struct ifaddrs * cursor;/*打乱代码结构*/
    success = getifaddrs(&addrs) == 0;/*打乱代码结构*/
    if (success) {
        cursor = addrs;/*打乱代码结构*/
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];/*打乱代码结构*//*打乱代码结构*/
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];/*打乱代码结构*//*打乱代码结构*/
            }
            cursor = cursor->ifa_next;/*打乱代码结构*/
        }
        freeifaddrs(addrs);/*打乱代码结构*/
    }
    return nil;/*打乱代码结构*/
}
- (void)viewDidLoad {
    [super viewDidLoad];/*打乱代码结构*//*打乱代码结构*/
    self.title = @"本地资源";/*打乱代码结构*/
    videoArray = [NSMutableArray array];/*打乱代码结构*//*打乱代码结构*/
    self.view.backgroundColor = [UIColor whiteColor];/*打乱代码结构*//*打乱代码结构*/
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"wifi.png"] style:UIBarButtonItemStylePlain target:self action:@selector(pushWifi)];/*打乱代码结构*//*打乱代码结构*/
    
    self.navigationItem.rightBarButtonItem = item;/*打乱代码结构*/
    
    // Do any additional setup after loading the view, typically from a nib.
    // Configure our logging framework.
    // To keep things simple and fast, we're just going to log to the Xcode console.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];/*打乱代码结构*//*打乱代码结构*/
    
    // Initalize our http server
    httpServer = [[HTTPServer alloc] init];/*打乱代码结构*//*打乱代码结构*/
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [httpServer setType:@"_http._tcp."];/*打乱代码结构*//*打乱代码结构*/
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [httpServer setPort:16000];/*打乱代码结构*//*打乱代码结构*/
    
    // Serve files from the standard Sites folder
//    NSString *docRoot = [[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"web"] stringByDeletingLastPathComponent];/*打乱代码结构*//*打乱代码结构*/
    
    
    NSString *docRoot = [[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] stringByDeletingLastPathComponent];/*打乱代码结构*//*打乱代码结构*/
    DDLogInfo(@"Setting document root: %@", docRoot);/*打乱代码结构*/
    
    [httpServer setDocumentRoot:docRoot];/*打乱代码结构*//*打乱代码结构*/
    
    [httpServer setConnectionClass:[MyHttpConnection class]];/*打乱代码结构*//*打乱代码结构*/
    
    NSError *error = nil;/*打乱代码结构*/
    if(![httpServer start:&error])
    {
        DDLogError(@"Error starting HTTP Server: %@", error);/*打乱代码结构*/
    }
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];/*打乱代码结构*//*打乱代码结构*/
    _tableView.dataSource = self;/*打乱代码结构*/
    _tableView.delegate = self;/*打乱代码结构*/
    _tableView.hidden = YES;/*打乱代码结构*/
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;/*打乱代码结构*/
    [_tableView registerClass:[WifiVideoTableViewCell class] forCellReuseIdentifier:@"cell"];/*打乱代码结构*//*打乱代码结构*/
    [self.view addSubview:_tableView];/*打乱代码结构*//*打乱代码结构*/
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);/*打乱代码结构*/
        make.top.equalTo(self.view);/*打乱代码结构*/
        make.bottom.equalTo(self.view).offset(-50);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
    
    label = [[UILabel alloc]init];/*打乱代码结构*//*打乱代码结构*/
    label.textColor = [UIColor colorWithHexString:@"#bfbfbf"];/*打乱代码结构*//*打乱代码结构*/
    label.font = [UIFont systemFontOfSize:15];/*打乱代码结构*//*打乱代码结构*/
    label.textAlignment = NSTextAlignmentCenter;/*打乱代码结构*/
    label.numberOfLines = 0;/*打乱代码结构*/
    label.text = @"没有可以播放的视频\n您可以通过iTunes软件或WiFi文件传输导入视频";/*打乱代码结构*/
    [self.view addSubview:label];/*打乱代码结构*//*打乱代码结构*/
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);/*打乱代码结构*/
        make.width.equalTo(self.view);/*打乱代码结构*/
    }];/*打乱代码结构*//*打乱代码结构*/
    
  
}

-(void)pushWifi{
    UploadViewController *vc = [[UploadViewController alloc]init];/*打乱代码结构*//*打乱代码结构*/
    
    
    NSString *ip = [self localWiFiIPAddress];/*打乱代码结构*//*打乱代码结构*/
    NSLog(@"%@",ip);/*打乱代码结构*/
    vc.ipString = [NSString stringWithFormat:@"http://%@:16000",ip];/*打乱代码结构*//*打乱代码结构*/
    [self.navigationController pushViewController:vc animated:YES];/*打乱代码结构*//*打乱代码结构*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];/*打乱代码结构*//*打乱代码结构*/
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];/*打乱代码结构*//*打乱代码结构*/
    [self getVideoArrayToPhone];/*打乱代码结构*//*打乱代码结构*/
    
    
}


-(void)getVideoArrayToPhone{
    
    [videoArray removeAllObjects];/*打乱代码结构*//*打乱代码结构*/
    NSString* path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"resourse"];/*打乱代码结构*//*打乱代码结构*/

    
    NSFileManager *myFileManager=[NSFileManager defaultManager];/*打乱代码结构*//*打乱代码结构*/
    
    NSDirectoryEnumerator *myDirectoryEnumerator;/*打乱代码结构*/
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];/*打乱代码结构*//*打乱代码结构*/
    
    //列举目录内容，可以遍历子目录
    
    NSLog(@"用enumeratorAtPath:显示目录%@的内容：",path);/*打乱代码结构*/
    
    NSString *resPath = [NSString stringWithFormat:@"%@",path];/*打乱代码结构*//*打乱代码结构*/
    
    while((path=[myDirectoryEnumerator nextObject])!=nil)
        
    {
        
        NSLog(@"===============%@",path);/*打乱代码结构*/
        
        
        if ([[path pathExtension] isEqualToString:@"mp4"] || [[path pathExtension] isEqualToString:@"MP4"] || [[path pathExtension] isEqualToString:@"MPG"] || [[path pathExtension] isEqualToString:@"mpg"] || [[path pathExtension] isEqualToString:@"3GP"] || [[path pathExtension] isEqualToString:@"3gp"] || [[path pathExtension] isEqualToString:@"XVID"] || [[path pathExtension] isEqualToString:@"xvid"] || [[path pathExtension] isEqualToString:@"RM"] || [[path pathExtension] isEqualToString:@"rm"] || [[path pathExtension] isEqualToString:@"RMVB"] || [[path pathExtension] isEqualToString:@"rmvb"] || [[path pathExtension] isEqualToString:@"MKV"] || [[path pathExtension] isEqualToString:@"mkv"] || [[path pathExtension] isEqualToString:@"AVI"] || [[path pathExtension] isEqualToString:@"avi"] || [[path pathExtension] isEqualToString:@"WMV"] || [[path pathExtension] isEqualToString:@"wmv"] ) {
            
            
            AppLocaVideoModel *loacModel = [[AppLocaVideoModel alloc]init];/*打乱代码结构*//*打乱代码结构*/
            
            NSString *videoPath = [resPath stringByAppendingPathComponent:path];/*打乱代码结构*//*打乱代码结构*/
            loacModel.image = [AppUnitl getImage:videoPath];/*打乱代码结构*//*打乱代码结构*/
            loacModel.time = [AppUnitl getTime:videoPath];/*打乱代码结构*//*打乱代码结构*/
            NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:[AppUnitl fileSizeAtPath:videoPath]
                                                                   countStyle:NSByteCountFormatterCountStyleFile];/*打乱代码结构*//*打乱代码结构*/
            
            loacModel.size = fileSizeStr;/*打乱代码结构*/
            loacModel.title = path;/*打乱代码结构*/
            loacModel.path = videoPath;/*打乱代码结构*/
            
            [videoArray addObject:loacModel];/*打乱代码结构*//*打乱代码结构*/
            
            
            
        }
        
        
    }
    
    if (videoArray.count > 0) {
        _tableView.hidden = NO;/*打乱代码结构*/
        label.hidden = YES;/*打乱代码结构*/
         [_tableView reloadData];/*打乱代码结构*//*打乱代码结构*/
    }else{
        _tableView.hidden = YES;/*打乱代码结构*/
        label.hidden = NO;/*打乱代码结构*/
    }
    
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return videoArray.count;/*打乱代码结构*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;/*打乱代码结构*/
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WifiVideoTableViewCell *cell =(WifiVideoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];/*打乱代码结构*//*打乱代码结构*/
    cell.selectionStyle = UITableViewCellSelectionStyleNone;/*打乱代码结构*/
    AppLocaVideoModel *model = [videoArray objectAtIndex:indexPath.row];/*打乱代码结构*//*打乱代码结构*/
    [cell loadData:model];/*打乱代码结构*//*打乱代码结构*/
    return cell;/*打乱代码结构*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppLocaVideoModel *model = [videoArray objectAtIndex:indexPath.row];/*打乱代码结构*//*打乱代码结构*/
    MoviePlayerViewController *movie = [[MoviePlayerViewController alloc]init];/*打乱代码结构*//*打乱代码结构*/
    movie.videoURL                   = [NSURL fileURLWithPath:model.path isDirectory:YES];/*打乱代码结构*//*打乱代码结构*/
    movie.titleSring = model.title;/*打乱代码结构*/
    movie.isShowCollect = NO;/*打乱代码结构*/
    [self.navigationController pushViewController:movie animated:NO];/*打乱代码结构*//*打乱代码结构*/
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";/*打乱代码结构*/
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;/*打乱代码结构*/
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AppLocaVideoModel *model = [videoArray objectAtIndex:indexPath.row];/*打乱代码结构*//*打乱代码结构*/
    if ([[NSFileManager defaultManager] removeItemAtPath:model.path error:NULL]) {
        NSLog(@"Removed successfully");/*打乱代码结构*/
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];/*打乱代码结构*//*打乱代码结构*/
        [self getVideoArrayToPhone];/*打乱代码结构*//*打乱代码结构*/
    }
    
    
}

@end
