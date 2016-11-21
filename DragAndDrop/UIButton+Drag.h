//
//  UIButton+Drag.h
//  DragAndDrop
//
//  Created by Jean-Jean Wei on 13-05-18.
//  Copyright (c) 2013 Jean-Jean Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Drag)

@property (nonatomic, assign) CGPoint origCenter;
@property (nonatomic, assign) CGRect box;
@property (nonatomic, assign) CGRect initialPos;
@property (nonatomic, assign) bool hasBeenTouched;

- (UIButton*)clone;
@end
