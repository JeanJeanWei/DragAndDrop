//
//  DragDropBetweenViewsViewController.m
//  
//
//  Created by Jean-Jean Wei on 13-04-28.
//  Copyright (c) 2013 Jean-Jean Wei. All rights reserved.
//

#import "DragDropViewController.h"
#import "DragDropManager.h"
#import "WordLabel.h"

@implementation DragDropViewController


@synthesize topView = _topView;
@synthesize viewB = _viewB;
@synthesize dragDropManager = _dragDropManager;
@synthesize type;


#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 300, 200)];
    [_topView setBackgroundColor:[UIColor greenColor]];
    _topView.tag = 1;
    _viewB = [[UIView alloc] initWithFrame:CGRectMake(0, 320, 320, 100)];
    [_viewB setBackgroundColor:[UIColor yellowColor]];
    _viewB.tag = 2;

    [self.view addSubview:_topView];
    [self.view addSubview:_viewB];
    
    //add elements to drag and drop

    
   
//    UILabel *comma = [UILabel new];
//    comma.text = @",";
//    comma.textColor = [UIColor blackColor];
//    comma.font = [UIFont systemFontOfSize:36];
//    comma.backgroundColor = [UIColor redColor];
//    [comma sizeToFit];
//    comma.frame = CGRectMake(100, 100, 40, 40);

    
    // add labels into topView
    NSString *sentance;
    NSString *punctuations;
    NSMutableArray *punctuationArray;
    NSMutableArray *wordList;
    if (type == 1) {
        sentance = @"There's an old saying, Fortune favors the bold. Well, we're about to find out.";
        punctuations =  @", ; .";
        punctuationArray = [self addDragables:punctuations toView:_viewB];
        wordList = [self parseString:sentance toView:_topView];
    } else if (type ==2){
        sentance = @"To ____________ did you give the book?";
        punctuations =  @"Who Whom";
        punctuationArray = [self parseString:punctuations toView:_viewB];
        wordList = [self parseString:sentance toView:_topView];
    } else {
        sentance = @"Theres an old saying, Fortune favors the bold. Well, we're about to find out.";
        punctuations =  @"'";
        punctuationArray = [self addDragables:punctuations toView:_viewB];
        wordList = [self parseCharAtString:sentance toView:_topView];
        type = 1;
    }
     
    

    NSMutableArray *droppableAreas = [[NSMutableArray alloc] initWithObjects:_topView, _viewB, nil];
    _dragDropManager = [[DragDropManager alloc] initWithDragSubjects:punctuationArray andDropAreas:droppableAreas andSubList:wordList];
    _dragDropManager.quizType = type;
    

    UIPanGestureRecognizer * uiTapGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_dragDropManager action:@selector(dragging:)];
    [[self view] addGestureRecognizer:uiTapGestureRecognizer];
    
}
- (NSMutableArray*)addDragables:(NSString*)string toView:(UIView *)view
{
    NSArray *array = [string componentsSeparatedByString: @" "];
    NSMutableArray *arrayToReturn = [NSMutableArray new];
    float i = 10;
    float j = 50;
    for (NSString *str in array)
    {
        UIButton *label = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        label.frame = CGRectMake(i, j, 0, 0);
        //label.titleLabel.text = str;
        [label setTitle:str forState:UIControlStateNormal];
        //label.titleLabel.textColor = [UIColor blackColor];
        [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        label.backgroundColor = [UIColor redColor];
        label.titleLabel.textAlignment = UITextAlignmentCenter;
        label.titleLabel.font = [UIFont systemFontOfSize:36];
        [label sizeToFit];
        CGRect f = label.frame;
        f.size.width = 40;
        f.size.height = 40;
        label.frame = f;
        
        if (label.frame.size.width+label.frame.origin.x > view.frame.size.width) {
            j += (label.frame.size.height*1.5);
            i = 10;
            
            f.origin.x = i;
            f.origin.y = j;
            label.frame = f;
        }
        
        [view addSubview:label];
        label.origCenter = label.center;
        label.initialPos = label.frame;
        [arrayToReturn addObject:label];
        label.box = label.frame;
        
        
        i += (label.frame.size.width);
    }
    return arrayToReturn;
}
- (NSMutableArray*)parseCharAtString:(NSString*)str toView:(UIView *)view
{
     NSMutableArray *arrayToReturn = [NSMutableArray new];
    float pos_x = 10;
    float j = 20;

    for (int i = 0; i<str.length; i++)
    {
        unichar c = [str characterAtIndex:i];
    NSString *letter =[NSString stringWithCharacters:&c length:1];
        
        UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(pos_x, j, 0, 0)];
        [label setTitle:letter forState:UIControlStateNormal];
        [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        label.backgroundColor = [UIColor clearColor];
        label.titleLabel.textAlignment = UITextAlignmentCenter;
        label.titleLabel.font = [UIFont systemFontOfSize:18];
        [label sizeToFit];
        CGRect f = label.frame;
        f.size.width += 5;
        f.size.height = 40;
        label.frame = f;
        
        if (label.frame.size.width+label.frame.origin.x > view.frame.size.width) {
            j += (label.frame.size.height*1.2);
            pos_x = 10;
            
            f.origin.x = pos_x;
            f.origin.y = j;
            label.frame = f;
        }
        
        [view addSubview:label];
        label.origCenter = label.center;
        label.initialPos = label.frame;
        [arrayToReturn addObject:label];
        label.box = label.frame;
        
        
        pos_x += (label.frame.size.width);
    }
     return arrayToReturn;
}

- (NSMutableArray*)parseString:(NSString*)str toView:(UIView *)view
{
    NSArray* sentance = [str componentsSeparatedByString: @" "];
   
    
    NSMutableArray *arrayToReturn = [NSMutableArray new];
    float i = 10;
    float j = 20;
    for (NSString *word in sentance)
    {
        UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(i, j, 0, 0)];
        //label.titleLabel.text = word;
        [label setTitle:word forState:UIControlStateNormal];
        //label.titleLabel.textColor = [UIColor blackColor];
        [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        label.backgroundColor = [UIColor clearColor];
        label.titleLabel.textAlignment = UITextAlignmentCenter;
        label.titleLabel.font = [UIFont systemFontOfSize:18];
        [label sizeToFit];
        CGRect f = label.frame;
        f.size.width += 10;
        f.size.height = 40;
        label.frame = f;
        
        if (label.frame.size.width+label.frame.origin.x > view.frame.size.width) {
            j += (label.frame.size.height*1.2);
            i = 10;
            
            f.origin.x = i;
            f.origin.y = j;
            label.frame = f;
        }
        
        [view addSubview:label];
        label.origCenter = label.center;
        label.initialPos = label.frame;
        [arrayToReturn addObject:label];
        label.box = label.frame;
        
        
        i += (label.frame.size.width);
    }
    return arrayToReturn;
}
- (IBAction)btnDismss
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
@end