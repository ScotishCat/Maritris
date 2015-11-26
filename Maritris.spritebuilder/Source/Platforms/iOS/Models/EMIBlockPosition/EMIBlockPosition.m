//
//  EMIBlockPosition.m
//  Maritris
//
//  Created by Marina Butovich on 11/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "EMIBlockPosition.h"

@interface EMIBlockPosition ()
@property (nonatomic, assign) NSUInteger column;
@property (nonatomic, assign) NSUInteger row;

- (NSString *)description;

@end

@implementation EMIBlockPosition

#pragma mark -
#pragma mark Class Methods

+ (instancetype)positionWithColumn:(NSUInteger)column row:(NSUInteger)row {
    return [[self alloc] initWithColumn:column row:row];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithColumn:(NSUInteger)column row:(NSUInteger)row {
    self = [super init];
    if (self) {
        self.column = column;
        self.row = row;
    }
    
    return self;
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    EMIBlockPosition *result = [[[self class] alloc] initWithColumn:self.column row:self.row];
    
    return result;
}

- (BOOL)isEqual:(EMIBlockPosition *)object {
    // Check for comparing with itself
    if (self == object) {
        return YES;
    }
    
    // Check if object of the same class as we
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return (self.row == object.row && self.column == object.column);
}

// According to Apple reccomendations, if we override -isEqual: method, we should always also override -hash
- (NSUInteger)hash {
    return self.column ^ self.row; // Use bitwise XOR of row and column to generate hash
}

#pragma mark -
#pragma mark Private

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, column: %lu, row: %lu",
            [super description],
            (unsigned long)self.column,
            (unsigned long)self.row];
}

@end
