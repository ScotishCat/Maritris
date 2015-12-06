//
//  EMIObservableObject.m
//  Homework
//
//  Created by Marina Butovich on 8/9/15.
//
//

#import "EMIObservableObject.h"

#import "EMIDispatch.h"

@interface EMIObservableObject ()
@property (nonatomic, retain)   NSHashTable *observers;
@property (nonatomic, assign)   BOOL        shouldNotify;

@end

@implementation EMIObservableObject

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)init {
    self = [super init];
    if (self) {
        self.observers = [NSHashTable weakObjectsHashTable];
        self.shouldNotify = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSSet *)observerSet {
    @synchronized(self.observers) {
        return [self.observers copy];
    }
}

- (void)setState:(NSUInteger)state {
    [self setState:state withObject:nil];
}

#pragma mark -
#pragma mark Public

- (void)setState:(NSUInteger)state withObject:(id)object {
    if (_state != state) {
        _state = state;
    }
    
    if (self.shouldNotify) {
        [self notifyObserversOfStateChangedWithObject:object];
    }
}

- (void)addObserver:(id)observer {
    @synchronized(self.observers) {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(id)observer {
    @synchronized(self.observers) {
        [self.observers removeObject:observer];
    }
}

- (BOOL)isObservedByObject:(id)observer {
    @synchronized(self.observers) {
        return [self.observers containsObject:observer];
    }
}

#pragma clang dagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)notifyOfStateChangedWithSelector:(SEL)selector withObject:(id)object {
    NSHashTable *observers = self.observers;
    for (id observer in observers) {
        if ([observer respondsToSelector:selector]) {
            EMIDispatchOnMainQueue(^{
                [observer performSelector:selector withObject:self withObject:object];
            });
        }
    }
}

#pragma clang diagnostic pop

- (void)notifyObserversOfStateChangedWithObject:(id)object {
    [self notifyOfStateChangedWithSelector:[self selectorForState:self.state] withObject:object];
}

- (void)notifyObserversOfStateChanged {
    [self notifyObserversOfStateChangedWithObject:nil];
}

- (void)performBlock:(void(^)(void))block shouldNotify:(BOOL)shouldNotify {
    BOOL notificationState = self.shouldNotify;
    self.shouldNotify = shouldNotify;
    if (block) {
        block();
    }
    
    self.shouldNotify = notificationState;
}

- (SEL)selectorForState:(NSUInteger)state {
    return NULL;
}

#pragma mark -
#pragma mark NSCoding

- (instancetype)initWithCoder {
    self = [super init];
    if (self) {
        self.shouldNotify = YES;
    }
    
    return self;
}

@end
