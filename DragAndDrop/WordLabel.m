//
//  WordLabel.m
//  DragAndDrop
//
//  Created by Jean-Jean Wei on 13-04-28.
//  Copyright (c) 2013 Jean-Jean Wei. All rights reserved.
//

#import "WordLabel.h"

@implementation WordLabel

@synthesize origCenter, box, currXY;
@synthesize hasBeenTouched, initialPos;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self) {
        // Initialization code
        hasBeenTouched = NO;
        
    }
    return self;
}
- (void)setXY
{
    currXY = self.frame.origin;
    
}
- (WordLabel*)clone
{
    WordLabel *clone = [WordLabel new];
    [clone setTitle:self.currentTitle forState:UIControlStateNormal];
    [clone setTitleColor:self.currentTitleColor forState:UIControlStateNormal];
    
    
    clone.backgroundColor = self.backgroundColor;
    clone.titleLabel.textAlignment = self.titleLabel.textAlignment;
    clone.titleLabel.font = self.titleLabel.font;
    clone.hasBeenTouched = NO;
    clone.frame = self.initialPos;
    clone.initialPos = self.initialPos;
    return clone;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
