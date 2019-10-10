//
//  PayResponse.h
//  MiaocfDemo
//
//  Created by suning on 2019/6/6.
//  Copyright © 2019年 Suning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayResponse : NSObject

// wx: 微信支付 zfb:支付宝支付
@property (nonatomic, copy) NSString *pay_method;

// 1000: 支付成功, 900: 取消支付   400:网络错误
@property (nonatomic, assign) int status_code;

//支付异常信息
@property (nonatomic, copy) NSString *error_msg;


//TODO:model to JSON
- (NSString *)JSONString;

@end

