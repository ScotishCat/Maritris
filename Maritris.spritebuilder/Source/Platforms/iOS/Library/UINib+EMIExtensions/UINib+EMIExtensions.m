//
//  UINib+EMIExtensions.m
//  TableView_task_2
//
//  Created by Marina Butovich on 9/20/15.
//  Copyright (c) 2015 Marina Butovich. All rights reserved.
//

#import "UINib+EMIExtensions.h"

#import "NSArray+EMIExtensions.h"

@implementation UINib (EMIExtensions)

#pragma mark -
#pragma mark Class Methods

+ (UINib *)nibWithClass:(Class)cls {
    return [self nibWithClass:cls bundle:nil];
}

+ (UINib *)nibWithClass:(Class)cls bundle:(NSBundle *)bundle {
    return [self nibWithNibName:NSStringFromClass(cls) bundle:bundle];
}

+ (id)objectWithClass:(Class)cls {
    return [self objectWithClass:cls owner:nil bundle:nil];
}

+ (id)objectWithClass:(Class)cls owner:(id)owner {
    return [self objectWithClass:cls owner:owner bundle:nil];
}

+ (id)objectWithClass:(Class)cls owner:(id)owner bundle:(NSBundle *)bundle {
    UINib *nib = [self nibWithClass:cls bundle:bundle];
    
    return [nib objectWithClass:cls owner:owner];
}

#pragma mark -
#pragma mark Public

- (id)objectWithClass:(Class)cls {
    NSArray *objects = [self instantiateWithOwner:nil options:nil];
    
    return [objects firstObjectOfClass:cls];
}

- (id)objectWithClass:(Class)cls owner:(id)owner {
    NSArray *objects = [self instantiateWithOwner:owner options:nil];
    
    return [objects firstObjectOfClass:cls];
}

@end
