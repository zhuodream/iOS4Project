//
//  ZYXItemsViewController.m
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/3/1.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "ZYXItemsViewController.h"
#import "ZYXDetailViewController.h"
#import "ZYXItemStore.h"
#import "ZYXItem.h"
#import "ZYXItemCell.h"
#import "ZYXImageStore.h"
#import "ZYXImageViewController.h"

@interface ZYXItemsViewController () <UIPopoverControllerDelegate, UIViewControllerRestoration, UIDataSourceModelAssociation>

@property (nonatomic, strong) UIPopoverController *imagePopover;

@end

@implementation ZYXItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.navigationItem.title = NSLocalizedString(@"Homepwner", @"Name of application");
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYXItemCell" bundle:nil] forCellReuseIdentifier:@"ZYXItemCell"];
    self.tableView.restorationIdentifier = @"ZYXItemsViewControllerTableView";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewForDynamicTypeSize];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ZYXItemStore sharedStore] allItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYXItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZYXItemCell" forIndexPath:indexPath];
    NSArray *items = [ZYXItemStore sharedStore].allItems;
    ZYXItem *item = items[indexPath.row];
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    
    static NSNumberFormatter *currencyFormatter = nil;
    if (currencyFormatter == nil)
    {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];
    cell.thumbnailView.image = item.thumbnail;
    
    __weak typeof(cell) weakcell = cell;
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        {
            NSString *itemKey = item.itemKey;
            ZYXItemCell *strongCell = weakcell;
            UIImage *img = [[ZYXImageStore sharedStore] imageForKey:itemKey];
            if (!img)
            {
                return ;
            }
            
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            
            ZYXImageViewController *ivc = [[ZYXImageViewController alloc] init];
            
            ivc.image = img;
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *items = [[ZYXItemStore sharedStore] allItems];
        ZYXItem *item = items[indexPath.row];
        [[ZYXItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ZYXItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"Remove";
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Remove" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSArray *items = [[ZYXItemStore sharedStore] allItems];
        ZYXItem *item = items[indexPath.row];
        [[ZYXItemStore sharedStore] removeItem:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }];
    
    return @[deleteButton];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYXItem *item = [[ZYXItemStore sharedStore] allItems][indexPath.row];
    ZYXDetailViewController *detailViewController = [[ZYXDetailViewController alloc] initForNewItem:NO];
    detailViewController.item = item;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - HeaderView Action
- (void)addNewItem:(id)sender
{
    ZYXItem *newItem = [[ZYXItemStore sharedStore] createItem];
    ZYXDetailViewController *detailViewController = [[ZYXDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma make - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}

#pragma mark - dynamic font
- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    if (!cellHeightDictionary)
    {
        cellHeightDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                  UIContentSizeCategorySmall : @44,
                                  UIContentSizeCategoryMedium : @44,
                                  UIContentSizeCategoryLarge : @44,
                                  UIContentSizeCategoryExtraLarge : @55,
                                  UIContentSizeCategoryExtraExtraLarge : @65,
                                  UIContentSizeCategoryExtraExtraExtraLarge : @75};
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

- (void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}

#pragma mark - UIViewControllerRestoration
+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSLog(@"开启回复");
    NSString *identifier = nil;
    if (idx && view)
    {
        ZYXItem *item = [[ZYXItemStore sharedStore] allItems][idx.row];
        identifier = item.itemKey;
    }
    
    return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
    
    if (identifier && view)
    {
        NSArray *items = [[ZYXItemStore sharedStore] allItems];
        for (ZYXItem *item in items)
        {
            if ([identifier isEqualToString:item.itemKey])
            {
                NSInteger row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    NSLog(@"indexPath = %@", indexPath);
    return indexPath;
}
@end
