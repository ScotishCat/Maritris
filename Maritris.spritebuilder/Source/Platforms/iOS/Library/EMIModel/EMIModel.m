//
//  EMIModel.m
//  TableView_task_2
//
//  Created by Marina Butovich on 10/9/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "EMIModel.h"

#import "EMIDispatch.h"

#import "EMIMacros.h"

@implementation EMIModel

#pragma mark -
#pragma mark Public

- (void)load {
    @synchronized(self) {
        NSUInteger state = self.state;
        if (EMIModelDidLoad == state || EMIModelWillLoad == state) {
            [self notifyObserversOfStateChanged];
            
            return;
        }
        
        self.state = EMIModelWillLoad;
    }
    
    [self setupLoading];
    
    EMIWeakify(self);
    EMIDispatchAsyncOnBackgroundThread(^{
        EMIStrongifyAndReturnIfNil(self);
        [self performLoading];
    });
}

- (void)setupLoading {
    
}

- (void)performLoading {
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark -
#pragma mark EMIObservableObject

- (SEL)selectorForState:(NSUInteger)state {
    SEL selector = NULL;
    
    switch (state) {
        case EMIModelUnloaded:
            selector = @selector(modelUnloaded:);
            break;
            
        case EMIModelDidFaileLoading:
            selector = @selector(modelDidFailLoading:);
            break;
            
        case EMIModelWillLoad:
            selector = @selector(modelWillLoad:);
            break;
            
        case EMIModelDidLoad:
            selector = @selector(modelDidLoad:);
            break;
            
        case EMIModelDidChange:
            selector = @selector(model:didChange:);
            break;
            
        default:
            break;
    }
    
    return selector;
}

@end
