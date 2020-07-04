//
//  ViewController.m
//  NineBigSort
//
//  Created by Liu Dehua on 15/7/29.
//  Copyright (c) 2015年 Liu Dehua. All rights reserved.
//

#import "ViewController.h"
#import "NineBigSort.h"

#define CELL_IDENTIFIER @"KCell"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *sortTypeArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _sortTypeArray=@[@{@"name":@"冒泡",@"type":@[@"冒泡排序",@"改进版冒泡排序"]},
                     @{@"name":@"插入",@"type":@[@"插入排序"]},
                     @{@"name":@"选择",@"type":@[@"选择排序"]},
                     @{@"name":@"归并",@"type":@[@"归并排序"]},
                     @{@"name":@"快速",@"type":@[@"快速排序"]},
                     @{@"name":@"堆",@"type":@[@"堆排序"]},
                     @{@"name":@"计数",@"type":@[@"计数排序"]},
                     @{@"name":@"基数",@"type":@[@"基数排序"]},
                     @{@"name":@"桶",@"type":@[@"桶排序"]}];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
}
#pragma mark UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30)];
    view.backgroundColor=[UIColor lightGrayColor];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.bounds) , 20)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:20];
    label.text=_sortTypeArray[section][@"name"];
    [view addSubview:label];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sortTypeArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_sortTypeArray[section][@"type"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableViewCell=[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    tableViewCell.textLabel.text=_sortTypeArray[indexPath.section][@"type"][indexPath.row];
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int  array[] = {12, 14, 54, 5, 6, 3, 9, 8, 47, 89, -1};
    for (int i=0; i< 10; i++)
    {
        printf("%d ", array[i]);
    }
    printf("\n");
    //1.冒泡排序
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            printf("冒泡排序：");
            bubbleSort(array, 10);
            for (int i=0; i < 10; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
        }else if (indexPath.row==1) {
            printf("改进冒泡排序：");
            improvedBubbleSort(array, 10);
            for (int i=0; i < 10; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
        }
    //2.插入排序
    }else if (indexPath.section==1) {
        if (indexPath.row==0) {
            printf("插入排序：");
            insertSort(array, 10);
            for (int i=0; i < 10; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
        }else if (indexPath.row==1) {

        }
    //3.选择排序
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            printf("选择排序：");
            sectionSort(array, 10);
            for (int i=0; i < 10; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
        }else if (indexPath.row==1) {
            
        }
    //4.归并排序
    }else if (indexPath.section==3) {
        if (indexPath.row==0) {
            int p[10];
            printf("归并排序：");
            mergeSort(array, 0, 9, p);
            for (int i=0; i < 10; i++)
            {
                printf("%d ", p[i]);
            }
            printf("\n");
        }else if (indexPath.row==1) {
            
        }
    //5.归并排序
    }else if (indexPath.section==4) {
        if (indexPath.row==0) {
            printf("归并排序：");
            quickSort(array, 0, 9);
            for (int i=0; i < 10; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
        }else if (indexPath.row==1) {
            
        }
    //6.堆排序
    }else if (indexPath.section==5) {
        if (indexPath.row==0) {
            printf("创建堆：");
            createHeap(array,10);
            for (int i=0; i < 10; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
            printf("删除元素：");
            int length = deleteElement(array,10);
            for (int i=0; i < length; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
            printf("插入元素：");
            length = insertElement(array,length,99);
            for (int i=0; i < length; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
            printf("堆排序：");
            heapSort(array, length);
            for (int i=0; i < length; i++)
            {
                printf("%d ", array[i]);
            }
            printf("\n");
        }else if (indexPath.row==1) {
            
        }
    //7.计数排序
    }else if (indexPath.section == 6) {
        int B[10];
        printf("计数排序：");
        countSort(array, B, 10, 89);
        for (int i=0; i < 10; i++)
        {
            printf("%d ", B[i]);
        }
        printf("\n");
    //8.基数排序
    }else if (indexPath.section==7){
        
        printf("基数排序：");
        radixSort(array, 10);
        for (int i=0; i < 10; i++)
        {
            printf("%d ", array[i]);
        }
        printf("\n");
    //9.桶排序
    }else if (indexPath.section==8){
        
        //printf("桶排序：");
        /*
           桶排序是另外一种以O(n)或者接近O(n)的复杂度排序的算法.
         它假设输入的待排序元素是等可能的落在等间隔的值区间内.一
         个长度为N的数组使用桶排序, 需要长度为N的辅助数组. 等间
         隔的区间称为桶, 每个桶内落在该区间的元素. 桶排序是基数
         排序的一种归纳结果

           算法的主要思想: 待排序数组A[1...n]内的元素是随机分布在
         [0,1)区间内的的浮点数.辅助排序数组B[0....n-1]的每一个
         元素都连接一个链表.将A内每个元素乘以N(数组规模)取底,并以
         此为索引插入(插入排序)数组B的对应位置的连表中. 最后将所
         有的链表依次连接起来就是排序结果.
         
         这个过程可以简单的分步如下:
         
           设置一个定量的数组当作空桶子。
           寻访序列，并且把项目一个一个放到对应的桶子去。
           对每个不是空的桶子进行排序。
           从不是空的桶子里把项目再放回原来的序列中。
         */

    }
}

@end
