//
//  WSButton.m
//  StopWatch
//
//  Created by ynfMac on 2019/5/6.
//  Copyright © 2019年 ynfMac. All rights reserved.
//

#import "WSButton.h"

@implementation WSButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if ([super pointInside:point withEvent:event]) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        return [path containsPoint:point];
    }
    return NO;
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
