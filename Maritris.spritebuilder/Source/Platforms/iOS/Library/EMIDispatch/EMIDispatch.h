//
//  EMIDispatch.h
//  TableView_task_2
//
//  Created by Marina Butovich on 9/29/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#ifndef TableView_task_2_EMIDispatch_h
#define TableView_task_2_EMIDispatch_h

void EMIDispatchOnMainQueue(void(^block)(void));
void EMIDispatchAsyncOnMainThread(void(^block)(void));
void EMIDispatchAsyncOnBackgroundThread(void(^block)(void));

#endif
