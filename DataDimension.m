//
//  DataDimension.m
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DataDimension.h"
#import <math.h>

#define NUM_PREALLOC 500

@implementation DataDimension

@synthesize values;
@synthesize numValues;
@synthesize min;
@synthesize max;
@synthesize inverted;

- (id)init {
	if ((self = [super init])) {
		numValues = 0;
		values = malloc(NUM_PREALLOC * sizeof(float));
		min = INFINITY;
		max = -INFINITY;
		inverted = NO;
	}
	return self;
}

- (void)addValue:(float)v {
	values[numValues++] = v;
	if (v < min)
		min = v;
	if (v > max)
		max = v;
}

@end
