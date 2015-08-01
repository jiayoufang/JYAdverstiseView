//
//  JYAdvertiseView.h
//  JYAdvertisementDisplay
//
//  Created by fangjiayou on 15/7/30.
//  Copyright (c) 2015年 方. All rights reserved.
//
/*!
 *  @author FJY
 *
 *  @brief  动态展示广告位
 */
#import <UIKit/UIKit.h>

@class JYAdvertiseView;

@protocol JYAdvertiseViewDelegate <NSObject>

- (void)advertiseView:(JYAdvertiseView *)advertiseView didSelectedIndex:(NSInteger)index;

@end

@interface JYAdvertiseView : UIView

@property(nonatomic,assign) id<JYAdvertiseViewDelegate>delegate;

/*!
 *  @author FJY
 *
 *  @brief  创建广告位展示
 *
 *  @param frame frame
 *
 *  @return 实例
 */
- (id)initWithFrame:(CGRect)frame;

@end
