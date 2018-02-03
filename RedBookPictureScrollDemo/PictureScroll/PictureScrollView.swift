//
//  PictureScrollView.swift
//  RedBookPictureScrollDemo
//
//  Created by Sylar on 2017/12/19.
//  Copyright © 2017年 Sylar. All rights reserved.
//

import UIKit


protocol pictureScrollViewDeleagate : NSObjectProtocol {
    
    //此方法每次滑动回调,代理可以根据回调高度调整此控件高度
    func pictureScrollViewDidScroll(_ pictureScrollView : PictureScrollView , contentOffset : CGPoint  , pictureScrollViewSuitHeight : CGFloat)
    
    func pictureScrollViewDidScrollToIndex (_ pictureScrollView : PictureScrollView , atIndex : Int)
    
}

extension pictureScrollViewDeleagate{
    //获得滑动后index
    func pictureScrollViewDidScrollToIndex (_ pictureScrollView : PictureScrollView , atIndex : Int){
        
    }
}


class PictureScrollView: UIView  {
    
    let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width

    var bgScrollView : UIScrollView!
    
    //ScrollView DataSource
    private var _imageSource:Array<pictureScrollImageModel> = Array()
    
    public var imageSource:Array<pictureScrollImageModel>{
        set (newvalue){
            _imageSource.removeAll()
            _imageSource = newvalue
        }
        get{
            return _imageSource
        }
       
    }
    
    //ScrollView Height
    public var pictureScrollViewHeight : CGFloat = 0.0
    
    //Delegate
    weak var delegate : pictureScrollViewDeleagate?
    
    //LastPosition
    private var lastPosition : CGFloat = 0.0
    
    //CurrentPage
    private(set) var currentPage : Int = 0
    
    //FinalEndDraggingPage
    private(set) var finalEndDraggingPage : Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    //Initial UI
    private func configUI() {
        self.bgScrollView = UIScrollView.init()
        self.bgScrollView.delegate = self
        self.bgScrollView.isPagingEnabled = true
        self.bgScrollView.bounces = false
        self.bgScrollView.showsVerticalScrollIndicator = false
        self.bgScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.bgScrollView)
        
    }
    
    
    public func reload(){
        guard _imageSource.count > 0 else {
            return
        }
        
        for subview in self.bgScrollView.subviews{
            subview.removeFromSuperview()
        }

        //generate UI
        for i in 0..<self.imageSource.count{
            let model : pictureScrollImageModel = self.imageSource[i]
            guard let image = model.image else{
                return;
            }
            let imageViewHeight = self.heightForModel(model)
            let imageView : UIImageView = UIImageView.init(frame:CGRect.init(x: (ScreenWidth * CGFloat(i)), y: 0, width: ScreenWidth, height: imageViewHeight))
            self.bgScrollView.addSubview(imageView)
            imageView.image = image
            imageView.tag = 9000 + i
        }
        //Set ScrollView ContentSize
        //Get First ImageView
        let firstImageView:UIImageView = self.bgScrollView.viewWithTag(9000) as! UIImageView
        pictureScrollViewHeight = firstImageView.frame.size.height
        bgScrollView.contentSize = CGSize.init(width: CGFloat(self.imageSource.count) * ScreenWidth, height: firstImageView.frame.size.height)
        bgScrollView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: pictureScrollViewHeight)
        
        
        //如果用于下拉刷新时候,Scroll到刷新前位置
        if finalEndDraggingPage != 0 {
            lastPosition = 0.0
            self.turenToPage(finalEndDraggingPage)
        }
    }
    
    private func heightForModel(_ imageModel:pictureScrollImageModel)  -> CGFloat{
        let imageWidth = imageModel.imageWidth
        let imageViewWidth = ScreenWidth
        let scale = imageWidth / imageViewWidth
        return imageModel.imageHeight / scale
    }
    
    
    //跳到指定页面
    public func turenToPage(_ index:NSInteger?){
        guard let index = index  else {
            return
        }
        
        guard index < self.imageSource.count else{
            return
        }
        
        lastPosition = -0.01
        /*
         Discussion:
             跳转到指定index
             作用情景: 比如下拉刷新重新请求,获得数据重新布局,停留回刷新前界面
             需要将ScrollView重新从0开始滑动到原来地方,计算回偏移
         */
        if index == 0 {
            if self.imageSource.count == 2{
                for i in 0..<self.imageSource.count{
                    bgScrollView.setContentOffset(CGPoint.init(x: ScreenWidth * CGFloat(i), y: 0), animated: false)
                }
            }else{
                for i in 0...2 {
                    bgScrollView.setContentOffset(CGPoint.init(x: ScreenWidth * CGFloat(i), y: 0), animated: false)
                }
            }
        }
        
        for i in 0...index {
            bgScrollView.setContentOffset(CGPoint.init(x: ScreenWidth * CGFloat(i), y: 0), animated: false)
        }
        
        
    }
   
    
}

extension PictureScrollView:UIScrollViewDelegate{

    //ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let currentPosition = offsetX
        var page : Int = Int ( offsetX / ScreenWidth )
        var isLeft = false
        if currentPosition >  lastPosition{
            isLeft = true
            if page > 0 && offsetX - CGFloat(page) * ScreenWidth < 0.01{
                page = page - 1
            }
        }
        //Get ImageView Height
        let firstImageView : UIImageView = self.bgScrollView.viewWithTag(9000 + page) as! UIImageView
        let secondImageView : UIImageView = self.bgScrollView.viewWithTag(9000 + page + 1) as! UIImageView
        
        //Get Maxium Image Height
        let firstImageModel = imageSource[page]
        let sencondImageModel = imageSource[page+1]
        let firstImageHeight : CGFloat = self.heightForModel(firstImageModel)
        let sencondImageHeight : CGFloat = self.heightForModel(sencondImageModel)
        
        //Y Offset
        //左滑的话,ScrollView ContentSize 向右移动增大 isLeft = Yes，是后一张实际比例高度减去当前看到图片ImageView的高度,就是Y偏移量
        //右滑的话,ScrollView ContentSize 向左移动增大 isLeft = NO,  page = 看到图的上一张index，
        //右滑时候,左移上一张图片已经缩小,所以Y偏移量为 计算高度 - 实际缩小高度
        let distanceY : CGFloat =  isLeft ? sencondImageHeight - firstImageView.height : firstImageHeight - firstImageView.height
        
        let leftDistanceX = CGFloat(page + 1) * ScreenWidth - lastPosition
        let rightDistanceX = ScreenWidth - leftDistanceX
        let distanceX = isLeft ? leftDistanceX : rightDistanceX
        var movingDistance : CGFloat = 0.0
        if distanceX != 0 && fabs(lastPosition - currentPosition) > 0 {
            movingDistance = distanceY / distanceX * CGFloat(fabs(lastPosition - currentPosition))
        }
        
        //缩放比例
        let firstScale = ScreenWidth / firstImageHeight;
        let secondScale = ScreenWidth / sencondImageHeight;
        
        
        ////这样算法意思是，因为高度根据实际图片比例变化，宽度与x也要随之变化而改变大小比例
        firstImageView.frame = CGRect.init(x: ScreenWidth * CGFloat(page + 1) - (firstImageView.height + movingDistance ) * firstScale , y: 0, width: (firstImageView.height + movingDistance) * firstScale, height: firstImageView.height + movingDistance)
        secondImageView.frame = CGRect.init(x: ScreenWidth * CGFloat(page + 1), y: 0, width: firstImageView.height * secondScale, height: firstImageView.height)
        
        self.bgScrollView.contentSize = CGSize.init(width: bgScrollView.contentSize.width, height: firstImageView.height)
        self.bgScrollView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: firstImageView.height)
        
        let newPage : Int = Int ( offsetX / ScreenWidth)
        if (offsetX - CGFloat(newPage) * ScreenWidth) < 0.01 {
            currentPage = newPage + 1
        }
        lastPosition = currentPosition
        
        pictureScrollViewHeight = firstImageView.height
        
        //需要外部遵循代理，实时改变Self的Frame大小
        self.delegate?.pictureScrollViewDidScroll(self, contentOffset: scrollView.contentOffset, pictureScrollViewSuitHeight: pictureScrollViewHeight)
        
        self.delegate?.pictureScrollViewDidScrollToIndex(self, atIndex: Int(offsetX / self.bounds.size.width))
    }
    
    //拖动，手指离开屏幕
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //获取松手坐标
        let targetPoint : CGPoint = targetContentOffset.pointee
        finalEndDraggingPage = Int((targetPoint.x) / ScreenWidth)
        
        
    }
}


extension UIView {
    // x
    var x : CGFloat {
        
        get {
            
            return frame.origin.x
        }
        
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newVal
            frame                 = tmpFrame
        }
    }
    
    // y
    var y : CGFloat {
        
        get {
            
            return frame.origin.y
        }
        
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newVal
            frame                 = tmpFrame
        }
    }
    
    // height
    var height : CGFloat {
        
        get {
            
            return frame.size.height
        }
        
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }
    
    // width
    var width : CGFloat {
        
        get {
            
            return frame.size.width
        }
        
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }
}


class pictureScrollImageModel: NSObject {
    private(set) var imageHeight : CGFloat = 0.0
    private(set) var imageWidth  : CGFloat = 0.0
    private(set) var image       : UIImage!
    
    convenience init(generateImageModel imageSource:UIImage!) {
        self.init()
        imageHeight = imageSource.size.height
        imageWidth = imageSource.size.width
        image      = imageSource
    }
}
