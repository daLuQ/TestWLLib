//
//  WLMapUtils.m
//  MapRequest
//
//  Created by 王陆 on 2018/12/3.
//  Copyright © 2018 南京圈圈网络科技. All rights reserved.
//

#import "WLMapUtils.h"
@implementation WLMapUtils
+ (WLCoefficient)getLineByPoint1:(CGPoint)point1 point2:(CGPoint)point2 {
    if (point1.x == point2.x && point1.y == point2.y) {
        return WLCoefficientMake(M_PI, M_PI); // 用M_PI两个都是M_PI表示是同一点
    } else if (point1.x == point2.x) {
        return WLCoefficientMake(M_PI_2, M_PI_2); // 表示垂直于x轴的直线
    } else {
        if (point1.y == point2.y) {
            return WLCoefficientMake(M_PI_4, M_PI_4); // 表示垂直于y轴的直线
        } else {
            CGFloat a = (point1.y - point2.y) / (point1.x - point2.x);
            CGFloat b = point1.y - a * point1.x;
            return WLCoefficientMake(a, b);
        }
    }
}
// 获取连点之前的连线与正北方向之间的夹角，即与y轴之间的夹角
+ (CGFloat)getAngleWithPoint1:(CGPoint)point1 point:(CGPoint)point2 {
    CGFloat x1 = point1.x - point2.x;
    CGFloat y1 = point1.y - point2.y;

    if (y1 == 0) {
        if (x1 == 0) {
            return M_PI * 3;
        } else if (x1 > 0) {
            return M_PI_2;
        } else {
            return M_PI_2 * 3;
        }
    } else if (y1 > 0){
        if (x1 == 0) {
            return 0;
        } else if (x1 > 0) {
            return atanf(x1 / y1);
        } else {
            return (2 * M_PI + atanf(x1 / y1));
        }
    } else {
        if (x1 == 0) {
            return M_PI;
        } else {
            return M_PI + atanf(x1 / y1);
        }
    }
}
// 获取直线方程
+ (WLCoefficient)getLineCoefficient:(CGPoint)lineDot1 point2:(CGPoint)lineDot2 {
    // 获取直线方程
    /*
     struct WLCoefficient {
     CGFloat a;
     CGFloat b;
     };
     a 为斜率, b为常数
     aX + b = y
     */
    WLCoefficient line = [WLMapUtils getLineByPoint1:lineDot1 point2:lineDot2];
    return line;
}
/*
 点到直线的距离
 */
+ (CGFloat)getNearestDistanceLineDot1:(CGPoint)lineDot1 lineDot2:(CGPoint)lineDot2
                                  dot:(CGPoint)dot {
    CGFloat distance = -1;
    // 获取直线方程
    WLCoefficient line = [WLMapUtils getLineCoefficient:lineDot1 point2:lineDot2];
    if (line.a == M_PI && line.b == M_PI) { // 同一点无法获取直线方程
        return distance;  // -1 不合法
    } else if (line.a == M_PI_2 && line.b == M_PI_2) { // 垂直于x轴的线
        // 点到直线的距离
        distance = fabs(lineDot2.x - dot.x);
        // 垂足到线上两点之间的距离和大于两之间的距离说明垂足在延长线上
        if ((fabs(lineDot1.y - dot.y) + fabs(lineDot2.y - dot.y)) > fabs(lineDot2.y - lineDot1.y)) {
            return -1;  //边的延长线上
        }
    } else if (line.a == M_PI_4 && line.b == M_PI_4) { // 垂直于y轴
        // 点到直线的距离
        distance = fabs(lineDot2.y - lineDot1.y);
        // 垂足到线上两点之间的距离和大于两之间的距离说明垂足在延长线上
        if ((fabs(lineDot1.x - dot.x) + fabs(lineDot2.x - dot.x)) > fabs(lineDot2.x - lineDot1.x)) {
            return -1;  //边的延长线上
        }
    } else {
        // 点到直线的距离
        /*
         点到线的垂直距离公式：
         |A*x + B*y + C| / sqrt(pow(A,2) + pow(B,2))

         直线方程一般式：
         A * x + B * y + C = 0
         转换为斜截式：
         a = - A/B；
         b = - C/B；
         即为
         （-A/B）* x +（- C/B）= y；
         也就为
         a * x + b = y；
         a * x - y + b = 0；a
         带入距离公式也就为
         |a * x - y + b| / sqrt(pow(a,2) + 1)
         */
        distance = fabs((line.a * dot.x - dot.y + line.b) / sqrt((pow(line.a, 2) + 1)));
        //  获取垂足
        CGPoint intersectionPoint = [self getPerpendicularPointOfIntersectionByLineDot:lineDot1 lineDot2:lineDot2 dot:dot];
        // 通过垂足计算和两个端点间的距离。
        CGFloat intersectionPointD1 = pow(intersectionPoint.x - lineDot1.x, 2) + pow(intersectionPoint.y - lineDot1.y, 2);
        CGFloat intersectionPointD2 = pow(intersectionPoint.x - lineDot1.x, 2) + pow(intersectionPoint.y - lineDot1.y, 2);
        CGFloat intersectionPointD3 = pow(lineDot2.x - lineDot1.x, 2) + pow(lineDot2.y - lineDot1.y, 2);
        // 与两个端点间的距离和大于两个端点间的距离，则垂足在延长线上
        if ((sqrt(intersectionPointD1) + sqrt(intersectionPointD2)) > sqrt(intersectionPointD3)) {
            return -1; // 在边的延长线上
        }
    }
    return distance;
}
// 获取垂足
+ (CGPoint)getPerpendicularPointOfIntersectionByLineDot:(CGPoint)lineDot1
                                               lineDot2:(CGPoint)lineDot2 dot:(CGPoint)dot {
    // 获取两点直线
    WLCoefficient line = [WLMapUtils getLineCoefficient:lineDot1 point2:lineDot2];
    if (line.a == M_PI && line.b == M_PI) { // 没有直线方程
        NSLog(@"不合法");
        return CGPointMake(-1000000, -1000000);
    } else if (line.a == M_PI_2 && line.b == M_PI_2) { // 垂直于x轴
        return CGPointMake(lineDot1.x, dot.y);
    } else if (line.a == M_PI_4 && line.b == M_PI_4) { // 垂直于y轴
        return CGPointMake(dot.x, lineDot1.y);
    }

    // 获取垂足
    /*
     已知直线方程和直线上一点及直线外一点，求过直线外一点做直线垂线的垂足
     （x1，y1）为直线上一点
     （x2，y2）为直线外一点

     x = (y2 - y1 + k * x1 + x2 / k) / (k + 1.0 / k);
     y = (y1 + k * (x2 - x1))
     */
    CGFloat x = dot.x - (pow(line.a, 2) * dot.x - line.a * dot.y + line.a * line.b) / (1 + pow(line.a, 2));//(dot.y - lineDot1.y + line.a * lineDot1.x + dot.x / line.a) / (line.a + 1.0 / line.a);
    CGFloat y = dot.y - ((-line.a) * dot.x + dot.y - line.b) / (1 + pow(line.a, 2));//lineDot1.y + line.a * (dot.x - lineDot1.x);
    return CGPointMake(x, y);
}
@end
