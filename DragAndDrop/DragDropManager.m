//
//  Created by jve on 4/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DragDropManager.h"
#import "DragContext.h"
#import "WordLabel.h"

#define offY  5

@implementation DragDropManager {

    NSMutableArray *_dragSubjects;
    NSArray *_dropAreas;
    NSMutableArray *_subList;
    CGFloat minY;
    CGFloat maxY;
    DragContext *_dragContext;
    CGFloat statusBarHeight;
    int collisionIndex;
   
}

@synthesize dragContext = _dragContext;
@synthesize dropAreas = _dropAreas;
@synthesize quizType;

- (id)initWithDragSubjects:(NSMutableArray *)dragSubjects andDropAreas:(NSArray *)dropAreas andSubList:(NSMutableArray *)subList
{
    self = [super init];
    if (self) {
        _dropAreas = dropAreas;
        _dragSubjects = [dragSubjects mutableCopy];
        _dragContext = nil;
        standbyView = [_dropAreas objectAtIndex:1];
        topView = [_dropAreas objectAtIndex:0];
        _subList = [subList mutableCopy];
        UIButton *tmp = [subList objectAtIndex:0];

        minY = tmp.frame.origin.y;
        maxY = minY + tmp.frame.size.height;
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        
        
    }
    return self;
}


- (void)dealloc {
   
}


- (void)repositioningSentance:(UIButton*)dragSubject
{
    int index = [_subList indexOfObject:dragSubject];
    NSLog(@"remove subject from index = %d",index);
    float xPos = dragSubject.box.origin.x;
    float yPos = dragSubject.box.origin.y;
    [_subList removeObjectAtIndex:index];
    
    for (int i = index; i < _subList.count; i++)
    {
        //UIButton *view = [_subList objectAtIndex:i];
        
        UIButton *tmp = [_subList objectAtIndex:i];
        CGRect f = tmp.frame;
       
        
        
        f.origin.x = xPos;
        f.origin.y = yPos;
        
        tmp.frame = f;
        
        if (f.origin.x + f.size.width > topView.frame.size.width) {
            yPos += f.size.height*1.2;
            xPos = 10;
            f.origin.x = xPos;
            f.origin.y = yPos;
            tmp.frame = f;
            
        }
        tmp.origCenter = tmp.center;
        tmp.box = tmp.frame;
         NSLog(@"text = %@, frame = %@",tmp.titleLabel.text,NSStringFromCGRect(tmp.frame) );
        xPos += tmp.frame.size.width;
        yPos = tmp.frame.origin.y;
    }
    
}

- (void)dragObjectAccordingToGesture:(UIPanGestureRecognizer *)recognizer
{
    if (self.dragContext)
    {
        CGPoint pointOnView = [recognizer locationInView:recognizer.view];
        //CGPoint pointOnView = [recognizer locationInView:topView];
        self.dragContext.draggedView.center = pointOnView;
        //NSLog(@"move point%@",NSStringFromCGPoint(pointOnView));
        
        
        CGPoint point = [topView convertPoint:pointOnView fromView:nil];
        point.y += statusBarHeight;
        
       // NSLog(@"move PPPPPPP%@",NSStringFromCGPoint(point));
        if (quizType == 1) {
            bool hasCollision = NO;
            for (int i = 0; i < _subList.count; i++)
            {
                UIView *view = [_subList objectAtIndex:i];
                if (self.dragContext.draggedView == view)
                    continue;
                
                
                UIButton *temp = (UIButton*) view;
                CGPoint p = temp.origCenter;
                
                if (CGRectContainsPoint(temp.box,point)) {
                    // Do something
                    NSLog(@"collision point%@",NSStringFromCGRect(view.frame));
                    
                    
                    p.y -= offY;
                    collisionIndex = i;
                    hasCollision = YES;
                    
                }
                view.center = p;
                
            }
            if (!hasCollision) {
                collisionIndex = -1;
            }
        } else {
            UIButton *tmp = [_subList objectAtIndex:1];
            
             if (CGRectContainsPoint(tmp.box,point))
             {
                 if (self.dragContext) {
                     UIButton *w = (UIButton *) self.dragContext.draggedView;
                     //tmp.titleLabel.text = w.titleLabel.text;
                     [tmp setTitle:w.currentTitle forState:UIControlStateNormal];
                     NSLog(@"release draggable object after collision");
                     recognizer.enabled = NO;
                      NSLog(@"text = %@, frame = %@",tmp.titleLabel.text,NSStringFromCGRect(tmp.frame) );
//                     w.center = w.origCenter;
//                     //if (!w.superview) {
//                     [w removeFromSuperview];
//                          [standbyView addSubview:w];
                     //}
                 
                 }
                 
             }
        }
        
        
    }
}

- (void)dragging:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
             NSLog(@"UIGestureRecognizerStateBegant");
            UIButton *clone = nil;
             BOOL needReposition = NO;
            //for (UIButton *dragSubject in _dragSubjects)
            for (int i = 0; i<_dragSubjects.count; i++) {
                UIButton *dragSubject = [_dragSubjects objectAtIndex:i];
            
                //todo: pointInside seems to answer no even tough the point is actually inside the view?
                
                CGPoint pointInSubjectsView = [recognizer locationInView:dragSubject];
               
                 BOOL pointInSideDraggableObject = [dragSubject pointInside:pointInSubjectsView withEvent:nil];
               
//                CGPoint pointInSubjectsView = [recognizer locationInView:recognizer.view];//dragSubject];
//                 CGPoint point = [dragSubject convertPoint:pointInSubjectsView fromView:nil];
//                point.y += statusBarHeight;
//                BOOL pointInSideDraggableObject = CGRectContainsPoint(dragSubject.bounds,point);//[dragSubject pointInside:pointInSubjectsView withEvent:nil];
                
                
                //NSLog(@"point%@ %@ subject%@", NSStringFromCGPoint(pointInSubjectsView), pointInSideDraggableObject ? @"inside" : @"outside", NSStringFromCGRect(dragSubject.frame));
                if (pointInSideDraggableObject)
                {
                    NSLog(@"started dragging an object");
                    
                        if (!dragSubject.hasBeenTouched) {
                            clone = [dragSubject clone];
                            //[_dragSubjects addObject:clone];
                            [standbyView addSubview:clone];
                            
                            
                            dragSubject.hasBeenTouched = YES;
                            
                        } else {
                            NSUInteger fooIndex = [_subList indexOfObject:dragSubject];
                            NSLog(@"fooIndex = %d",fooIndex);
                            needReposition = YES;
                            
                        }
                    
                    
                    //[dragSubject setBackgroundColor:<#(UIColor *)#>]
                    self.dragContext = [[DragContext alloc] initWithDraggedView:dragSubject andIndex:i];
                    [dragSubject removeFromSuperview];
                    [recognizer.view addSubview:dragSubject];
                    [self dragObjectAccordingToGesture:recognizer];
                    
                } else {
                    NSLog(@"started drag outside drag subjects");
                }
            }
            if (clone) {
                [_dragSubjects addObject:clone];
            }
            if (needReposition && quizType == 1) {
                [self repositioningSentance:(UIButton*)self.dragContext.draggedView];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self dragObjectAccordingToGesture:recognizer];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            
            if (self.dragContext && quizType == 2) {
                UIButton *viewBeingDragged = (UIButton*) self.dragContext.draggedView;

                NSLog(@"UIGestureRecognizerStateEnded type == 2 - release draggable object outside target viewsn");
                
                [viewBeingDragged removeFromSuperview];
                [self.dragContext removeFromDragableArray:_dragSubjects];
                viewBeingDragged = nil;
                self.dragContext = nil;
                break;
            }
            
            if (self.dragContext && quizType == 1)
            {
                UIButton *viewBeingDragged = (UIButton*) self.dragContext.draggedView;
                NSLog(@"ended drag event");
                CGPoint centerOfDraggedView = viewBeingDragged.center;
                CGPoint pointInDropView;
                BOOL droppedViewInKnownArea = NO;
                
                
                CGPoint point = [topView convertPoint:centerOfDraggedView fromView:nil];
                point.y += statusBarHeight;
                
                pointInDropView = [recognizer locationInView:standbyView];
                if ([standbyView pointInside:pointInDropView withEvent:nil])
                {/*
                    droppedViewInKnownArea = YES;
                    //NSLog(@"dropped subject %@ on to view tag %i", NSStringFromCGRect(viewBeingDragged.frame), dropArea.tag);
                    [viewBeingDragged removeFromSuperview];
                    [standbyView addSubview:viewBeingDragged];
                    //hange origin to match offset on new super view
                    viewBeingDragged.frame = CGRectMake(pointInDropView.x - (viewBeingDragged.frame.size.width / 2), pointInDropView.y - (viewBeingDragged.frame.size.height / 2),
                    viewBeingDragged.frame.size.width, viewBeingDragged.frame.size.height);
                   */
                }
                
                pointInDropView = [recognizer locationInView:topView];
                if (collisionIndex != -1)
                {
                    [viewBeingDragged removeFromSuperview];
                    [topView addSubview:viewBeingDragged];
                    
                    droppedViewInKnownArea = YES;
                    UIButton *myWord = [_subList objectAtIndex:collisionIndex];
                    CGPoint p = myWord.origCenter;
                    float xPos = 0;
                    float yPos = p.y-myWord.frame.size.height/2;
                    int repositionIndex = -1;
                    // TO: fix insert front overlay bug need to check if oversize
                    if (collisionIndex == 0 || pointInDropView.x > p.x)
                    {
                        viewBeingDragged.center = CGPointMake(p.x + myWord.frame.size.width/2+viewBeingDragged.frame.size.width/2, p.y);
                        viewBeingDragged.origCenter = viewBeingDragged.center;
                        viewBeingDragged.box = viewBeingDragged.frame;
                        
                        xPos = viewBeingDragged.frame.origin.x + viewBeingDragged.frame.size.width;
                        myWord.center = p;
                        
                        NSRange range = NSMakeRange(collisionIndex+1, 1);
                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                        NSArray *newAdditions = [NSArray arrayWithObjects: viewBeingDragged, nil];
                        [_subList insertObjects:newAdditions atIndexes:indexSet];
                        repositionIndex = collisionIndex+2;
                    }
                    else
                    {
                        CGRect f = myWord.frame;
                        f.size = viewBeingDragged.frame.size;
                        f.origin.y = yPos;
                        viewBeingDragged.frame = f;
                        viewBeingDragged.origCenter = viewBeingDragged.center;
                        viewBeingDragged.box = viewBeingDragged.frame;
                        
                        xPos = f.origin.x + f.size.width;
                        f = myWord.frame;
                        f.origin.x = xPos;
                        f.origin.y = yPos;
                        myWord.frame = f;
                        xPos += myWord.frame.size.width;
                        if (f.origin.x + f.size.width > topView.frame.size.width) {
                            yPos = (f.origin.y + f.size.height*1.2);
                            xPos = 10;
                            f.origin.x = xPos;
                            f.origin.y = yPos;
                            myWord.frame = f;
                            
                        }
                        myWord.origCenter = myWord.center;
                        myWord.box = myWord.frame;
                        
                        NSRange range = NSMakeRange(collisionIndex, 1);
                        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                        NSArray *newAdditions = [NSArray arrayWithObjects: viewBeingDragged, nil];
                        [_subList insertObjects:newAdditions atIndexes:indexSet];
                         repositionIndex = collisionIndex+2;
                        xPos = myWord.frame.origin.x + f.size.width;
                        yPos = myWord.frame.origin.y;
                        NSLog(@"UIGestureRecognizerStateEnded text collisionIndex == 0 || pointInDropView.x > p.x \n = %@, frame = %@",myWord.titleLabel.text,NSStringFromCGRect(myWord.frame) );
                    }
                    
                    if (collisionIndex < _subList.count) {
                        for (int i = repositionIndex; i < _subList.count; i++)
                        {
                            UIView *view = [_subList objectAtIndex:i];
                            if ([view isKindOfClass:[UIButton class]])
                            {
                                UIButton *tmp = (UIButton*) view;
                                CGRect f = tmp.frame;
                                
                                
                                
                                f.origin.x = xPos;
                                f.origin.y = yPos;
                                tmp.frame = f;
                                
                                if (f.origin.x + f.size.width > topView.frame.size.width) {
                                    yPos += f.size.height*1.2;
                                    xPos = 10;
                                    f.origin.x = xPos;
                                    f.origin.y = yPos;
                                    tmp.frame = f;
                                    
                                }
                                tmp.origCenter = tmp.center;
                                tmp.box = tmp.frame;
                                NSLog(@"UIGestureRecognizerStateEnded text = %@, frame = %@",tmp.titleLabel.text,NSStringFromCGRect(tmp.frame) );
                                xPos += tmp.frame.size.width;
                                yPos = tmp.frame.origin.y;
                            }

                        }
                        
                    }
                    
                    
                }
                                
                
                if (!droppedViewInKnownArea) {
                    NSLog(@"UIGestureRecognizerStateEnded - release draggable object outside target views");
                    //[self.dragContext snapToOriginalPosition:_subList];
                    [viewBeingDragged removeFromSuperview];
                    [self.dragContext removeFromDragableArray:_dragSubjects];
                    viewBeingDragged = nil;
                }
                
                self.dragContext = nil;
            } else {
                NSLog(@"Nothing was being dragged");
            }
            break;
        }
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.dragContext && quizType == 2) {
                UIButton *viewBeingDragged = (UIButton*) self.dragContext.draggedView;
                NSLog(@"UIGestureRecognizerStateCancelled - release draggable object outside target views");
                //[self.dragContext snapToOriginalPosition:_subList];
                [viewBeingDragged removeFromSuperview];
                [self.dragContext removeFromDragableArray:_dragSubjects];
                viewBeingDragged = nil;
                self.dragContext = nil;
                recognizer.enabled = YES;
                
            }
            break;
        case UIGestureRecognizerStateFailed:
            break;

    }
}
@end