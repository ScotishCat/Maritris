//
//  EMIObservableObject.h
//  Homework
//
//  Created by Marina Butovich on 8/9/15.
//
//

#import <Foundation/Foundation.h>

@interface EMIObservableObject : NSObject
@property (nonatomic, readonly) NSSet       *observerSet;
@property (nonatomic, assign)   NSUInteger  state;

- (void)setState:(NSUInteger)state withObject:(id)object;

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;
- (BOOL)isObservedByObject:(id)observer;

- (void)notifyOfStateChangedWithSelector:(SEL)selector withObject:(id)object;
- (void)notifyObserversOfStateChangedWithObject:(id)object;
- (void)notifyObserversOfStateChanged;

- (void)performBlock:(void(^)(void))block shouldNotify:(BOOL)shouldNotify;

// this method should be overridden in subclasses
// do not call it directly
- (SEL)selectorForState:(NSUInteger)state;

@end
