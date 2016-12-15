//
//  ViewController.m
//  HelloPracticeJSON
//
//  Created by Daniel on 2016/12/13.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ViewController.h"
#import "dataProcess.h"
#import "MyTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property NSMutableArray *objects;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    if(self.objects == nil){
    dataProcess * data=[dataProcess new];
    self.objects = [NSMutableArray arrayWithArray:[data getResults]];
    }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(renewTableView) name:@"start" object:nil];
//    [self loadingJsonData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.objects.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.cellLabel.text = self.objects[indexPath.row][@"Name"];

    return cell;
}
-(void)loadingJsonData{
    NSURL * url =[NSURL URLWithString:@"http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-002136-001"];
    NSURLSessionConfiguration * config =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask * task =[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error) {
            NSLog(@"Download JSON Fail: %@",error);
            return ;
        }
        
        NSDictionary* layer1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSDictionary * layer2 = layer1[@"result"];
        NSArray * layer3 = layer2[@"records"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"start" object:nil];
    }];
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
