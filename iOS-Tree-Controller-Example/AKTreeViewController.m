//
//  AKTreeViewController.m
//  iOS-Tree-Controller-Example
//
//  Created by Ahmed Karim on 2/5/13.
//  Copyright (c) 2013 Ahmed Karim. All rights reserved.
//

#import "AKTreeViewController.h"
#import "TreeViewNode.h"
#import "TheProjectCell.h"

@interface AKTreeViewController () {
    NSUInteger indentation;
    NSArray *nodes;
}

@property (nonatomic, retain) NSMutableArray *displayArray;

- (void)expandCollapseNode:(NSNotification *)notification;

- (void)fillDisplayArray;
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray;

- (void)fillNodesArray;
- (NSArray *)fillChildrenForNode;

- (IBAction)expandAll:(id)sender;
- (IBAction)collapseAll:(id)sender;

@end

@implementation AKTreeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
    
    [self fillNodesArray];
    [self fillDisplayArray];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Messages to fill the tree nodes and the display array

    //This function is used to expand and collapse the node as a response to the ProjectTreeNodeButtonClicked notification
- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.tableView reloadData];
}

    //These two functions are used to fill the nodes array with the tree nodes 
- (void)fillNodesArray
{
    TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
    firstLevelNode1.nodeLevel = 0;
    firstLevelNode1.nodeObject = [NSString stringWithFormat:@"Parent node 1"];
    firstLevelNode1.isExpanded = YES;
    firstLevelNode1.nodeChildren = [[self fillChildrenForNode] mutableCopy];
    
    TreeViewNode *firstLevelNode2 = [[TreeViewNode alloc]init];
    firstLevelNode2.nodeLevel = 0;
    firstLevelNode2.nodeObject = [NSString stringWithFormat:@"Parent node 2"];
    firstLevelNode2.isExpanded = YES;
    firstLevelNode2.nodeChildren = [[self fillChildrenForNode] mutableCopy];
    
    TreeViewNode *firstLevelNode3 = [[TreeViewNode alloc]init];
    firstLevelNode3.nodeLevel = 0;
    firstLevelNode3.nodeObject = [NSString stringWithFormat:@"Parent node 3"];
    firstLevelNode3.isExpanded = YES;
    firstLevelNode3.nodeChildren = [[self fillChildrenForNode] mutableCopy];
    
    TreeViewNode *firstLevelNode4 = [[TreeViewNode alloc]init];
    firstLevelNode4.nodeLevel = 0;
    firstLevelNode4.nodeObject = [NSString stringWithFormat:@"Parent node 4"];
    firstLevelNode4.isExpanded = YES;
    firstLevelNode4.nodeChildren = [[self fillChildrenForNode] mutableCopy];
    
    nodes = [NSMutableArray arrayWithObjects:firstLevelNode1, firstLevelNode2, firstLevelNode3, firstLevelNode4, nil];
}

- (NSArray *)fillChildrenForNode
{
    TreeViewNode *secondLevelNode1 = [[TreeViewNode alloc]init];
    secondLevelNode1.nodeLevel = 1;
    secondLevelNode1.nodeObject = [NSString stringWithFormat:@"Child node 1"];
    
    TreeViewNode *secondLevelNode2 = [[TreeViewNode alloc]init];
    secondLevelNode2.nodeLevel = 1;
    secondLevelNode2.nodeObject = [NSString stringWithFormat:@"Child node 2"];
    
    TreeViewNode *secondLevelNode3 = [[TreeViewNode alloc]init];
    secondLevelNode3.nodeLevel = 1;
    secondLevelNode3.nodeObject = [NSString stringWithFormat:@"Child node 3"];
    
    TreeViewNode *secondLevelNode4 = [[TreeViewNode alloc]init];
    secondLevelNode4.nodeLevel = 1;
    secondLevelNode4.nodeObject = [NSString stringWithFormat:@"Child node 4"];
    
    NSArray *childrenArray = [NSArray arrayWithObjects:secondLevelNode1, secondLevelNode2, secondLevelNode3, secondLevelNode4, nil];
    
    return childrenArray;
}

    //This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in nodes) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

    //This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

    //These functions are used to expand and collapse all the nodes just connect them to two buttons and they will work
- (IBAction)expandAll:(id)sender
{
    [self fillNodesArray];
    [self fillDisplayArray];
    [self.tableView reloadData];
}

- (IBAction)collapseAll:(id)sender
{
    for (TreeViewNode *treeNode in nodes) {
        treeNode.isExpanded = NO;
    }
    [self fillDisplayArray];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.displayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        //It's cruical here that this identifier is treeNodeCell and that the cell identifier in the story board is anything else but not treeNodeCell
    static NSString *CellIdentifier = @"treeNodeCell";
    UINib *nib = [UINib nibWithNibName:@"ProjectCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    TheProjectCell *cell = (TheProjectCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    cell.treeNode = node;
    
    cell.cellLabel.text = node.nodeObject;
    
    if (node.isExpanded) {
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"Open"]];
    }
    else {
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"Close"]];
    }
    [cell setNeedsDisplay];


    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
