//
//  PaymentHub.h
//  MiaocfDemo
//
//  Created by suning on 2019/6/5.
//  Copyright © 2019年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayResponse.h"
#import <WechatOpenSDK/WXApi.h>

typedef void(^PayResult)(ZSPayResponse *result);
typedef void(^wxShareCallback)(int resp);

@interface PaymentHub : NSObject<WXApiDelegate>


/**
 获取 单利

 @return 返回单利实例
 */
+ (instancetype)hub;

/**
 支付宝支付

 @param orderStr 支付订单加密信息
 @param callback 支付结果回调
 */
- (void)AlipayWithOrder:(NSString *)orderStr callback:(PayResult)callback;



/**
 微信支付

 @param request 微信支付所需参数
 @param callback 支付结果回调
 */
- (void)WXpayWithRequest:(PayReq *)request callback:(PayResult)callback;

/**
 进程间通信处理

 @param url 进程间 交换的数据
 @param callback 微信分享回调
 */
- (void)handleOpenUrl:(NSURL *)url response:(wxShareCallback)callback;


+ (PayReq *)fromMap:(NSDictionary *)dict;

@end

