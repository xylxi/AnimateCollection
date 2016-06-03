//
//  ViewController.m
//  TestTest
//
//  Created by WangZHW on 16/6/3.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

#import "ViewController.h"
#import "CView.h"

typedef enum : NSUInteger {
    StatusNormal,
    StatusTop,
} Status;

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic)  NSArray *tableViews;
@property (weak, nonatomic) IBOutlet CView *cView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeigth;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic , assign) Status firstStatus;
@property (nonatomic , assign) Status currentStatus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cView.topView   = self.topView;
    
    CGRect srceenBound  = [UIScreen mainScreen].bounds;
    NSMutableArray *arrs = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * srceenBound.size.width ,  0, srceenBound.size.width , srceenBound.size.height)];
        tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
        tableView.dataSource = self;
        tableView.delegate   = self;
        tableView.tag        = i;
        [arrs addObject:tableView];
        [self.scrollView addSubview:tableView];
    }
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(5 * srceenBound.size.width, 0);
    self.tableViews = arrs;
    
    self.cView.arr = arrs;
    self.cView.scrollView = self.scrollView;
    
    self.firstStatus  = StatusNormal;
    self.currentStatus = StatusTop;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell-->%ld-->%ld",tableView.tag,(long)indexPath.row];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger tag = self.scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width);
    UITableView *tableView = self.tableViews[tag];
    if (scrollView != tableView) {
        return ;
    }
    CGFloat y              = tableView.contentOffset.y;
    // tableView滚动
    CGFloat offset         = tableView.contentInset.top + y;
    // 最大滑动space
    CGFloat space          = 200 - 64;
    space                  = 136;
    CGFloat min            = MIN(offset, space);
    // 改变topView的约束
    self.topSpace.constant = -min;
    if (self.topSpace.constant == -space) {
        self.currentStatus = StatusTop;
    }else {
        self.currentStatus = StatusNormal;
    }
    
    
    for (UITableView *tempView in self.tableViews) {
        if (tempView == tableView) {
            continue;
        }else {
            if (space >= offset) {
                tempView.contentOffset = tableView.contentOffset;
                [tempView setContentOffset:tableView.contentOffset animated:NO];
                NSLog(@"%lu->%@",(unsigned long)[self.tableViews indexOfObject:tempView],NSStringFromCGPoint(tempView.contentOffset));
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger tag = self.scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width);
    UITableView *tableView = self.tableViews[tag];
    if (scrollView != tableView) {
        return ;
    }
    if (self.firstStatus == StatusNormal && self.currentStatus == StatusTop) {
        for (UITableView *tempView in self.tableViews) {
            if (tempView == tableView) {
                continue;
            }else {
                tempView.contentOffset = CGPointMake(0, 136 - tableView.contentInset.top);
            }
        }
    }
    // 记录top的状态
    self.firstStatus       = self.currentStatus;
}

@end
