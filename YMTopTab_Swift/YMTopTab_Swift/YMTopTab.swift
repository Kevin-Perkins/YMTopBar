//
//  YMTopTab.swift
//  YMTopTab_Swift
//
//  Created by barryclass on 10/25/14.
//  Copyright (c) 2014 barryclass. All rights reserved.
//

import UIKit

class YMTopTab: UIView {
    
    var origin      :  CGPoint
    var tabsArray   :  [String]
    var titleFont   :  UIFont
    var parentWidth :  CGFloat = 0
    var height      :  CGFloat = 0
    
    init(origin:CGPoint, tabsArray:[String], titleFont:UIFont = UIFont.systemFontOfSize(18.0)) {
        self.origin = origin;
        self.tabsArray = tabsArray;
        self.titleFont = titleFont;
        super.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.redColor()
        var view = self.superview!
        self.parentWidth = view.frame.size.width
        var tempString : String = "topBar"
        var size : CGSize = tempString.sizeWithAttributes([NSFontAttributeName : self.titleFont])
        if self.height == 0 {
            self.height = ceil(size.height) + 15
        }
        self.frame = CGRectMake(self.origin.x, self.origin.y, self.parentWidth,self.height)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
