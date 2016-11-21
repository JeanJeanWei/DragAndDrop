//
//  UIButton+Drag.m
//  DragAndDrop
//
//  Created by Jean-Jean Wei on 13-05-18.
//  Copyright (c) 2013 Jean-Jean Wei. All rights reserved.
//
#import <objc/runtime.h>
#import "UIButton+Drag.h"

@implementation UIButton (Drag)
@dynamic origCenter, box;
@dynamic hasBeenTouched, initialPos;


static const NSString *BOX = @"box";
static const NSString *OrigCenter= @"origCenter";
static const NSString *InitialPos= @"initialPos";
static const NSString *HasBeenTouched= @"hasBeenTouched";


-(void)setHasBeenTouched:(bool)hasBeenTouched
{
    NSValue *value = [NSValue value:&hasBeenTouched withObjCType:@encode(bool)];
    objc_setAssociatedObject(self, &HasBeenTouched, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(bool)hasBeenTouched
{
    NSValue *value = objc_getAssociatedObject(self, &HasBeenTouched);
    if(value) {
        bool hasBeenTouched;
        [value getValue:&hasBeenTouched];
        return hasBeenTouched;
    }else {
        return NO;
    }
}

-(void)setInitialPos:(CGRect)initialPos
{
    NSValue *value = [NSValue value:&initialPos withObjCType:@encode(CGRect)];
    objc_setAssociatedObject(self, &InitialPos, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRect)initialPos
{
    NSValue *value = objc_getAssociatedObject(self, &InitialPos);
    if(value) {
        CGRect initialPos;
        [value getValue:&initialPos];
        return initialPos;
    }else {
        return CGRectZero;
    }
}

-(void)setOrigCenter:(CGPoint)origCenter
{
    NSValue *value = [NSValue value:&origCenter withObjCType:@encode(CGPoint)];
    objc_setAssociatedObject(self, &OrigCenter, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGPoint)origCenter
{
    NSValue *value = objc_getAssociatedObject(self, &OrigCenter);
    if(value) {
        CGPoint origCenter;
        [value getValue:&origCenter];
        return origCenter;
    }else {
        return CGPointZero;
    }
}

-(void)setBox:(CGRect)box
{
    NSValue *value = [NSValue value:&box withObjCType:@encode(CGRect)];
    objc_setAssociatedObject(self, &BOX, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRect)box
{
    NSValue *value = objc_getAssociatedObject(self, &BOX);
    if(value) {
        CGRect box;
        [value getValue:&box];
        return box;
    }else {
        return CGRectZero;
    }
}


- (UIButton*)clone
{
    UIButton *clone = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [clone setTitle:self.currentTitle forState:UIControlStateNormal];
    [clone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    clone.backgroundColor = self.backgroundColor;
    clone.titleLabel.textAlignment = self.titleLabel.textAlignment;
    clone.titleLabel.font = self.titleLabel.font;
    clone.hasBeenTouched = NO;

    clone.frame = self.initialPos;
    clone.initialPos = self.initialPos;
    return clone;
}
@end
