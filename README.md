YMTopTab
========

可滑动，点击选择的分类标签效果控件，可以自定义选中、非选中字体颜色，背景颜色，滑动条颜色。

当设置了height时控件的高度由height决定，如果没有控件高度由按钮字体高度决定。

当设置了titleWidth时每一个tab的宽度由titleWidth决定,如果没有,由字体的宽度决定

标签按钮数量可以自定义，可以关联Scrollview，当关联ScrollView 时，如果想实现联动效果，需要在ScrollView 代理的

scrollViewDidScroll 中调用 adapterScrollViewScroll

scrollViewDidEndDecelerating 中调用 adapterScrollViewDidEndDecelerating。


![效果图](http://raw.github.com/Barry-Wang/YMTopBar/master/xiaoguo.png)

Usage
========

1. 把 YMTopTab.h 跟 YMTopTab.m  加入项目文件
2. 通过位置跟分类数组初始化
3. 

        NSArray *titles = @[@"火箭",@"湖人",@"热火",@"马刺",@"灰熊",@"快船",@"小牛"];

        YMTopTab *topTbas = [[YMTopTab alloc] initWithOrigin:CGPointMake(0, 20) tabsArray:titles titleFont:nil];
    
        [self.view addSubview:topTbas];
    
        topTbas.slideColor = [UIColor redColor];

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 220, 320, 200)];
        
        [self.view addSubview:scrollView];
        
        scrollView.contentSize = CGSizeMake(3 * 320, 200);
        
        scrollView.pagingEnabled = YES;
        
        scrollView.delegate = self;

       NSArray *colorArray = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]];

      for (int i = 0; i < 3; i++) {
      
      UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, 200)];
      
      view.backgroundColor = colorArray[i % 3];
      
      [scrollView addSubview:view];
 
      topTbas2.adpterScrollView =scrollView;


        - (void)scrollViewDidScroll:(UIScrollView *)scrollView
        
       {
       
         [self.toptab adapterScrollViewScroll:scrollView];
         

      }
      

       - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
       
     {
     
        [self.toptab adapterScrollViewDidEndDecelerating:scrollView];
        
    }

       
    
    
  控件的Width与屏幕Width相同，高度由设置的字体决定。
  
  可设置的属性
  
  // 默认选择第几个tab,默认选择第一个

     @property (nonatomic, assign) NSInteger selected;

//标题的字体，这个字体会决定整个topTab的高度

    @property (nonatomic, strong) UIFont   *font;

// 滑动条的颜色

    @property (nonatomic, strong) UIColor   *slideColor;

// 适配的可滚动的scrollView,设置后scrollView的滚动与topTab 关联，他们之间会相互作用

    @property (nonatomic, strong) UIScrollView *adpterScrollView;

//非选中状态颜色

    @property (nonatomic, strong) UIColor *unselectColor;
    
// 选中状态颜色

     @property (nonatomic, strong) UIColor  *selectColor;
//控件高度

      @property (nonatomic, assign) CGFloat   height;
      
//每一个title的长度

    @property (nonatomic, assign) CGFloat   titleWidth;


License
========
MIT License. See LICENSE for details.



