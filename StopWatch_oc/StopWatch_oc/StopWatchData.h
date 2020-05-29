//
//  StopWatchData.h
//  StopWatch_oc
//
//  Created by ynfMac on 2020/5/25.
//  Copyright © 2020 ynfMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StopWatchData : NSObject

// 是否处于复位状态
@property (nonatomic,assign,readonly) BOOL isReset;

@property (nonatomic,strong,readonly) NSArray<NSNumber *> * times;

@property (nonatomic,assign,readonly)NSUInteger maxTimeIndex;

@property (nonatomic,assign,readonly)NSUInteger minTimeIndex;

- (void)beginingNewTimeWithCompletion:(nullable void(^)(void))completion;

- (void)timing:(NSTimeInterval)time;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
