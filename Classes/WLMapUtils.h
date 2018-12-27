//
//  WLMapUtils.h
//  MapRequest
//
//  Created by 王陆 on 2018/12/3.
//  Copyright © 2018 南京圈圈网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
struct WLCoefficient {
    CGFloat a;
    CGFloat b;
};
typedef struct WLCoefficient WLCoefficient;
CG_INLINE WLCoefficient
WLCoefficientMake(CGFloat a, CGFloat b) {
    WLCoefficient cofficient;
    cofficient.a = a;
    cofficient.b = b;
    return cofficient;
};
@interface WLMapUtils : NSObject
+ (WLCoefficient)getLineByPoint1:(CGPoint)point1 point2:(CGPoint)point2;
+ (CGFloat)getAngleWithPoint1:(CGPoint)point1 point:(CGPoint)point2;
// 获取直线方程
+ (WLCoefficient)getLineCoefficient:(CGPoint)lineDot1 point2:(CGPoint)lineDot2;
/*
 点到直线的距离
 */
+ (CGFloat)getNearestDistanceLineDot1:(CGPoint)lineDot1 lineDot2:(CGPoint)lineDot2
                                  dot:(CGPoint)dot;
// 获取垂足
+ (CGPoint)getPerpendicularPointOfIntersectionByLineDot:(CGPoint)lineDot1
                                               lineDot2:(CGPoint)lineDot2 dot:(CGPoint)dot;
@end
