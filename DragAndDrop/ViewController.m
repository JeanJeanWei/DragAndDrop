//
//  ViewController.m
//  DragAndDrop
//
//  Created by Jean-Jean Wei on 13-04-28.
//  Copyright (c) 2013 Jean-Jean Wei. All rights reserved.
//

#import "ViewController.h"
#import "DragDropViewController.h"
#import "UIButton+Drag.h"
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    
    
	// create a new button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Drag me!" forState:UIControlStateNormal];
    
	// add drag listener
	[button addTarget:self action:@selector(wasDragged:withEvent:)
     forControlEvents:UIControlEventTouchDragInside];
    
	// center and size
	button.frame = CGRectMake((self.view.bounds.size.width - 100)/2.0,
                              (self.view.bounds.size.height - 50)/3.0,
                              100, 50);
    
	// add it, centered
	[self.view addSubview:button];
    NSMutableArray *test = [NSMutableArray new];
    for (int i = 0; i<5; i++) {
        NSString *str = [[NSString alloc] initWithFormat:@"%i",i];
        [test addObject:str];
    }
    
    NSRange range = NSMakeRange(3, 1);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    NSArray *newAdditions = [NSArray arrayWithObjects: @"a", nil];
    [test insertObjects:newAdditions atIndexes:indexSet];
    
    for (int i = 0; i<test.count; i++) {
        NSLog(@"i=%i, value=%@",i,[test objectAtIndex:i]);
    }
//    UIButton *t = [UIButton new];
//    [t setBox:CGRectMake(0,0,44,44)];
//    CGRect y = t.box;
}

- (IBAction)btnPressed:(UIButton*)btn
{
    int idx = btn.tag - 100;
    DragDropViewController *s = [DragDropViewController new];
    s.type = idx;
    s.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:s animated:YES];
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];
    
	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_x = location.x - previousLocation.x;
	CGFloat delta_y = location.y - previousLocation.y;
    
	// move button
	button.center = CGPointMake(button.center.x + delta_x,
                                button.center.y + delta_y);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
