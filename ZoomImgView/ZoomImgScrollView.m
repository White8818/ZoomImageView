//
//  ZoomImgScrollView.m
//  Pugongying
//
//  Created by white on 15/11/13.
//  Copyright (c) 2015年 white8818. All rights reserved.
//

#import "ZoomImgScrollView.h"
#import "UIImageView+WebCache.h"

@interface ZoomImgScrollView ()<UIScrollViewDelegate>

/**
 *  需要展示的图片
 */
@property (nonatomic, strong) UIImageView *zoomImgView;
/**
 *  文字描述
 */
@property (nonatomic, strong) UILabel *detailLabel;
/**
 *  根据图片尺寸计算,按图片比例计算出zoomImgView的frame
 */
@property (nonatomic, assign) CGRect scaleFrame;
/**
 *  缩放前大小
 */
@property (nonatomic, assign) CGRect defaultFrame;

@end

@implementation ZoomImgScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        
        self.zoomImgView = [[UIImageView alloc] init];
        _zoomImgView.clipsToBounds = YES;
        _zoomImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_zoomImgView];
        
        self.detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_detailLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)calculateAnimateFrameWithImage:(UIImage *)image imgUrlStr:(NSString *)imgString detailTitle:(NSString *)title {
    //配置图片
    [self.zoomImgView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:image];
    //配置标题
    self.detailLabel.text = title;
    //判断首先缩放的值
    float scaleX = self.frame.size.width / image.size.width;
    float scaleY = self.frame.size.height / image.size.height;
    //倍数小的，先到边缘
    if (scaleX > scaleY) {
        //Y方向先到边缘
        float imgViewWidth = image.size.width * scaleY;
        self.maximumZoomScale = self.frame.size.width / imgViewWidth;
        self.scaleFrame = (CGRect){self.frame.size.width / 2 - imgViewWidth / 2, 0, imgViewWidth, self.frame.size.height};
    } else {
        //X先到边缘
        float imgViewHeight = image.size.height * scaleX;
        self.maximumZoomScale = self.frame.size.height / imgViewHeight;
        self.scaleFrame = (CGRect){0, self.frame.size.height / 2 - imgViewHeight / 2, self.frame.size.width, imgViewHeight};
    }
}

- (void)setZoomImgViewWithFrame:(CGRect)frame {
    self.zoomImgView.frame = frame;
    self.defaultFrame = frame;
    self.detailLabel.frame = CGRectMake(10, self.bounds.size.height, self.bounds.size.width - 20, 20);
    [UIView animateWithDuration:0.4 animations:^{
        self.zoomImgView.frame = self.scaleFrame;
        self.detailLabel.frame = CGRectMake(10, self.bounds.size.height - 50, self.bounds.size.width - 20, 20);
        self.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)returenDefaultFrame {
    [UIView animateWithDuration:0.4 animations:^{
        self.zoomScale = 1.0;
        self.zoomImgView.frame = self.defaultFrame;
        self.detailLabel.frame = CGRectMake(10, self.bounds.size.height, self.bounds.size.width - 20, 20);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)handleTapAction:(UITapGestureRecognizer *)tapSender {
    if (self.ZISDdelegate && [self.ZISDdelegate respondsToSelector:@selector(tapZoomImgScrollViewReturenDefaultFrame:)]) {
        [self.ZISDdelegate tapZoomImgScrollViewReturenDefaultFrame:self];
    }
}
#pragma mark - scroll delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomImgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = self.zoomImgView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    self.zoomImgView.center = centerPoint;
    if (scrollView.zoomScale == 1.0) {
        self.detailLabel.hidden = NO;
    } else {
        self.detailLabel.hidden = YES;
    }
}
@end
