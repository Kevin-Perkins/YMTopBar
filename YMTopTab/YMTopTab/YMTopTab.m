//
//  YMTopTab.m
//
//  Created by barryclass on 10/17/14.
//

#import "YMTopTab.h"

@interface YMTopTab()
@property (nonatomic, strong) UIScrollView *buttonContainer;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIView  *maskView;                          // 滑动条
@property (nonatomic, strong) NSMutableArray *buttonsArray;              // 存放字典有数组
@property (nonatomic, assign) CGFloat  parentWidth;                     // 屏幕宽度
@property (nonatomic, assign) CGPoint   origin;


@property (nonatomic, assign) CGFloat   titleDistance;                // 两个标题之间的距离
@property (nonatomic, assign) BOOL      needCaculateDistance;        // 是否需要重新计算两个title间的距离
@property (nonatomic, assign) CGFloat   preContentOffSetX;          // 跟据当前的跟pre 判断向哪个方向滚动
@property (nonatomic, assign) CGFloat   dirction;                  // 1 正向  ， -1 反向
@property (nonatomic, assign) CGRect    tempRect;                 // 滚动前maskView 的frame
@property (nonatomic, assign) BOOL      isTap;                   // 是否是点击当前的页面
@property (nonatomic, assign) BOOL      hasSetTitleWidth;
@property (nonatomic, assign) CGFloat    grap;

@end

@implementation YMTopTab

- (id)initWithOrigin:(CGPoint)origin tabsArray:(NSArray *)array titleFont:(UIFont*) font
{

    self = [super init];
    if (self) {
        // Initialization code
        self.titleArray = array;
        self.origin = origin;
        self.needCaculateDistance = YES;
        self.titleDistance = 0.0f;
        self.preContentOffSetX = 0.0f;
        self.isTap = NO;
        self.selectColor   =  [UIColor colorWithRed:234.0f / 255 green:85.0f / 255 blue:41.0f/ 255 alpha:1];
        self.unselectColor =  [UIColor colorWithRed:190.0f / 255 green:190.0f / 255 blue:190.0f/ 255 alpha:1];
        self.slideColor = [UIColor colorWithRed:234.0f / 255 green:97.0f / 255 blue:32.0f/ 255 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:251.0f / 255 green:251.0f / 255 blue:251.0f/ 255 alpha:1];
        self.hasSetTitleWidth = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.autoresizesSubviews = YES;
        self.selected = 0;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = self.slideColor;
        self.maskView = view;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.buttonContainer = scrollView;
        
        if (font == nil) {
            self.font = [UIFont systemFontOfSize:18];
        } else {
            self.font = font;
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    
    
    self.parentWidth = self.superview.frame.size.width;
    CGSize strSize = [@"topBar" sizeWithAttributes:@{ NSFontAttributeName : self.font }];
    if (self.height == 0) {
        self.height = ceil(strSize.height) + 15;
    }
    CGRect   frame = CGRectMake(self.origin.x, self.origin.y, self.parentWidth, self.height);
    self.frame = frame;
    self.buttonContainer.backgroundColor = [UIColor clearColor];
    [self refreshTitle:self.titleArray];
}


- (void)refreshTitle:(NSArray *)titileArray
{
    CGFloat  everyTitleWidth = 0.0f;
    
    if (self.hasSetTitleWidth == YES)
    {
        everyTitleWidth = self.titleWidth;
        self.grap = (self.parentWidth - self.titleArray.count * everyTitleWidth) / (self.titleArray.count + 1);
    } else {
        self.grap = 10;
    }
    
    for (UIView *view in self.buttonContainer.subviews) {
        [view removeFromSuperview];
    }
    self.buttonsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < self.titleArray.count; i++ ) {
        
        NSString *title = titileArray[i];
        
        UIButton *lastButton = [self.buttonsArray lastObject];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(lastButton.frame.origin.x + self.grap + lastButton.frame.size.width,6, 0,0);
        button.tag = i;
        [button setTitle:title  forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeItem:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = self.font;
        [button setTitleColor:self.unselectColor forState:UIControlStateNormal];
        
        CGRect buttonSize = button.frame;
        CGSize strSize = [title sizeWithAttributes:@{ NSFontAttributeName : self.font}];
        
        buttonSize.size.height  = ceil(strSize.height);
        buttonSize.origin.y     = (self.frame.size.height - buttonSize.size.height)  / 2;
        if(self.hasSetTitleWidth == NO){
            everyTitleWidth = strSize.width;
        }
        buttonSize.size.width   = everyTitleWidth;
        button.frame = buttonSize;
        [self.buttonsArray addObject:button];
        [self.buttonContainer addSubview:button];
    }
    
    UIButton *lastButton = self.buttonsArray.lastObject;
    
    // 如果不满足满屏时
    if (lastButton.frame.origin.x + lastButton.frame.size.width + 10  < self.parentWidth) {
        
        if (self.hasSetTitleWidth) {
            everyTitleWidth = self.titleWidth;
            self.grap = (self.parentWidth - self.buttonsArray.count * everyTitleWidth) / (self.buttonsArray.count + 1);
        } else {
            everyTitleWidth = 0;
            self.grap = 10;
        }
        [self.buttonsArray removeAllObjects];
        
        for (UIView *view in self.buttonContainer.subviews) {
            [view removeFromSuperview];
        }
        
        for (int i = 0; i < self.titleArray.count; i++ ) {
            
            NSString *title = titileArray[i];
            lastButton = [self.buttonsArray lastObject];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(lastButton.frame.origin.x + self.grap + lastButton.frame.size.width,8, self.titleWidth,0);
            button.tag = i;
            [button setTitle:title  forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeItem:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = self.font;
            [button setTitleColor:self.unselectColor forState:UIControlStateNormal];
            
            CGSize strSize = [title sizeWithAttributes:@{ NSFontAttributeName : self.font}];
            CGRect buttonSize = button.frame;
            buttonSize.size.height  = ceil(strSize.height);
            buttonSize.origin.y     = (self.frame.size.height - buttonSize.size.height)  / 2;
            if (self.hasSetTitleWidth == NO) {
                
                NSLog(@"======%f",self.parentWidth - (titileArray.count + 1) * 10.0f);
                
                everyTitleWidth =  (self.parentWidth - (titileArray.count + 1) * 10.0f) / titileArray.count;
            }
            buttonSize.size.width = everyTitleWidth;
            button.frame = buttonSize;
            [self.buttonsArray addObject:button];
            [self.buttonContainer addSubview:button];
        }
    }
    //
    lastButton = [self.buttonsArray lastObject];
    self.buttonContainer.contentSize = CGSizeMake(lastButton.frame.origin.x + lastButton.frame.size.width, 0);
    
    
    UIButton *button =  self.buttonsArray[self.selected];
    self.maskView.frame = CGRectMake(button.frame.origin.x, self.buttonContainer.frame.size.height - 3,button.frame.size.width,3);
    [self.buttonContainer addSubview:self.maskView];
}

- (void)setAdpterScrollView:(UIScrollView *)adpterScrollView
{
    if (_adpterScrollView == adpterScrollView) {
        return;
    } else {
        
        if (adpterScrollView != nil) {
            _adpterScrollView = adpterScrollView;
        }
        
    }
}

- (void)changeItem:(UIButton *) button
{
    self.selected = button.tag;
    self.isTap = YES;
    
    if (self.adpterScrollView != nil) {
        [self.adpterScrollView setContentOffset:CGPointMake(self.selected * self.adpterScrollView.frame.size.width, 0) animated:YES];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.adpterScrollView != nil) {
            [self.adpterScrollView setContentOffset:CGPointMake(self.selected * self.adpterScrollView.frame.size.width, 0) animated:NO];
        }
    } completion:^(BOOL finished) {
        self.isTap = NO;
    }];
    CGRect rect = self.maskView.frame;
    rect.origin.x = button.frame.origin.x;
    rect.size.width = button.frame.size.width;
    [UIView animateWithDuration:0.25f animations:^{
        self.maskView.frame =rect;
    }];
    
    self.preContentOffSetX = self.adpterScrollView.contentOffset.x;
    self.needCaculateDistance = YES;
    self.titleDistance = 0;
}


- (void)setSelected:(NSInteger)selected
{
    __block float fx = 0;
    UIButton *button = self.buttonsArray[selected];
    int dirction = selected > _selected ? 1 : -1;
    
    // button 的中心x减去contentOffsetX就是其在scrollView中的坐标，
    // - self.parentWidth / 2 表示其与中心点的距离。
    
    fx  = button.center.x - self.buttonContainer.contentOffset.x - self.parentWidth / 2;
    _selected = selected;
    [UIView animateWithDuration:0.15 animations:^{
        if (dirction == 1 && button.center.x - self.buttonContainer.contentOffset.x > self.parentWidth / 2 ) {
            fx = MIN(self.buttonContainer.contentOffset.x + fx, self.buttonContainer.contentSize.width - self.parentWidth);
            if (fx < 0) {
                fx = 0;
            }
            [self.buttonContainer setContentOffset:CGPointMake(fx,0)];
            
            
        } else if (dirction == -1 && button.center.x - self.buttonContainer.contentOffset.x < self.parentWidth / 2){
            fx = MAX(self.buttonContainer.contentOffset.x + fx, 0);
            [self.buttonContainer setContentOffset:CGPointMake(fx,0)];
        }
        
    }];
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        if (i == selected) {
            [button setTitleColor:self.selectColor forState:UIControlStateNormal];
            if (self.maskView.frame.origin.x != button.frame.origin.x) {
                CGRect rect = self.maskView.frame;
                rect.origin.x = button.frame.origin.x;
                rect.size.width = button.frame.size.width;
                self.maskView.frame =rect;
            }
        } else {
            [button setTitleColor:self.unselectColor forState:UIControlStateNormal];
        }
    }
    
}
- (void)adapterScrollViewScroll:(UIScrollView *)scrollView
{
    
    if ( self.isTap == NO && scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < scrollView.contentSize.width - scrollView.frame.size.width) {
        if (self.needCaculateDistance == YES ) {
            
            
            CGFloat  dis = scrollView.contentOffset.x - self.preContentOffSetX;
            
            if (dis > 0 && self.selected < self.buttonsArray.count - 1) {
                UIButton *nextButton = self.buttonsArray[self.selected + 1];
                UIButton *currentButton = self.buttonsArray[self.selected];
                self.titleDistance =  nextButton.frame.origin.x - currentButton.frame.origin.x;
                self.dirction = 1;
            } else  if (dis < 0 && self.selected > 0){
                UIButton *preButton = self.buttonsArray[self.selected - 1];
                UIButton *currentButton = self.buttonsArray[self.selected];
                self.titleDistance = currentButton.frame.origin.x - preButton.frame.origin.x;
                self.dirction = -1;
            }
            
            self.needCaculateDistance = NO;
            self.tempRect = self.maskView.frame;
        }
        CGFloat percent =  fabs(scrollView.contentOffset.x - self.preContentOffSetX) / scrollView.frame.size.width;
        CGRect rect = self.tempRect;
        rect.origin.x += self.titleDistance * percent * self.dirction;
        
        UIButton *button = [self.buttonsArray lastObject];
        if (rect.origin.x > button.frame.origin.x) {
            rect.origin.x = button.frame.origin.x;
        }
        if (rect.origin.x < 0) {
            rect.origin.x = 0;
        }
        self.maskView.frame = rect;
    }
}
- (void)adapterScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int kSelected =  ceil(scrollView.contentOffset.x / scrollView.frame.size.width);
    kSelected = kSelected > (int)self.titleArray.count - 1 ? (int)self.titleArray.count - 1 : kSelected;
    kSelected = kSelected < 0 ? 0 :kSelected;
    BOOL isChanged = (self.selected != kSelected);
    self.selected = kSelected;
    if (isChanged && [self.delegate respondsToSelector:@selector(topTab:changeSwipeItem:)]) {
        [self.delegate topTab:self changeSwipeItem:kSelected];
    }
    scrollView.contentOffset = CGPointMake(kSelected *scrollView.frame.size.width, 0);
    
    UIButton *button = self.buttonsArray[self.selected];
    CGRect rect = self.maskView.frame;
    rect.size.width = button.frame.size.width;
    self.maskView.frame = rect;
    
    self.preContentOffSetX = scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width ? scrollView.contentSize.width - scrollView.frame.size.width : scrollView.contentOffset.x;
    self.preContentOffSetX = self.preContentOffSetX  < 0 ? 0 : self.preContentOffSetX;
    self.needCaculateDistance = YES;
    self.titleDistance = 0;
}


- (void)setSlideColor:(UIColor *)slideColor
{
    if (_slideColor != slideColor) {
        _slideColor = slideColor;
        self.maskView. backgroundColor =  slideColor;
    }
}

- (void)setTitleWidth:(CGFloat)titleWidth
{
    if (_titleWidth != titleWidth) {
        _titleWidth = titleWidth;
        if (_titleWidth != 0) {
            self.hasSetTitleWidth = YES;
        } else {
            self.hasSetTitleWidth = NO;
        }
    }
}
@end

