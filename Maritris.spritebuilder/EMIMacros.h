//
//  EMIMacros.h
//  EMISquareHolder
//
//  Created by Marina Butovich on 9/14/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMIDefineMainViewProperty(propertyName, viewClass) \
    @property (nonatomic, readonly) viewClass   *propertyName;

#define EMIViewGetterSynthesize(selector, viewClass) \
    - (viewClass *)selector { \
        if ([self isViewLoaded] && [self.view isKindOfClass:[viewClass class]]) { \
            return (viewClass *)self.view; \
        } \
        \
        return nil; \
    }

#define EMIViewControllerMainViewProperty(viewControllerClass, propertyName, viewClass) \
    @interface viewControllerClass (__##viewClass##_##propertyName) \
    EMIDefineMainViewProperty(propertyName, viewClass) \
    \
    @end \
    \
    @implementation viewControllerClass (__##viewClass##_##propertyName) \
    \
    @dynamic propertyName; \
    \
    EMIViewGetterSynthesize(propertyName, viewClass) \
    \
    @end

#define EMIWeakify(variable) \
    __weak __typeof(variable) __EMIWeakified_##variable = variable

// should be called only after weakify was called for the same variable
#define EMIStrongify(variable) \
    __strong __typeof(variable) variable = __EMIWeakified_##variable 

#define EMIStrongifyAndReturnResultIfNil(variable, result) \
    EMIStrongify(variable); \
    if (!variable) { \
        return result; \
    }

#define EMIEmptyMacro

#define EMIStrongifyAndReturnNilIfNil(variable) \
    EMIStrongifyAndReturnResultIfNil(variable, nil)

#define EMIStrongifyAndReturnIfNil(variable) \
    EMIStrongifyAndReturnResultIfNil(variable, EMIEmptyMacro)

#define EMIShouldSleep 1

#if EMIShouldSleep == 1
    #define EMISleep(time) [NSThread sleepForTimeInterval:time]
#else
    #define EMISleep(time)
#endif

#define EMILoad(propertyName) \
    [_##propertyName load];

#define __EMISynthesizeObservingSetterWithParameter(propertyName, parameter) \
    if (_##propertyName != propertyName) { \
        [_##propertyName removeObserver:self]; \
        _##propertyName = propertyName; \
        [_##propertyName addObserver:self]; \
        parameter \
    }

#define EMISynthesizeObservingSetter(propertyName) \
__EMISynthesizeObservingSetterWithParameter(propertyName, EMIEmptyMacro)

#define EMISynthesizeObservingSetterAndLoad(propertyName) \
__EMISynthesizeObservingSetterWithParameter(propertyName, EMILoad(propertyName))

#define EMISynthesizeContextSetter(propertyName) \
    if (_##propertyName != propertyName) { \
        [_##propertyName cancel]; \
        _##propertyName = propertyName; \
        [_##propertyName execute]; \
    }

