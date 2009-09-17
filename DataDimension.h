//
//  DataDimension.h
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DataDimension : NSObject {

	int numValues;
	
	float *values;
	
	float min, max;
	
	BOOL inverted;
}

@property (nonatomic, readonly) int numValues;

@property (nonatomic, readonly) float *values;

@property (nonatomic, readonly) float min;

@property (nonatomic, readonly) float max;

@property (nonatomic, assign) BOOL inverted;


- (void)addValue:(float)v;

- (void)normalize;

@end
