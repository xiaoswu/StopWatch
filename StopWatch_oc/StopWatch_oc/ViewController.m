//
//  ViewController.m
//  StopWatch
//
//  Created by ynfMac on 2019/5/6.
//  Copyright © 2019年 ynfMac. All rights reserved.
//

#import "ViewController.h"
#import "WSButton.h"
#import "UIImage+color.h"
#import "StopWatchData.h"
#import "recordTimeCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property(strong,nonatomic,readonly)recordTimeCell * currentRunTimeCell;

@end

static NSString *const cellId = @"cellId";

@implementation ViewController
{
    NSTimer *_timer;
    NSTimeInterval _totalTime;
    NSTimeInterval _interval;
    StopWatchData *_timeData;
    
    recordTimeCell * _currentRunTimeCell; // 正在计时的cell
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initVariables];
    
    [self _setupNavigation];
    
    [self _setupButtons];
    
}

- (void)_initVariables{
    
    _totalTime = 0;
    _interval = 0;
    
    _timeLabel.text = @"00:00.00";
    
    _timeData = [[StopWatchData alloc] init];
}

- (void)_setupNavigation{
    
    // 修改导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                      }];
    
    // 修改导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)_setupButtons{
    
    // resetButton
    self.resetButton.layer.cornerRadius = self.resetButton.bounds.size.width * 0.5;
    self.resetButton.layer.masksToBounds = YES;
    
    [self.resetButton setTitle:@"计次" forState:UIControlStateDisabled];
    self.resetButton.enabled = NO;
    [self.resetButton setBackgroundImage:[UIImage ws_imageWithColor:[UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1]] forState:UIControlStateDisabled];
    
    [self.resetButton setTitle:@"复位" forState:UIControlStateSelected];
    [self.resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.resetButton setBackgroundImage:[UIImage ws_imageWithColor:[UIColor grayColor]] forState:UIControlStateSelected];
    
    [self.resetButton setTitle:@"计次" forState:UIControlStateNormal];
    [self.resetButton setBackgroundImage:[self.resetButton backgroundImageForState:UIControlStateSelected] forState:UIControlStateNormal];
    
    // startButton
    self.startButton.layer.cornerRadius = self.resetButton.bounds.size.width * 0.5;
    self.startButton.layer.masksToBounds = YES;
    
    [self.startButton setBackgroundImage:[UIImage ws_imageWithColor:[UIColor colorWithRed:20 / 255.0 green:40 / 255.0 blue:24 / 255.0 alpha:1]] forState:UIControlStateNormal];
    [self.startButton setTitle:@"启动" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor colorWithRed:64 / 255.0 green:203 / 255.0 blue:96 / 255.0 alpha:1] forState:UIControlStateNormal];
    
    [self.startButton setBackgroundImage:[UIImage ws_imageWithColor:[UIColor colorWithRed:74 / 255.0 green:16 / 255.0 blue:17 / 255.0 alpha:1]] forState:UIControlStateSelected];
    [self.startButton setTitle:@"停止" forState:UIControlStateSelected];
    [self.startButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

}

- (IBAction)reset:(WSButton *)sender {
    if (sender.selected) { // 复位
        
        //数据全部清零
        [self _initVariables];
        
        // 刷新tableview
        [_tableView reloadData];
        
        // 切换按钮状态
        sender.enabled = NO;
        sender.selected = NO;
        
    } else { // 计次
        
        _interval = 0;
        [_timeData beginingNewTimeWithCompletion:nil];
    }
    
    [_tableView reloadData];
    
}

- (IBAction)start:(WSButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        if (!self.resetButton.enabled){
            self.resetButton.enabled = YES;
        } else {
            self.resetButton.selected = NO;
        }
        
        if (_timeData.isReset) {
            [_timeData beginingNewTimeWithCompletion:^{
                [self->_tableView reloadData];
            }];
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self->_totalTime++;
            self->_interval++;
            self->_timeLabel.text = [self _convertTime:self->_totalTime];
            
            if (self->_currentRunTimeCell != [self _topCell]) {
                self->_currentRunTimeCell = [self _topCell];
            }
            
            self->_currentRunTimeCell.detailTextLabel.text = [self _convertTime:self->_interval];
            [self->_timeData timing:self->_interval];
            
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    } else {
        self.resetButton.selected = YES;
        [_timer invalidate];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    recordTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[recordTimeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    [cell recordTimeWithData:_timeData atIndexPath:indexPath];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _timeData.times.count;
}

- (recordTimeCell *)_topCell{
    return [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (NSString *)_convertTime:(NSUInteger)time{
    return [NSString stringWithFormat:@"%02ld:%02ld.%02ld",time / 100 / 60, time / 100 % 60, time % 100];;
}


@end
