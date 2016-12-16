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
{
    dataProcess * data;
    NSMutableDictionary * hostipitalDetail;
    MyTableViewCell *cell ;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
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
        self.objects = [NSMutableArray new];
        hostipitalDetail = [NSMutableDictionary new];
        data=[dataProcess new];
        [self.indicatorView startAnimating];
        [data loadingJsonData];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCellView) name:@"start" object:nil];
    //    [self loadingJsonData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.objects.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    hostipitalDetail =[NSMutableDictionary dictionaryWithDictionary:self.objects[indexPath.row]];
    cell.cellLabel.text = hostipitalDetail[@"Name"];
    return cell;
}

-(void)reloadCellView{
    self.objects = [NSMutableArray arrayWithArray:[data getResults]];
    [self.indicatorView stopAnimating];
    [self.mainTableView reloadData];
}


@end
