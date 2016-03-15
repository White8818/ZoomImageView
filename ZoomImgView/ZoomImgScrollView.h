//
//  ZoomImgScrollView.h
//  Pugongying
//
//  Created by white on 15/11/13.
//  Copyright (c) 2015年 white8818. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZoomImgScrollView;
@protocol ZoomImgScrollViewDelegate <NSObject>

- (void)tapZoomImgScrollViewReturenDefaultFrame:(ZoomImgScrollView *)zoomImgeScrollView;

@end


@interface ZoomImgScrollView : UIScrollView

@property (nonatomic, assign) id<ZoomImgScrollViewDelegate> ZISDdelegate;
/**
 *  根据图片计算出放大后的frame
 *
 *  @param image     缩略图
 *  @param imgString 缩放图片的URL
 *  @param title     详情标题
 */
- (void)calculateAnimateFrameWithImage:(UIImage *)image
                             imgUrlStr:(NSString *)imgString
                          detailTitle:(NSString *)title;

/**
*  初始化图片原位置, 后面会设置放大后的frame, 做一个动画效果
*
*  @param rect 初始frame
*/
- (void)setZoomImgViewWithFrame:(CGRect)frame;

/**
 *  恢复到原来的frame
 */
- (void)returenDefaultFrame;

@end
