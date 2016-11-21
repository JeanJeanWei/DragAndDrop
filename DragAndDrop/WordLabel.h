//
//  WordLabel.h
//  DragAndDrop
//
//  Created by Jean-Jean Wei on 13-04-28.
//  Copyright (c) 2013 Jean-Jean Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordLabel : UIButton
{
    CGPoint origCenter;
    CGRect box;
    CGPoint currXY;
    CGRect initialPos;
    bool hasBeenTouched;
}

@property (assign) CGPoint origCenter;
@property (assign) CGRect box;
@property (assign) CGPoint currXY;
@property (assign) CGRect initialPos;
@property (assign) bool hasBeenTouched;

- (WordLabel*)clone;

@end
