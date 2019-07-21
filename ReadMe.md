# RedBook Header Scroll Demo
# 仿小红书顶部详情图片高度可变空间


#### Swift4 Available

Swift练手项目..项目可能存在很多不足..效果如下图所示..

参考大佬思路实现-> :[大佬Demo传送门](https://github.com/wuzhantu/redbook)

小红书App中效果:

![](http://sylarimage.oss-cn-shenzhen.aliyuncs.com/2019-07-21-redbookAppGif.gif)


Demo效果: 

![](http://sylarimage.oss-cn-shenzhen.aliyuncs.com/2019-07-21-redbookHeaderDemo.gif)


控件添加了可用于下拉刷新情景的重新加载,定位到刷新前位置功能


## Usage

Step1. 生成图片Model


```swift
//image为图片数据
let imageModel = pictureScrollImageModel.init(generateImageModel: image)
```

Step2. 将图片存进数组赋值给控件

初始化控件:

```swift
//需要设置控件初始宽度
//设置控件宽度为 屏幕宽度
viewPager = PictureScrollView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
//设置控件代理
//控件代理用于,滑动时候,根据回调控件高度，在外面调整控件Frame
viewPager.delegate = self
```

设置数据源

```swift
//将存有Model数组赋值给控件
viewPager.imageSource = imageSourceArrary
```


`赋值完之后需要Reload数据`

```swift
//赋值完之后需要Reload,重新布局
//同理,如果存在下拉刷新更新数据源,也需要手动调用Reload
viewPager.reload()
```


Step3 . 设置代理

```swift
//根据控件计算的高度,时刻调整控件在父类的Frame
func pictureScrollViewDidScroll(_ pictureScrollView: PictureScrollView, contentOffset: CGPoint, pictureScrollViewSuitHeight: CGFloat) {
        viewPager.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewPager.pictureScrollViewHeight)
    }
```

)


控件添加了可用于下拉刷新情景的重新加载,定位到刷新前位置功能


## Usage

Step1. 生成图片Model


```swift
//image为图片数据
let imageModel = pictureScrollImageModel.init(generateImageModel: image)
```

Step2. 将图片存进数组赋值给控件

初始化控件:

```swift
//需要设置控件初始宽度
//设置控件宽度为 屏幕宽度
viewPager = PictureScrollView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0))
//设置控件代理
//控件代理用于,滑动时候,根据回调控件高度，在外面调整控件Frame
viewPager.delegate = self
```

设置数据源

```swift
//将存有Model数组赋值给控件
viewPager.imageSource = imageSourceArrary
```


`赋值完之后需要Reload数据`

```swift
//赋值完之后需要Reload,重新布局
//同理,如果存在下拉刷新更新数据源,也需要手动调用Reload
viewPager.reload()
```


Step3 . 设置代理

```swift
//根据控件计算的高度,时刻调整控件在父类的Frame
func pictureScrollViewDidScroll(_ pictureScrollView: PictureScrollView, contentOffset: CGPoint, pictureScrollViewSuitHeight: CGFloat) {
        viewPager.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: viewPager.pictureScrollViewHeight)
    }
```

