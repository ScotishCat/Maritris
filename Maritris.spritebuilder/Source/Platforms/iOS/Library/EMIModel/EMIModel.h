//
//  EMIModel.h
//  TableView_task_2
//
//  Created by Marina Butovich on 10/9/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EMIObservableObject.h"

@class EMIModel;

typedef NS_ENUM(NSUInteger, EMIModelState) {
    EMIModelUnloaded,
    EMIModelDidFaileLoading,
    EMIModelWillLoad,
    EMIModelDidLoad,
    EMIModelDidChange,
    EMIModelStateCount
};

@protocol EMIModelObserver <NSObject>

@optional
- (void)model:(EMIModel *)model didChange:(id)changes;
- (void)modelDidChangeID:(EMIModel *)model;

- (void)modelWillLoad:(EMIModel *)model;
- (void)modelDidLoad:(EMIModel *)model;
- (void)modelDidFailLoading:(EMIModel *)model;
- (void)modelUnloaded:(EMIModel *)model;

@end

@interface EMIModel : EMIObservableObject

- (void)load;
- (void)setupLoading;

// loading state should be set in this method
- (void)performLoading;

@end
