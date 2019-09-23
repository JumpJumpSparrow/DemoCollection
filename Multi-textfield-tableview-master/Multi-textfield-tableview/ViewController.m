//
//  ViewController.m
//  Multi-textfield-tableview
//
//  Created by mcf on 2019/3/31.
//  Copyright © 2019 mcf. All rights reserved.
//

#import "ViewController.h"
#import "MultiTextFieldTableViewCell.h"
#import "MultiTextFieldModel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MultiTextFielDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *keysList;
@property (nonatomic, strong) MultiTextFieldModel *dataModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    table.backgroundColor = [UIColor brownColor];
    [table registerClass:[MultiTextFieldTableViewCell class] forCellReuseIdentifier:MultiTextFieldIdentifier];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    self.dataModel = [[MultiTextFieldModel alloc] init];
    
    self.titleList = @[@"开户行", @"注册人", @"银行账号", @"联系方式", @"公司地址", @"税号"];
    self.keysList = @[@"bankTitle", @"taxNo", @"accountMan", @"account", @"address", @"mobilePhone"];
    
}

- (void)multiTextFieldCell:(MultiTextFieldTableViewCell *)cell inputDidChanged:(NSString *)text {
    
    if (text) {
        [self.dataModel setValue:text forKey:cell.identifier];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MultiTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MultiTextFieldIdentifier forIndexPath:indexPath];
    NSString *identifier = self.keysList[indexPath.row];
    cell.identifier = identifier;
    cell.delegate = self;
    cell.textLabel.text = self.titleList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

@end
