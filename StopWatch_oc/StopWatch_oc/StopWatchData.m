//
//  StopWatchData.m
//  StopWatch_oc
//
//  Created by ynfMac on 2020/5/25.
//  Copyright © 2020 ynfMac. All rights reserved.
//

#import "StopWatchData.h"

@interface StopWatchData()

@property (nonatomic,strong,readwrite) NSArray<NSNumber *> * times;

@end

@implementation StopWatchData
{
    NSMutableArray<NSNumber *> *_times;
}

#pragma mark initial
- (instancetype)init{
    if (self = [super init]) {
        [self reset];
    }
    
    return self;
}

#pragma mark method
- (void)reset{
    _isReset = YES;
    _times = [NSMutableArray array];
}

- (void)beginingNewTimeWithCompletion:( void (^)(void))completion{
    [_times insertObject:@0 atIndex:0];
    _isReset = NO;
    
    if (completion) {
        completion();
    }
}

- (void)timing:(NSTimeInterval)time{
    [_times replaceObjectAtIndex:0 withObject:@(time)];
}


#pragma mark getter
- (NSUInteger)maxTime{
    if (_times.count <= 2) {
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

- (NSUInteger)minTime{
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

- (NSArray<NSNumber *> *)allTimes{
    return _times;
}



@end
