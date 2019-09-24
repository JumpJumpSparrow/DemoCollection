
## 集合了六种 给 控件添加圆角的方式

在iOS开发中，我们经常会遇到设置圆角的问题, 以下是几种设置圆角的方法:

### 1.  通过设置layer的属性

代码:
```language
UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"willwang"]];

//只需要设置layer层的两个属性
//设置圆角
imageView.layer.cornerRadius =50

//将多余的部分切掉
imageView.layer.masksToBounds = YES;
[self.view addSubview:imageView];
```

这个实现方法里 maskToBounds 会触发离屏渲染(offscreen rendering)，GPU在当前屏幕缓冲区外新开辟一个渲染缓冲区进行工作，也就是离屏渲染，这会给我们带来额外的性能损耗，如果这样的圆角操作达到一定数量，会触发缓冲区的频繁合并和上下文的的频繁切换，性能的代价会宏观地表现在用户体验上<掉帧>不建议使用.

### 2. 使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角

```language
UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];

imageView.image = [UIImage imageNamed:@"willwang"];

//开始对imageView进行画图
UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);

//使用贝塞尔曲线画出一个圆形图
[[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width] addClip];

[imageView drawRect:imageView.bounds];

imageView.image = UIGraphicsGetImageFromCurrentImageContext();

//结束画图
UIGraphicsEndImageContext();

[self.view addSubview:imageView];
```

UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale) 各参数含义:
size —— 新创建的位图上下文的大小
opaque —— 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
scale —— 缩放因子 iPhone 4是2.0，其他是1.0。虽然这里可以用[UIScreen mainScreen].scale来获取，但实际上设为0后，系统就会自动设置正确的比例.

### 3.使用Core Graphics框架画出一个圆角

```language
UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];

imageView.image = [UIImage imageNamed:@"willwang"];

//开始对imageView进行画图
UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);

// 获得图形上下文
CGContextRef ctx = UIGraphicsGetCurrentContext();

// 设置一个范围
CGRect rect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);

// 根据一个rect创建一个椭圆
CGContextAddEllipseInRect(ctx, rect);

// 裁剪
CGContextClip(ctx);

// 将原照片画到图形上下文
[imageView.image drawInRect:rect];

// 从上下文上获取剪裁后的照片
UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

// 关闭上下文
UIGraphicsEndImageContext();

imageView.image = newImage;

[self.view addSubview:imageView];
```



### 4.  使用CAShapeLayer和UIBezierPath设置圆角

```language
UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];

imageView.image = [UIImage imageNamed:@"willwang"];

UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];

CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];

//设置大小
maskLayer.frame = imageView.bounds;

//设置图形样子
maskLayer.path = maskPath.CGPath;

imageView.layer.mask = maskLayer;

[self.view addSubview:imageView];
```

第四种方法延伸 指定需要成为圆角的角
```language
+ (UIBezierPath *)bezierPathWithRoundedRect:(CGRect)rect
byRoundingCorners:(UIRectCorner)corners
cornerRadii:(CGSize)cornerRadii
corners参数指定了要成为圆角的角, 枚举类型如下:
typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
UIRectCornerTopLeft     = 1 <&lt; 0,
UIRectCornerTopRight    = 1 <&lt; 1,
UIRectCornerBottomLeft  = 1 <&lt; 2,
UIRectCornerBottomRight = 1 <&lt; 3,
UIRectCornerAllCorners  = ~0UL
};
```

```language
UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(120, 300, 100, 50)];

//设置背景颜色
myView.backgroundColor = [UIColor redColor];

//添加
[self.view addSubview:myView];

//绘制圆角 要设置的圆角 使用“|”来组合
UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:myView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];

CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

//设置大小
maskLayer.frame = myView.bounds;

//设置图形样子
maskLayer.path = maskPath.CGPath;

myView.layer.mask = maskLayer;

UILabel *label = [[UILabel alloc]init];

//添加文字
label.text = @"willwang";

//文字颜色
label.textColor = [UIColor whiteColor];

[myView addSubview: label];

//自动布局
[label mas_makeConstraints:^(MASConstraintMaker *make) {

make.center.equalTo(myView);
}];
```


### 5.在storyboard或xib中设置

### 6. 像素计算法
对于图像上的一个点(x, y)，判断其在不在圆角矩形内，在的话 alpha 是原值，不在的话 alpha 设为 0 .
在图像编码/解码中，用了 CGDataProviderRef，CGImageRef，这两个对象
具体实现 见工程  
[参考资料](https://github.com/hehe520/ClipCornert.git)