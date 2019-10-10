//
//  PaymentHub.h
//  MiaocfDemo
//
//  Created by suning on 2019/6/5.
//  Copyright © 2019年 Suning. All rights reserved.
//
#import "PaymentHub.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PaymentHub ()

@property (nonatomic, copy) PayResult wxResult;
@property (nonatomic, copy) PayResult zfbResult;

@property (nonatomic, copy) wxShareCallback wxShareCallback;
@end

@implementation PaymentHub

- (void)AlipayWithOrder:(NSString *)orderStr callback:(PayResult)callback {
    
    if (orderStr.length == 0) {
        
        if (callback) {
            PayResponse * result = [[PayResponse alloc] init];
            result.pay_method = @"zfb";
            result.status_code = 400;
            result.error_msg = @"支付信息缺失";
            callback(result);
        }
        
    } else {
        if (callback) {
            self.zfbResult = callback;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *scheme = @"zfbScheme";
            [[AlipaySDK defaultService] payOrder:orderStr fromScheme:scheme callback:^(NSDictionary *resultDic) {
                NSLog(@"zfb_payOrder reslut = %@",resultDic);
                PayResponse * result = [[PayResponse alloc] init];
                result.pay_method = @"zfb";
                
                int status = [resultDic[@"resultStatus"] intValue];
                if (status == 9000) {
                    result.status_code = 1000;
                    result.error_msg = @"支付成功";
                } else {
                    result.status_code = 400;
                    result.error_msg = @"支付失败";
                }
                if (self.zfbResult) {
                    self.zfbResult(result);
                }
            }];
        });
    }
}

- (void)WXpayWithRequest:(PayReq *)request callback:(PayResult)callback {
    
    if (callback) {
        self.wxResult = callback;
    }
    if (request) {
        //wx api 发起支付
        [WXApi sendReq:request];
    } else {
        
        PayResponse * result = [[PayResponse alloc] init];
        result.pay_method = @"wx";
        result.status_code = 400;
        result.error_msg = @"支付信息缺失";
        if (callback) {
            callback(result);
        }
    }
}

- (void)onResp:(BaseResp *)resp {
    
    if([resp isKindOfClass:[PayResp class]]){
        
        PayResponse * result = [[PayResponse alloc] init];
        
        switch (resp.errCode) {
            case WXSuccess:{
                //支付成功
                result.pay_method = @"wx";
                result.status_code = 1000;
                result.error_msg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                if (self.wxResult) {
                    self.wxResult(result);
                }
                break;
            }
            case WXErrCodeUserCancel:{
                //用户取消支付
                result.pay_method = @"wx";
                result.status_code = 900;
                result.error_msg = resp.errStr;
                NSLog(@"用户取消支付，retcode = %d", resp.errCode);
                if (self.wxResult) {
                    self.wxResult(result);
                }
                break;
            }
            default: {
                //微信支付失败集合
                result.pay_method = @"wx";
                result.status_code = 400;
                result.error_msg = resp.errStr;
                NSLog(@"支付失败，retcode = %d  retMsg = %@", resp.errCode, resp.errStr);
                if (self.wxResult) {
                    self.wxResult(result);
                }
                break;
            }
        }
    } else {
        
        //微信分享处理
        if (self.wxShareCallback) {
            self.wxShareCallback(resp.errCode);
        }
    }
}

- (void)handleOpenUrl:(NSURL *)url  response:(wxShareCallback)callback{
    
    if (callback) {
        self.wxShareCallback = callback;//微信分享回调
    }
    if ([url.host isEqualToString:@"safepay"]) {
        
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            PayResponse * result = [[PayResponse alloc] init];
            result.pay_method = @"zfb";
            
            int status = [resultDic[@"resultStatus"] intValue];
            if (status == 9000) {
                result.status_code = 1000;
                result.error_msg = @"支付成功";
            } else {
                result.status_code = 400;
                result.error_msg = @"支付失败";
            }
            if (self.zfbResult) {
                self.zfbResult(result);
            }
            
        }];
        
    } else { //微信支付就是这么diao
        [WXApi handleOpenURL:url delegate:self];
    }
}

+ (PayReq *)fromMap:(NSDictionary *)dict {
    
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = [dict objectForKey:@"partnerId"];
    req.prepayId = [dict objectForKey:@"prepayId"];
    req.nonceStr = [dict objectForKey:@"nonceStr"];
    req.timeStamp = [[dict objectForKey:@"timeStamp"] unsignedIntValue];
    req.package = [dict objectForKey:@"packageValue"];
    req.sign = [dict objectForKey:@"sign"];
    
    return req;
}

+ (instancetype)hub{
    static dispatch_once_t onceToken;
    static ZSPaymentHub *hub = nil;
    dispatch_once(&onceToken, ^{
        hub = [[ZSPaymentHub alloc] init];
    });
    return hub;
}

@end

