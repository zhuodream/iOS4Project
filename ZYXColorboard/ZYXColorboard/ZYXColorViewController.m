//
//  ZYXColorViewController.m
//  ZYXColorboard
//
//  Created by 卓酉鑫 on 16/4/15.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXColorViewController.h"

@interface ZYXColorViewController ()

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UISlider *redSlider;
@property (nonatomic, weak) IBOutlet UISlider *greenSlipder;
@property (nonatomic, weak) IBOutlet UISlider *blueSlider;

@end

@implementation ZYXColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *color = self.colorDescription.color;
    CGFloat red,green,blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    self.redSlider.value = red;
    self.greenSlipder.value = green;
    self.blueSlider.value = blue;
    
    self.view.backgroundColor = color;
    
    self.textField.text = self.colorDescription.name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.colorDescription.name = self.textField.text;
    self.colorDescription.color = self.view.backgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.existingColor)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changerColor:(id)sender
{
    float red = self.redSlider.value;
    float green = self.greenSlipder.value;
    float blue = self.blueSlider.value;
    
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.view.backgroundColor = newColor;
}
@end
