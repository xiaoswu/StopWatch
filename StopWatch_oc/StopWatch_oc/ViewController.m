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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController
{
    NSMutableArray<NSNumber *> *_times;
    NSTimer *_timer;
    NSUInteger _totalTime;
    NSUInteger _intervals;
    
    UITableViewCell * _currentRunTimeCell; // 正在计时的cell
    
    BOOL _isReset; // 是否是复位状态
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initVariables];
    
    [self _setupNavigation];
    
    [self _setupUI];
    
}

- (void)_initVariables{
    _isReset = YES;
    
    _totalTime = 0;
    _intervals = 0;
    
    _timeLabel.text = @"00:00.00";
    
    if (_times.count) {
        [_times removeAllObjects];
    } else {
        _times = [NSMutableArray array];
    }
}

- (void)_setupNavigation{
    
    // 修改导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                                      }];
    
    // 修改导航栏的背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

- (void)_setupUI{
    
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
        
        _intervals = 0;
        
        [self _addNewTime];
        
    }
}

- (void)_addNewTime{
    [_times insertObject:@0 atIndex:0];
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
        
        if (_isReset) {
            [self _addNewTime];
            _isReset = NO;
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self->_totalTime++;
            self->_intervals++;
            self->_timeLabel.text = [self _getTime:self->_totalTime];
            
            if (self->_currentRunTimeCell != [self _topCell]) {
                self->_currentRunTimeCell = [self _topCell];
            }
            
            self->_currentRunTimeCell.detailTextLabel.text = [self _getTime:self->_intervals];
            [self->_times replaceObjectAtIndex:0 withObject:@(self->_intervals)];
            
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    } else {
        self.resetButton.selected = YES;
        [_timer invalidate];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor blackColor];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        

        
        cell.textLabel.text = [NSString stringWithFormat:@"计次 %lu",_times.count - indexPath.row];
        
        NSUInteger time = [_times[indexPath.row] integerValue];
        cell.detailTextLabel.text = [self _getTime:time];
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        // 调整颜色
        if (indexPath.row == [self _maxTimeIndex] && indexPath.row != 0) {
            cell.textLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        
        if (indexPath.row == [self _minTimeIndex] && indexPath.row != 0) {
            cell.textLabel.textColor = [UIColor greenColor];
            cell.detailTextLabel.textColor = [UIColor greenColor];
        }
    
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _times.count;
}

- (UITableViewCell *)_topCell{
    return [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (NSString *)_getTime:(NSUInteger)time{
    return [NSString stringWithFormat:@"%02ld:%02ld.%02ld",time / 100 / 60, time / 100 % 60, time % 100];;
}

- (NSUInteger)_maxTimeIndex{
    if (_times.count<= 2) {
        return 0;
    }
    
    int maxIndex = 1;
    for (int i = 2; i < _times.count; i++) {
        if ([_times[i] intValue] > [_times[maxIndex] intValue]) {
            maxIndex = i;
        }
    }
    return maxIndex;
}

- (NSUInteger)_minTimeIndex{
    if (_times.count<= 2) {
        return 0;
    }
    
    int minIndex = 1;
    for (int i = 2; i < _times.count; i++) {
        if ([_times[i] intValue] < [_times[minIndex] intValue]) {
            minIndex = i;
        }
    }
    return minIndex;
}

@end
