//
//  ZYXPatternViewController.m
//  ZYXColorboard
//
//  Created by 卓酉鑫 on 16/4/15.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXPatternViewController.h"
#import "ZYXColorViewController.h"
#import "ZYXColorDescription.h"

@interface ZYXPatternViewController ()

@property (nonatomic, strong) NSMutableArray *colors;

@end

@implementation ZYXPatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.colors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    ZYXColorDescription *color = self.colors[indexPath.row];
    cell.textLabel.text = color.name;
    
    return cell;
}


- (NSMutableArray *)colors
{
    if (!_colors)
    {
        _colors = [NSMutableArray array];
        
        ZYXColorDescription *cd = [[ZYXColorDescription alloc] init];
        [_colors addObject:cd];
    }
    
    return _colors;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewColor"])
    {
        ZYXColorDescription *color = [[ZYXColorDescription alloc] init];
        [self.colors addObject:color];
        
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        ZYXColorViewController *mvc = (ZYXColorViewController *)[nc topViewController];
        mvc.colorDescription = color;
    }
    else if ([segue.identifier isEqualToString:@"ExistingColor"])
    {
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        ZYXColorDescription *color = self.colors[ip.row];
        
        ZYXColorViewController *cvc = (ZYXColorViewController *)segue.destinationViewController;
        cvc.colorDescription = color;
        cvc.existingColor = YES;
    }
}

@end
