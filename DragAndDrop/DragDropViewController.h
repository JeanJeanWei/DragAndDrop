//
//  DragDropViewController.h
//
//  
//  Created by Jean-Jean Wei on 13-04-28.
//  Copyright (c) 2013 Jean-Jean Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DragDropManager;

@interface DragDropViewController : UIViewController
{
    int type;
    UIView * _topView;
    UIView * _viewB;
    DragDropManager *_dragDropManager;
}
@property(strong) UIView *topView;
@property(strong) UIView *viewB;
@property(strong) DragDropManager *dragDropManager;
@property(assign) int type;

- (IBAction)btnDismss;

@end
