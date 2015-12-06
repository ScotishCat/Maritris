//
//  EMIDispatch.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/29/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMIDispatch.h"

void EMIDispatchOnMainQueue(void(^block)(void)) {
    if (block) {
        if ([NSThread isMainThread]) {
            block();
        } else {
            dispatch_sync(dispatch_get_main_queue(), block);
        }
    }
}

void EMIDispatchAsyncOnMainThread(void(^block)(void)) {
    if (block) {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void EMIDispatchAsyncOnBackgroundThread(void(^block)(void)) {
    if (block) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), block);
    }
}