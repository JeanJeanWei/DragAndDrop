

#import "DragContext.h"
#import "WordLabel.h"

@implementation DragContext {

    UIView *_draggedView;
    CGPoint _originalPosition;
    UIView *_originalView;
    int _index;
}
@synthesize draggedView = _draggedView;
@synthesize originalView = _originalView;


- (id)initWithDraggedView:(UIView *)draggedView andIndex:(int)index
{
    self = [super init];
    if (self) {
        _draggedView = draggedView ;
        _originalPosition = _draggedView.frame.origin;
        _originalView = _draggedView.superview;
        _index = index;
    }

    return self;
}

- (void)dealloc {
    
}

- (void)removeFromDragableArray:(NSMutableArray*)array
{
    [array removeObjectAtIndex:_index];
}
- (void)snapToOriginalPosition
{
   
}
- (void)snapToOriginalPosition:(NSArray*)list
{
    [UIView animateWithDuration:0.3 animations:^() {
        CGPoint originalPointInSuperView = [_draggedView.superview convertPoint:_originalPosition fromView:_originalView];
        _draggedView.frame = CGRectMake(originalPointInSuperView.x, originalPointInSuperView.y, _draggedView.frame.size.width, _draggedView.frame.size.height);
    } completion:^(BOOL finished) {
        _draggedView.frame = CGRectMake(_originalPosition.x, _originalPosition.y, _draggedView.frame.size.width, _draggedView.frame.size.height);
        [_draggedView removeFromSuperview];
        [_originalView addSubview:_draggedView];
        
        UIView *view = [list objectAtIndex:0];
        if (_draggedView.center.y != view.center.y) {
            return;
        }
        
        bool startReposition = NO;
        for (int i = 0; i < list.count; i++)
        {
            UIView *view = [list objectAtIndex:i];
            if ([view isKindOfClass:[UIButton class]])
            {
                UIButton *temp = (UIButton*) view;
                CGPoint p = temp.origCenter;
               // if (CGRectIntersectsRect(_draggedView.frame, view.frame)) {
                    if ( _draggedView.center.x <= p.x && !startReposition) {
                        // Do something
                        //viewBeingDragged.frame = CGRectMake(0, 0, viewBeingDragged.frame.size.width, viewBeingDragged.frame.size.height);
                        _draggedView.center = CGPointMake(p.x-temp.frame.size.width/2, p.y);
                        UIView *prev = [list objectAtIndex:i-1];
                        prev.center = CGPointMake(prev.center.x, p.y);
                        //temp.center = CGPointMake(p.x+10, p.y);
                        startReposition = YES;
                    }
                    if (startReposition) {
                        view.center =  CGPointMake(p.x+5, p.y);
                    }
                //}
            }
            
            
        }
    }];
}
@end