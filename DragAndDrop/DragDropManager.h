//
//  Created by jve on 4/1/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class DragContext;


@interface DragDropManager : NSObject
{
    UIView *topView;
    UIView *standbyView;
    int quizType;
}

- (id)initWithDragSubjects:(NSMutableArray *)dragSubjects andDropAreas:(NSArray *)dropAreas andSubList:(NSArray *)subList;

- (void)dragging:(id)sender;


@property(nonatomic, retain) DragContext *dragContext;
@property(nonatomic, retain, readonly) NSArray *dropAreas;
@property(assign) int quizType;

@end