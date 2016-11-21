

#import <Foundation/Foundation.h>


@interface DragContext : NSObject
@property(strong, readonly) UIView *draggedView;
@property(strong) UIView *originalView;


- (id)initWithDraggedView:(UIView *)draggedView andIndex:(int)index;

- (void)snapToOriginalPosition:(NSArray*)list;
- (void)snapToOriginalPosition;
- (void)removeFromDragableArray:(NSMutableArray*)array;
@end