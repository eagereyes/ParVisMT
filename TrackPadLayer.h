//
//  TrackPadLayer.h
//  ParVisX
//
//  Created by Robert Kosara on 9/12/09.
//  Copyright 2009 UNC Charlotte. All rights reserved.
//

#import <QuartzCore/CALayer.h>


@interface TrackPadLayer : CALayer {

	NSDictionary *touches;

	int numDimensions;
	
}

- (id)initWithFrame:(CGRect)frame touchData:(NSDictionary *)touchData numDimensions:(int)numDims;

@end
