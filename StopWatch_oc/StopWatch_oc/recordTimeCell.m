//
//  recordTimeCell.m
//  StopWatch_oc
//
//  Created by ynfMac on 2020/5/25.
//  Copyright © 2020 ynfMac. All rights reserved.
//

#import "recordTimeCell.h"
#import "StopWatchData.h"

@implementation recordTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.font = [UIFont fontWithName:@"Hiragino Sans W3" size:17.0f];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)recordTimeWithData:(StopWatchData *)data atIndexPath:(NSIndexPath *)indexPath{
    
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = [UIColor whiteColor];

    self.textLabel.text = [NSString stringWithFormat:@"计次 %lu", data.times.count - indexPath.row];

    NSUInteger time = [data.times[indexPath.row] integerValue];

    self.detailTextLabel.text = [self _convertTime:time];
    self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    
    
    
    if (indexPath.row == data.maxTimeIndex) {
        self.textLabel.textColor = [UIColor redColor];
        self.detailTextLabel.textColor = [UIColor redColor];
    }

    if (indexPath.row == data.minTimeIndex) {
        self.textLabel.textColor = [UIColor greenColor];
        self.detailTextLabel.textColor = [UIColor greenColor];
    }
    
}

- (NSString *)_convertTime:(NSUInteger)time{
    return [NSString stringWithFormat:@"%02ld:%02ld.%02ld",time / 100 / 60, time / 100 % 60, time % 100];;
}



@end
