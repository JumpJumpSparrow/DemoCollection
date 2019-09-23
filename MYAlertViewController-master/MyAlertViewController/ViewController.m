//
//  ViewController.m
//  MyAlertViewController
//
//  Created by MCF on 16/11/8.
//  Copyright © 2016年 MCF. All rights reserved.
//

#import "ViewController.h"
#import "MCFAlertController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)alertAction:(id)sender {
    MCFAlertController *alerController = [MCFAlertController alertControllerWithTitle:@"title样式" message:@"now you can see" preferredStyle:UIAlertControllerStyleActionSheet];
    alerController.messageColor = [UIColor greenColor];
    alerController.titleColor = [UIColor yellowColor];
    
    MCFAlertAction *actionOne = [MCFAlertAction actionWithTitle:@"自定义颜色1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    actionOne.textColor = [UIColor purpleColor];
    
    MCFAlertAction *actionTwo = [MCFAlertAction actionWithTitle:@"自定义颜色2" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    actionOne.textColor = [UIColor purpleColor];
    
    [alerController addAction:actionOne];

    [alerController addAction:actionTwo];
    
    [self presentViewController:alerController animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
