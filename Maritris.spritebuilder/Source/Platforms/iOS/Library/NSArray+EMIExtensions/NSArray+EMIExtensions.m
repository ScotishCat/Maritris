//
//  NSArray+EMIExtensions.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/20/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "NSArray+EMIExtensions.h"

@implementation NSArray (EMIExtensions)

- (id)firstObjectOfClass:(Class)cls {
    id result = nil;
    
    for (id currentObject in self) {
        if ([currentObject isKindOfClass:cls]) {
            result = currentObject;
            break;
        }
    }
    
    return result;
}

@end
