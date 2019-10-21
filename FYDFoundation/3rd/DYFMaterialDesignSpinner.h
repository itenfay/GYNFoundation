//
//  DYFMaterialDesignSpinner.h
//
//  Created by dyf on 15/7/4.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYFMaterialDesignSpinner : UIView

/** Sets the line width of the spinner's circle. */
@property (nonatomic) CGFloat lineWidth;

/** Sets whether the view is hidden when not animating. */
@property (nonatomic) BOOL hidesWhenStopped;

/** Specifies the timing function to use for the control's animation. Defaults to kCAMediaTimingFunctionEaseInEaseOut */
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

/** Property indicating whether the view is currently animating. */
@property (nonatomic, readonly) BOOL isAnimating;

/** Sets the line color of the spinner's circle. */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  Starts animation of the spinner.
 */
- (void)startAnimating;

/**
 *  Stops animation of the spinnner.
 */
- (void)stopAnimating;

@end
