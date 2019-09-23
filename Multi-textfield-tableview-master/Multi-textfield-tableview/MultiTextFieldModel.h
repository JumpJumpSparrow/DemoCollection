//
//  MultiTextFieldModel.h
//  Multi-textfield-tableview
//
//  Created by mcf on 2019/3/31.
//  Copyright © 2019 mcf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiTextFieldModel : NSObject

@property (nonatomic, copy) NSString *bankTitle;
@property (nonatomic, copy) NSString *taxNo;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *accountMan;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *mobilePhone;

@end

NS_ASSUME_NONNULL_END
