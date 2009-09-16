//
//  TrackPadFingersLayer.h
//  ParVis X
//
//  Created by Robert Kosara on 9/16/09.
//  Copyright 2009 UNC Charlotte. All rights reserved.
//

#import <QuartzCore/CALayer.h>


@interface TrackPadFingersLayer : CALayer {

	NSDictionary *touches;
	
}

- (id)initWithFrame:(CGRect)frame touchData:(NSDictionary *)touchData;

@end
