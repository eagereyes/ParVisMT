//
//  DataSet.h
//  ParVisX
//
//  Created by Robert Kosara on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DataSet : NSObject {

	NSMutableArray *dimensions;
	
	BOOL *brushed;
}

@property (nonatomic, readonly) NSArray *dimensions;

@property (nonatomic, readonly) BOOL *brushed;

- (int)numValues;

- (void)brushByDimension:(int)axis from:(float)normalizedMin to:(float)normalizedMax;

- (void)brushByDimension1:(int)axis1 dimension2:(int)axis2 from1:(float)normalizedMin1 to1:(float)normalizedMax1 from2:(float)normalizedMin2 to2:(float)normalizedMax2;

- (void)angularBrushDimension:(int)axis1 dimension2:(int)axis2 from:(float)minDifference to:(float)maxDifference;

- (void)resetBrush;

@end
