//
//  DataSet.m
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DataSet.h"
#import "FMDatabase.h"
#import "DataDimension.h"
#import <Foundation/NSBundle.h>

NSString *dbName = @"data.db";

#define NUM_DIMENSIONS 6

@implementation DataSet

@synthesize dimensions;
@synthesize brushed;

- (id)init {
	if ((self = [super init])) {
		dimensions = [NSMutableArray arrayWithCapacity:NUM_DIMENSIONS];
		[dimensions retain];
		for (int i = 0; i < NUM_DIMENSIONS; i++)
			[dimensions addObject:[[DataDimension alloc] init]];

		brushed = calloc(500, sizeof(BOOL));
		[self resetBrush];
		
		FMDatabase *db = [[FMDatabase alloc] initWithPath:[[NSBundle mainBundle] pathForResource:dbName ofType:nil]];
		if ([db open]) {
			FMResultSet *rs = [db executeQuery:@"select MPG, Cylinders, Horsepower, Weight, Acceleration, Year from cars;"];
			if ([db hadError])
				NSLog(@"%@", [db lastErrorMessage]);
			while ([rs next]) {
				for (int i = 0; i < NUM_DIMENSIONS; i++)
					[(DataDimension *)[dimensions objectAtIndex:i] addValue:(float)[rs doubleForColumnIndex:i]];
			}
			[rs close];
			[db close];
		} else {
			NSLog(@"Could not open DB!");
		}
		
		for (DataDimension *dim in dimensions)
			[dim normalize];

//		NSLog(@"%d rows", [self numValues]);
	}
	return self;
}

- (int)numValues {
	return ((DataDimension *)[dimensions objectAtIndex:0]).numValues;
}

- (void)brushByDimension:(int)axis from:(float)normalizedMin to:(float)normalizedMax {
	DataDimension *dim = [dimensions objectAtIndex:axis];
	for (int i = 0; i < dim.numValues; i++)
		brushed[i] = (dim.values[i] >= normalizedMin) && (dim.values[i] <= normalizedMax);
}

- (void)brushByDimension1:(int)axis1 dimension2:(int)axis2 from1:(float)normalizedMin1 to1:(float)normalizedMax1 from2:(float)normalizedMin2 to2:(float)normalizedMax2 {
	DataDimension *dim1 = [dimensions objectAtIndex:axis1];
	DataDimension *dim2 = [dimensions objectAtIndex:axis2];
	for (int i = 0; i < dim1.numValues; i++)
		brushed[i] = (dim1.values[i] >= normalizedMin1) && (dim1.values[i] <= normalizedMax1)
					 && (dim2.values[i] >= normalizedMin2) && (dim2.values[i] <= normalizedMax2);
}

- (void)angularBrushDimension:(int)axis1 dimension2:(int)axis2 from:(float)minDifference to:(float)maxDifference {
	DataDimension *dim1 = [dimensions objectAtIndex:axis1];
	DataDimension *dim2 = [dimensions objectAtIndex:axis2];
	for (int i = 0; i < dim1.numValues; i++) {
		float difference = dim1.values[i]-dim2.values[i];
		brushed[i] = (difference >= minDifference) && (difference <= maxDifference);
	}
}

- (void)resetBrush {
	memset(brushed, YES, 500 * sizeof(BOOL));
}

@end
