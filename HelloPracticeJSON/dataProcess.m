//
//  dataProcess.m
//  HelloPracticeJSON
//
//  Created by Daniel on 2016/12/13.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "dataProcess.h"

@implementation dataProcess
{
    NSMutableArray * hostipitalDetail;
    UIActivityIndicatorView * indicatorView;
    NSURLSessionTask * previousTask;
}
-(void)loadingJsonData{
    // Prepare indicatorView
//    [self prepareIndicatorView];
    
    // Cancel previousTask if exist
    if(previousTask){
        [previousTask cancel];
        previousTask = nil;
    }
    
    // Download and Display image.
//    [indicatorView startAnimating];
    hostipitalDetail = [NSMutableArray new];
    NSURL * url =[NSURL URLWithString:@"http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-002136-001"];
    NSURLSessionConfiguration * config =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask * task =[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [indicatorView stopAnimating];
        });
        if(error) {
            NSLog(@"Download JSON Fail: %@",error);
            previousTask = nil;
            return ;
        }
        
        NSDictionary* layer1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSDictionary * layer2 = layer1[@"result"];
//        NSArray * layer3 = layer2[@"records"];
//        for (int i = 0 ; i<layer3.count;i++){
//            hostipitalDetail[i][0] = layer3[i][@"Name"];
//            hostipitalDetail[i][1] = layer3[i][@"District"];
//            hostipitalDetail[i][2] = layer3[i][@"Address"];
//            hostipitalDetail[i][3] = layer3[i][@"Tel"];
//            hostipitalDetail[i][4] = layer3[i][@"wgs84aX"];
//            hostipitalDetail[i][5] = layer3[i][@"wgs84aY"];
//        }
        hostipitalDetail =[NSMutableArray arrayWithArray:layer2[@"records"]];
        previousTask = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"start" object:nil];
    }];
    [task resume];
    // Keep previousTask
    previousTask = task;
}

-(NSMutableArray *)getResults{
//    [self loadingJsonData];
    return  hostipitalDetail;
}

-(void) prepareIndicatorView{
    
    // Check if there is any exist one.
    if(indicatorView != nil){
        [indicatorView removeFromSuperview];
        indicatorView = nil; //It is not necessary
        //由於indicatorView被移除導致若有使用此變數時會crash所以定義此變數為nil
        //此行可不加的原因是下面立即把indicatorView給予新的記憶體位置所以不會crash
    }
    
    // Create indicatorView
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //(x,y,寬,高)利用indicatorView的特性（無法更改旋轉圖示的大小)，所以將邊框大小變成和所需要顯示的地方一樣大，就會讓旋轉圖示保持置中
    indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.color = [UIColor blueColor];
    indicatorView.hidesWhenStopped = true;
    //若還是旋轉則顯示圖示，若停止則不顯示
    indicatorView.frame = frame;
    [self addSubview:indicatorView];
    // 因為此行程式碼關係導致 indicatorView 沒有被使用時不會被ARC移除
    // 所以在Check if there is any exist one.那邊加上 remove指令
}
@end
