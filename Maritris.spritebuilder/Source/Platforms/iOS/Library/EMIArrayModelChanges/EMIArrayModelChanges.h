//
//  EMIArrayModelChanges.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/27/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EMIArrayModelChangeType) {
    EMIArrayModelChangeAdded,
    EMIArrayModelChangeRemoved,
    EMIArrayModelChangeMoved
};

@interface EMIArrayModelChanges : NSObject
@property (nonatomic, readonly, assign) EMIArrayModelChangeType state;

+ (instancetype)modelWithState:(EMIArrayModelChangeType)state;

@end
