//
//  recordTimeCell.h
//  StopWatch_oc
//
//  Created by ynfMac on 2020/5/25.
//  Copyright © 2020 ynfMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class StopWatchData;

@interface recordTimeCell : UITableViewCell

- (void)recordTimeWithData:(StopWatchData *)data atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
