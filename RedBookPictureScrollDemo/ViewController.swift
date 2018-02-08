//
//  ViewController.swift
//  RedBookPictureScrollDemo
//
//  Created by Sylar on 2017/12/19.
//  Copyright © 2017年 Sylar. All rights reserved.
//

import UIKit

class ViewController: UIViewController , pictureScrollViewDeleagate  {

    let imageArray = ["source2.jpg" , "source1.jpg" , "source3.jpg"]
    
    var imageSourceArrary:Array<pictureScrollImageModel> = Array()
    
    var viewPager : PictureScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewPager = PictureScrollView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
        viewPager.delegate = self
        
        for imageName in imageArray {
            
                let image = UIImage.init(named: imageName)
                guard let imageSource = image else{
                    return
                }
                let imageModel = pictureScrollImageModel.init(generateImageModel: imageSource)
            
                imageSourceArrary.append(imageModel)

        }
        
        viewPager.imageSource = imageSourceArrary
        viewPager.reload()
        viewPager.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewPager.pictureScrollViewHeight)
        self.view.addSubview(viewPager)
        
        
        let btn1 = UIButton.init(frame: CGRect.init(x: 0, y: 500, width: 40, height: 40))
        btn1.backgroundColor = UIColor.red
        btn1.setTitle("1", for: UIControlState.normal)
        btn1.tag = 9000
        btn1.addTarget(self, action:#selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn1)
        
        let btn2 = UIButton.init(frame: CGRect.init(x: 60, y: 500, width: 40, height: 40))
        btn2.backgroundColor = UIColor.green
        btn2.setTitle("2", for: UIControlState.normal)
        btn2.tag = 9001
        btn2.addTarget(self, action:#selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn2)
        
        let btn3 = UIButton.init(frame: CGRect.init(x: 120, y: 500, width: 40, height: 40))
        btn3.backgroundColor = UIColor.blue
        btn3.setTitle("3", for: UIControlState.normal)
        btn3.tag = 9002
        btn3.addTarget(self, action:#selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn3)
        
    }

    func pictureScrollViewDidScroll(_ pictureScrollView: PictureScrollView, contentOffset: CGPoint, pictureScrollViewSuitHeight: CGFloat) {
        viewPager.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewPager.pictureScrollViewHeight)
    }

    //模拟重新加载数据
    @objc func btnAction(_ btn:UIButton) -> Void {
        self.imageSourceArrary.removeAll()
        
        for imageName in imageArray {
            
            let image = UIImage.init(named: imageName)
            guard let imageSource = image else{
                return
            }
            let imageModel = pictureScrollImageModel.init(generateImageModel: imageSource)
            
            imageSourceArrary.append(imageModel)
            
        }
        
        viewPager.imageSource = imageSourceArrary
        viewPager.reload()
        
        self.viewPager.turenToPage(btn.tag - 9000)
        
        print("转到了第 \(btn.tag - 9000 + 1) 页")
        
    }
    
}

