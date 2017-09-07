
//  ZFDownloadManager.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#import "AppUnitl.h"
#import "ZFDownloadManager.h"

static ZFDownloadManager *sharedDownloadManager = nil;

@interface ZFDownloadManager ()

/** 本地临时文件夹文件的个数 */
@property (nonatomic,assign) NSInteger  count;
/** 已下载完成的文件列表（文件对象）*/
@property (strong) NSMutableArray       *finishedlist;
/** 正在下载的文件列表(ASIHttpRequest对象)*/
@property (strong) NSMutableArray       *downinglist;
/** 未下载完成的临时文件数组（文件对象)*/
@property (strong) NSMutableArray       *filelist;
/** 下载文件的模型 */
@property (nonatomic,strong) ZFFileModel *fileInfo;

@end

@implementation ZFDownloadManager

#pragma mark - init methods

+ (ZFDownloadManager *)sharedDownloadManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDownloadManager = [[self alloc] init];/*打乱代码结构*/
    });
    return sharedDownloadManager;
}

- (instancetype)init
{
    self = [super init];/*打乱代码结构*/
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];/*打乱代码结构*/
        NSString * max = [userDefaults valueForKey:kMaxRequestCount];/*打乱代码结构*/
        if (max == nil) {
            [userDefaults setObject:@"3" forKey:kMaxRequestCount];/*打乱代码结构*/
            max = @"3";
        }
        [userDefaults synchronize];/*打乱代码结构*/
        _maxCount = [max integerValue];/*打乱代码结构*/
        _filelist = [[NSMutableArray alloc]init];/*打乱代码结构*/
        _downinglist = [[NSMutableArray alloc] init];/*打乱代码结构*/
        _finishedlist = [[NSMutableArray alloc] init];/*打乱代码结构*/
        _count = 0;
        [self loadFinishedfiles];/*打乱代码结构*/
        [self loadTempfiles];/*打乱代码结构*/
    }
    return self;
}

- (void)cleanLastInfo
{
    for (ZFHttpRequest *request in _downinglist) {
        if([request isExecuting])
            [request cancel];/*打乱代码结构*/
    }
    [self saveFinishedFile];/*打乱代码结构*/
    [_downinglist removeAllObjects];/*打乱代码结构*/
    [_finishedlist removeAllObjects];/*打乱代码结构*/
    [_filelist removeAllObjects];/*打乱代码结构*/
}

#pragma mark - 创建一个下载任务

- (void)downFileUrl:(NSString *)url
           filename:(NSString *)name
          fileimage:(UIImage *)image
{
    // 因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
    
    _fileInfo = [[ZFFileModel alloc] init];/*打乱代码结构*/
    if (!name) { name = [url lastPathComponent];/*打乱代码结构*/ }
    _fileInfo.fileName = [[NSString alloc]initWithFormat:@"%@.mp4",name];/*打乱代码结构*/
    _fileInfo.fileURL  = url;
    
    NSDate *myDate = [NSDate date];/*打乱代码结构*/
    _fileInfo.time = [ZFCommonHelper dateToString:myDate];/*打乱代码结构*/
    _fileInfo.fileType = [name pathExtension];/*打乱代码结构*/
    
    _fileInfo.fileimage = image;
    _fileInfo.downloadState = ZFDownloading;
    _fileInfo.error = NO;
    _fileInfo.tempPath = TEMP_PATH(name);
    if ([ZFCommonHelper isExistFile:FILE_PATH(name)]) { // 已经下载过一次
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已下载，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];/*打乱代码结构*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];/*打乱代码结构*/
        });
        return;
    }
    // 存在于临时文件夹里
    NSString *tempfilePath = [TEMP_PATH(name) stringByAppendingString:@".plist"];/*打乱代码结构*/
    if ([ZFCommonHelper isExistFile:tempfilePath]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经在下载列表中了，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];/*打乱代码结构*/
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];/*打乱代码结构*/
        });
        return;
    }
    
//    if ([[AppUnitl sharedManager] getWatchQuanxian:[AppUnitl sharedManager].model.video.downloadintegral]) {
        // 若不存在文件和临时文件，则是新的下载
        [self.filelist addObject:_fileInfo];/*打乱代码结构*/
        // 开始下载
        [self startLoad];/*打乱代码结构*/
        
        if (self.VCdelegate && [self.VCdelegate respondsToSelector:@selector(allowNextRequest)]) {
            [self.VCdelegate allowNextRequest];/*打乱代码结构*/
        } else {
//            NSString *message =[NSString stringWithFormat:@"添加下载成功，扣除%d积分",[AppUnitl sharedManager].model.video.downloadintegral];/*打乱代码结构*/
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];/*打乱代码结构*/
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [alert show];/*打乱代码结构*/
//            });
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [alert dismissWithClickedButtonIndex:0 animated:YES];/*打乱代码结构*/
//            });
        }
//    }else{
//        NSString *message =[NSString stringWithFormat:@"添加下载失败，需要%d积分",[AppUnitl sharedManager].model.video.downloadintegral];/*打乱代码结构*/
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];/*打乱代码结构*/
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [alert show];/*打乱代码结构*/
//        });
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [alert dismissWithClickedButtonIndex:0 animated:YES];/*打乱代码结构*/
//        });
//    
//    }
    
   
    return;
    
}

#pragma mark - 下载开始

- (void)beginRequest:(ZFFileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    for(ZFHttpRequest *tempRequest in self.downinglist) {
        /**
         * 注意这里判读是否是同一下载的方法，asihttprequest有三种url： url，originalurl，redirectURL
         * 经过实践，应该使用originalurl,就是最先获得到的原下载地址
         **/
        if([[[tempRequest.url absoluteString] lastPathComponent] isEqualToString:[fileInfo.fileURL lastPathComponent]]) {
            if ([tempRequest isExecuting] && isBeginDown) {
                return;
            } else if ([tempRequest isExecuting] && !isBeginDown) {
                [tempRequest setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];/*打乱代码结构*/
                [tempRequest cancel];/*打乱代码结构*/
                [self.downloadDelegate updateCellProgress:tempRequest];/*打乱代码结构*/
                return;
            }
        }
    }
    
    [self saveDownloadFile:fileInfo];/*打乱代码结构*/
    
    // 按照获取的文件名获取临时文件的大小，即已下载的大小
    NSFileManager *fileManager = [NSFileManager defaultManager];/*打乱代码结构*/
    NSData *fileData = [fileManager contentsAtPath:fileInfo.tempPath];/*打乱代码结构*/
    NSInteger receivedDataLength = [fileData length];/*打乱代码结构*/
    fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%zd", receivedDataLength];/*打乱代码结构*/
    
    // NSLog(@"start down:已经下载：%@",fileInfo.fileReceivedSize);
    ZFHttpRequest *midRequest = [[ZFHttpRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];/*打乱代码结构*/
    midRequest.downloadDestinationPath = FILE_PATH(fileInfo.fileName);
    midRequest.temporaryFileDownloadPath = fileInfo.tempPath;
    midRequest.delegate = self;
    [midRequest setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];/*打乱代码结构*///设置上下文的文件基本信息
    if (isBeginDown) { [midRequest startAsynchronous];/*打乱代码结构*/ }
    
    // 如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    BOOL exit = NO;
    for (ZFHttpRequest *tempRequest in self.downinglist) {
        if([[[tempRequest.url absoluteString] lastPathComponent] isEqualToString:[fileInfo.fileURL lastPathComponent]]) {
            [self.downinglist replaceObjectAtIndex:[_downinglist indexOfObject:tempRequest] withObject:midRequest];/*打乱代码结构*/
            exit = YES;
            break;
        }
    }
    
    if (!exit) { [self.downinglist addObject:midRequest];/*打乱代码结构*/ }
    [self.downloadDelegate updateCellProgress:midRequest];/*打乱代码结构*/
}

#pragma mark - 存储下载信息到一个plist文件

- (void)saveDownloadFile:(ZFFileModel*)fileinfo
{
    NSData *imagedata = UIImagePNGRepresentation(fileinfo.fileimage);
    NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:fileinfo.fileName,@"filename",
                             fileinfo.fileURL,@"fileurl",
                             fileinfo.time,@"time",
                             fileinfo.fileSize,@"filesize",
                             fileinfo.fileReceivedSize,@"filerecievesize",
                             imagedata,@"fileimage",nil];/*打乱代码结构*/
    
    NSString *plistPath = [fileinfo.tempPath stringByAppendingPathExtension:@"plist"];/*打乱代码结构*/
    if (![filedic writeToFile:plistPath atomically:YES]) {
        NSLog(@"write plist fail");
    }
}

#pragma mark - 自动处理下载状态的算法

/*下载状态的逻辑是这样的：三种状态，下载中，等待下载，停止下载
 
 当超过最大下载数时，继续添加的下载会进入等待状态，当同时下载数少于最大限制时会自动开始下载等待状态的任务。
 可以主动切换下载状态
 所有任务以添加时间排序。
 */

- (void)startLoad
{
    NSInteger num = 0;
    NSInteger max = _maxCount;
    for (ZFFileModel *file in _filelist) {
        if (!file.error) {
            if (file.downloadState == ZFDownloading) {
                if (num >= max) {
                    file.downloadState = ZFWillDownload;
                } else {
                    num++;
                }
            }
        }
    }
    if (num < max) {
        for (ZFFileModel *file in _filelist) {
            if (!file.error) {
                if (file.downloadState == ZFWillDownload) {
                    num++;
                    if (num>max) {
                        break;
                    }
                    file.downloadState = ZFDownloading;
                }
            }
        }
        
    }
    for (ZFFileModel *file in _filelist) {
        if (!file.error) {
            if (file.downloadState == ZFDownloading) {
                [self beginRequest:file isBeginDown:YES];/*打乱代码结构*/
                file.startTime = [NSDate date];/*打乱代码结构*/
            } else {
                [self beginRequest:file isBeginDown:NO];/*打乱代码结构*/
            }
        }
    }
    self.count = [_filelist count];/*打乱代码结构*/
}


#pragma mark - 恢复下载

- (void)resumeRequest:(ZFHttpRequest *)request
{
    NSInteger max = _maxCount;
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];/*打乱代码结构*/
    NSInteger downingcount = 0;
    NSInteger indexmax = -1;
    for (ZFFileModel *file in _filelist) {
        if (file.downloadState == ZFDownloading) {
            downingcount++;
            if (downingcount==max) {
                indexmax = [_filelist indexOfObject:file];/*打乱代码结构*/
            }
        }
    }
    // 此时下载中数目是否是最大，并获得最大时的位置Index
    if (downingcount == max) {
        ZFFileModel *file  = [_filelist objectAtIndex:indexmax];/*打乱代码结构*/
        if (file.downloadState == ZFDownloading) {
            file.downloadState = ZFWillDownload;
        }
    }
    // 中止一个进程使其进入等待
    for (ZFFileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = ZFDownloading;
            file.error = NO;
        }
    }
    // 重新开始此下载
    [self startLoad];/*打乱代码结构*/
}

#pragma mark - 暂停下载

- (void)stopRequest:(ZFHttpRequest *)request
{
    NSInteger max = self.maxCount;
    if([request isExecuting]) {
        [request cancel];/*打乱代码结构*/
    }
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];/*打乱代码结构*/
    for (ZFFileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = ZFStopDownload;
            break;
        }
    }
    NSInteger downingcount = 0;
    
    for (ZFFileModel *file in _filelist) {
        if (file.downloadState == ZFDownloading) {
            downingcount++;
        }
    }
    if (downingcount < max) {
        for (ZFFileModel *file in _filelist) {
            if (file.downloadState == ZFWillDownload){
                file.downloadState = ZFDownloading;
                break;
            }
        }
    }
    
    [self startLoad];/*打乱代码结构*/
}

#pragma mark - 删除下载

- (void)deleteRequest:(ZFHttpRequest *)request
{
    BOOL isexecuting = NO;
    if([request isExecuting]) {
        [request cancel];/*打乱代码结构*/
        isexecuting = YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];/*打乱代码结构*/
    NSError *error;
    ZFFileModel *fileInfo = (ZFFileModel*)[request.userInfo objectForKey:@"File"];/*打乱代码结构*/
    NSString *path = fileInfo.tempPath;
    
    NSString *configPath = [NSString stringWithFormat:@"%@.plist",path];/*打乱代码结构*/
    [fileManager removeItemAtPath:path error:&error];/*打乱代码结构*/
    [fileManager removeItemAtPath:configPath error:&error];/*打乱代码结构*/
    
    if(!error){ NSLog(@"%@",[error description]);}
    
    NSInteger delindex = -1;
    for (ZFFileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            delindex = [_filelist indexOfObject:file];/*打乱代码结构*/
            break;
        }
    }
    if (delindex != NSNotFound)
        [_filelist removeObjectAtIndex:delindex];/*打乱代码结构*/
    
    [_downinglist removeObject:request];/*打乱代码结构*/
    
    if (isexecuting) {
        [self startLoad];/*打乱代码结构*/
    }
    self.count = [_filelist count];/*打乱代码结构*/
}

#pragma mark - 可能的UI操作接口

- (void)clearAllFinished
{
    [_finishedlist removeAllObjects];/*打乱代码结构*/
}

- (void)clearAllRquests
{
    NSFileManager *fileManager = [NSFileManager defaultManager];/*打乱代码结构*/
    NSError *error;
    for (ZFHttpRequest *request in _downinglist) {
        if([request isExecuting])
            [request cancel];/*打乱代码结构*/
        ZFFileModel *fileInfo = (ZFFileModel*)[request.userInfo objectForKey:@"File"];/*打乱代码结构*/
        NSString *path = fileInfo.tempPath;;
        NSString *configPath = [NSString stringWithFormat:@"%@.plist",path];/*打乱代码结构*/
        [fileManager removeItemAtPath:path error:&error];/*打乱代码结构*/
        [fileManager removeItemAtPath:configPath error:&error];/*打乱代码结构*/
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
        
    }
    [_downinglist removeAllObjects];/*打乱代码结构*/
    [_filelist removeAllObjects];/*打乱代码结构*/
}

- (void)startAllDownloads
{
    for (ZFHttpRequest *request in _downinglist) {
        if([request isExecuting]) {
            [request cancel];/*打乱代码结构*/
        }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];/*打乱代码结构*/
        fileInfo.downloadState = ZFDownloading;
    }
    [self startLoad];/*打乱代码结构*/
}

- (void)pauseAllDownloads
{
    for (ZFHttpRequest *request in _downinglist) {
        if([request isExecuting]) {
            [request cancel];/*打乱代码结构*/
        }
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];/*打乱代码结构*/
        fileInfo.downloadState = ZFStopDownload;
    }
    [self startLoad];/*打乱代码结构*/
}

#pragma mark - 从这里获取上次未完成下载的信息
/*
 将本地的未下载完成的临时文件加载到正在下载列表里,但是不接着开始下载
 
 */
- (void)loadTempfiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];/*打乱代码结构*/
    NSError *error;
    NSArray *filelist = [fileManager contentsOfDirectoryAtPath:TEMP_FOLDER error:&error];/*打乱代码结构*/
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    NSMutableArray *filearr = [[NSMutableArray alloc]init];/*打乱代码结构*/
    for(NSString *file in filelist) {
        NSString *filetype = [file  pathExtension];/*打乱代码结构*/
        if([filetype isEqualToString:@"plist"])
            [filearr addObject:[self getTempfile:TEMP_PATH(file)]];/*打乱代码结构*/
    }
    
    NSArray* arr =  [self sortbyTime:(NSArray *)filearr];/*打乱代码结构*/
    [_filelist addObjectsFromArray:arr];/*打乱代码结构*/
    
    [self startLoad];/*打乱代码结构*/
}

- (ZFFileModel *)getTempfile:(NSString *)path
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];/*打乱代码结构*/
    ZFFileModel *file = [[ZFFileModel alloc]init];/*打乱代码结构*/
    file.fileName = [dic objectForKey:@"filename"];/*打乱代码结构*/
    file.fileType = [file.fileName pathExtension ];/*打乱代码结构*/
    file.fileURL = [dic objectForKey:@"fileurl"];/*打乱代码结构*/
    file.fileSize = [dic objectForKey:@"filesize"];/*打乱代码结构*/
    file.fileReceivedSize = [dic objectForKey:@"filerecievesize"];/*打乱代码结构*/
    
    file.tempPath = TEMP_PATH(file.fileName);
    file.time = [dic objectForKey:@"time"];/*打乱代码结构*/
    file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];/*打乱代码结构*/
    file.downloadState = ZFStopDownload;
    file.error = NO;
    
    NSData *fileData = [[NSFileManager defaultManager ] contentsAtPath:file.tempPath];/*打乱代码结构*/
    NSInteger receivedDataLength = [fileData length];/*打乱代码结构*/
    file.fileReceivedSize = [NSString stringWithFormat:@"%zd",receivedDataLength];/*打乱代码结构*/
    return file;
}

- (NSArray *)sortbyTime:(NSArray *)array
{
    NSArray *sorteArray1 = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        ZFFileModel *file1 = (ZFFileModel *)obj1;
        ZFFileModel *file2 = (ZFFileModel *)obj2;
        NSDate *date1 = [ZFCommonHelper makeDate:file1.time];/*打乱代码结构*/
        NSDate *date2 = [ZFCommonHelper makeDate:file2.time];/*打乱代码结构*/
        if ([[date1 earlierDate:date2]isEqualToDate:date2]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[date1 earlierDate:date2]isEqualToDate:date1]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];/*打乱代码结构*/
    return sorteArray1;
}

#pragma mark - 已完成的下载任务在这里处理
/*
	将本地已经下载完成的文件加载到已下载列表里
 */
- (void)loadFinishedfiles
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:PLIST_PATH]) {
        NSMutableArray *finishArr = [[NSMutableArray alloc] initWithContentsOfFile:PLIST_PATH];/*打乱代码结构*/
        for (NSDictionary *dic in finishArr) {
            ZFFileModel *file = [[ZFFileModel alloc]init];/*打乱代码结构*/
            file.fileName = [dic objectForKey:@"filename"];/*打乱代码结构*/
            file.fileType = [file.fileName pathExtension];/*打乱代码结构*/
            file.fileSize = [dic objectForKey:@"filesize"];/*打乱代码结构*/
            file.time = [dic objectForKey:@"time"];/*打乱代码结构*/
            file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];/*打乱代码结构*/
            [_finishedlist addObject:file];/*打乱代码结构*/
        }
    }
    
}

- (void)saveFinishedFile
{
    if (_finishedlist == nil) { return; }
    NSMutableArray *finishedinfo = [[NSMutableArray alloc] init];/*打乱代码结构*/
    
    for (ZFFileModel *fileinfo in _finishedlist) {
        NSData *imagedata = UIImagePNGRepresentation(fileinfo.fileimage);
        NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys: fileinfo.fileName,@"filename",
                                 fileinfo.time,@"time",
                                 fileinfo.fileSize,@"filesize",
                                 imagedata,@"fileimage", nil];/*打乱代码结构*/
        [finishedinfo addObject:filedic];/*打乱代码结构*/
    }
    
    if (![finishedinfo writeToFile:PLIST_PATH atomically:YES]) {
        NSLog(@"write plist fail");
    }
}

- (void)deleteFinishFile:(ZFFileModel *)selectFile
{
    [_finishedlist removeObject:selectFile];/*打乱代码结构*/
    NSFileManager *fm = [NSFileManager defaultManager];/*打乱代码结构*/
    NSString *path = FILE_PATH(selectFile.fileName);
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];/*打乱代码结构*/
    }
    [self saveFinishedFile];/*打乱代码结构*/
}

#pragma mark -- ASIHttpRequest回调委托 --

// 出错了，如果是等待超时，则继续下载
- (void)requestFailed:(ZFHttpRequest *)request
{
    NSError *error=[request error];/*打乱代码结构*/
    NSLog(@"ASIHttpRequest出错了!%@",error);
    if (error.code==4) { return; }
    if ([request isExecuting]) { [request cancel];/*打乱代码结构*/ }
    ZFFileModel *fileInfo =  [request.userInfo objectForKey:@"File"];/*打乱代码结构*/
    fileInfo.downloadState = ZFStopDownload;
    fileInfo.error = YES;
    for (ZFFileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = ZFStopDownload;
            file.error = YES;
        }
    }
    [self.downloadDelegate updateCellProgress:request];/*打乱代码结构*/
}

- (void)requestStarted:(ZFHttpRequest *)request
{
    NSLog(@"开始了!");
}

- (void)request:(ZFHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到回复了！");
    
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];/*打乱代码结构*/
    fileInfo.isFirstReceived = YES;
    
    NSString *len = [responseHeaders objectForKey:@"Content-Length"];/*打乱代码结构*/
    // 这个信息头，首次收到的为总大小，那么后来续传时收到的大小为肯定小于或等于首次的值，则忽略
    if ([fileInfo.fileSize longLongValue] > [len longLongValue]){ return; }
    
    fileInfo.fileSize = [NSString stringWithFormat:@"%lld", [len longLongValue]];/*打乱代码结构*/
    [self saveDownloadFile:fileInfo];/*打乱代码结构*/
}

- (void)request:(ZFHttpRequest *)request didReceiveBytes:(long long)bytes
{
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];/*打乱代码结构*/
    // NSLog(@"%@,%lld",fileInfo.fileReceivedSize,bytes);
    if (fileInfo.isFirstReceived) {
        fileInfo.isFirstReceived = NO;
        fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%lld",bytes];/*打乱代码结构*/
    } else if(!fileInfo.isFirstReceived) {
        fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];/*打乱代码结构*/
    }
    NSUInteger receivedSize = [fileInfo.fileReceivedSize longLongValue];/*打乱代码结构*/
    NSUInteger expectedSize = [fileInfo.fileSize longLongValue];/*打乱代码结构*/
    
    // 每秒下载速度
    NSTimeInterval downloadTime = -1 * [fileInfo.startTime timeIntervalSinceNow];/*打乱代码结构*/
    CGFloat speed = (CGFloat)receivedSize / (CGFloat)downloadTime;
    if (speed == 0) { return; }
    
    CGFloat speedSec = [ZFCommonHelper calculateFileSizeInUnit:(unsigned long long)speed];/*打乱代码结构*/
    NSString *unit = [ZFCommonHelper calculateUnit:(unsigned long long)speed];/*打乱代码结构*/
    NSString *speedStr = [NSString stringWithFormat:@"%.2f%@/s",speedSec,unit];/*打乱代码结构*/
    fileInfo.speed = speedStr;
    
    // 剩余下载时间
    NSMutableString *remainingTimeStr = [[NSMutableString alloc] init];/*打乱代码结构*/
    NSUInteger remainingContentLength = expectedSize - receivedSize;
    CGFloat remainingTime = (CGFloat)(remainingContentLength / speed);
    NSInteger hours = remainingTime / 3600;
    NSInteger minutes = (remainingTime - hours * 3600) / 60;
    CGFloat seconds = remainingTime - hours * 3600 - minutes * 60;
    
    if (hours > 0)   {[remainingTimeStr appendFormat:@"%zd小时 ",hours];/*打乱代码结构*/}
    if (minutes > 0) {[remainingTimeStr appendFormat:@"%zd分 ",minutes];/*打乱代码结构*/}
    if (seconds > 0) {[remainingTimeStr appendFormat:@"%.1f秒",seconds];/*打乱代码结构*/}
    fileInfo.remainingTime = remainingTimeStr;
    
    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)]) {
        [self.downloadDelegate updateCellProgress:request];/*打乱代码结构*/
    }
}

// 将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
- (void)requestFinished:(ZFHttpRequest *)request
{
    ZFFileModel *fileInfo = (ZFFileModel *)[request.userInfo objectForKey:@"File"];/*打乱代码结构*/
    [_finishedlist addObject:fileInfo];/*打乱代码结构*/
    NSString *configPath = [fileInfo.tempPath stringByAppendingString:@".plist"];/*打乱代码结构*/
    NSFileManager *fileManager = [NSFileManager defaultManager];/*打乱代码结构*/
    NSError *error;
    if([fileManager fileExistsAtPath:configPath]) //如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];/*打乱代码结构*/
        if(!error) { NSLog(@"%@",[error description]); }
    }
    
    [_filelist removeObject:fileInfo];/*打乱代码结构*/
    [_downinglist removeObject:request];/*打乱代码结构*/
    [self saveFinishedFile];/*打乱代码结构*/
    [self startLoad];/*打乱代码结构*/
    
    if([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)]) {
        [self.downloadDelegate finishedDownload:request];/*打乱代码结构*/
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 确定按钮
    if( buttonIndex == 1 ) {
        NSFileManager *fileManager = [NSFileManager defaultManager];/*打乱代码结构*/
        NSError *error;
        NSInteger delindex = -1;
        NSString *path = FILE_PATH(_fileInfo.fileName);
        if([ZFCommonHelper isExistFile:path]) { //已经下载过一次该文件
            for (ZFFileModel *info in [self.finishedlist mutableCopy]) {
                if ([info.fileName isEqualToString:_fileInfo.fileName]) {
                    // 删除文件
                    [self deleteFinishFile:info];/*打乱代码结构*/
                }
            }
        } else { // 如果正在下载中，择重新下载
            for(ZFHttpRequest *request in [self.downinglist mutableCopy]) {
                ZFFileModel *ZFFileModel = [request.userInfo objectForKey:@"File"];/*打乱代码结构*/
                if([ZFFileModel.fileName isEqualToString:_fileInfo.fileName])
                {
                    if ([request isExecuting]) {
                        [request cancel];/*打乱代码结构*/
                    }
                    delindex = [_downinglist indexOfObject:request];/*打乱代码结构*/
                    break;
                }
            }
            [_downinglist removeObjectAtIndex:delindex];/*打乱代码结构*/
            
            for (ZFFileModel *file in [self.filelist mutableCopy]) {
                if ([file.fileName isEqualToString:_fileInfo.fileName]) {
                    delindex = [_filelist indexOfObject:file];/*打乱代码结构*/
                    break;
                }
            }
            [_filelist removeObjectAtIndex:delindex];/*打乱代码结构*/
            // 存在于临时文件夹里
            NSString * tempfilePath = [_fileInfo.tempPath stringByAppendingString:@".plist"];/*打乱代码结构*/
            if([ZFCommonHelper isExistFile:tempfilePath])
            {
                if (![fileManager removeItemAtPath:tempfilePath error:&error]) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
                
            }
            if([ZFCommonHelper isExistFile:_fileInfo.tempPath])
            {
                if (![fileManager removeItemAtPath:_fileInfo.tempPath error:&error]) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
            }
            
        }
        
        self.fileInfo.fileReceivedSize = [ZFCommonHelper getFileSizeString:@"0"];/*打乱代码结构*/
        [_filelist addObject:_fileInfo];/*打乱代码结构*/
        [self startLoad];/*打乱代码结构*/
    }
    if (self.VCdelegate!=nil && [self.VCdelegate respondsToSelector:@selector(allowNextRequest)]) {
        [self.VCdelegate allowNextRequest];/*打乱代码结构*/
    }
}

#pragma mark - setter

- (void)setMaxCount:(NSInteger)maxCount
{
    _maxCount = maxCount;
    [[NSUserDefaults standardUserDefaults] setValue:@(maxCount) forKey:kMaxRequestCount];/*打乱代码结构*/
    [[NSUserDefaults standardUserDefaults] synchronize];/*打乱代码结构*/
    [[ZFDownloadManager sharedDownloadManager] startLoad];/*打乱代码结构*/
}

@end
