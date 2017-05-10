//
//  NineBigSort.m
//  NineBigSort
//
//  Created by 康永帅 on 15/7/29.
//  Copyright (c) 2015年 Liu Dehua. All rights reserved.
//

#import "NineBigSort.h"

//交换
void swap(int *x, int *y){
    *x ^= *y;
    *y ^= *x;
    *x ^= *y;
}

#pragma mark 冒泡排序
//冒泡排序
void bubbleSort(int* array, int length)
{
    int i, j;
    for(i = 0; i < length; i++)
    {
        for(j = 0; j < length-(i+1); j++)
        {
            //把大得换到最后（也可把小的换到最前）
            if(array[j] > array[j + 1])
            {
                swap(array+j,array+j+1);
            }
        }
    }
}

//改进冒泡排序
void improvedBubbleSort(int* array, int length)
{
    bool flag=true;
    int i, j;
    for(i = 0; i < length; i++)
    {
        if (false == flag) {
            return;
        }
        flag = false;
        for(j = 0; j < length-(i+1); j++)
        {
            //把大得换到最后（也可把小的换到最前）
            if(array[j] > array[j + 1])
            {
                swap(array+j,array+j+1);
                flag = true;
            }
        }
    }
}

#pragma mark 插入排序
//插入排序
void insertSort(int* array, int length)
{
    int i, j, key;
    for(i = 1; i < length; i++)
    {
        j = i-1;
        key = array[i];
        while (j>=0 && array[j]>key) {
            array[j+1] = array[j];//元素后移
            j--;
        }
        array[j+1]=key;
    }
}

#pragma mark 选择排序
//选择排序
void sectionSort(int* array, int length)
{
    int i, j, min;
    for(i = 0; i < length; i++)
    {
        min=i;
        for (j=i+1; j<length; j++) {
            if (array[j]<array[min]) {
                min=j;
            }
        }
        if (min!=i) {
            swap(array+i,array+min);
        }
        
    }
}

#pragma mark 归并排序
//将有二个有序数列a[first...mid]和a[mid+1...last]合并。
void mergeArray(int *a, int first, int mid, int last, int *temp)
{
    int i = first, m = mid;
    int j = mid + 1, n = last;
    int k = 0;//记录元素个数
    
    while (i <= m && j <= n)
    {
        if (a[i] <= a[j])
            temp[k++] = a[i++];
        else
            temp[k++] = a[j++];
    }
    
    while (i <= m)
        temp[k++] = a[i++];
    
    while (j <= n)
        temp[k++] = a[j++];
    
    //复制回原数组，这样原数组这段就是有序的了
    for (i = 0; i < k; i++)
        a[first + i] = temp[i];
}
//实现
void mergeSort(int *a, int first, int last, int *temp)
{
    if (first < last)
    {
        //分割
        int mid = (first + last) / 2;
        mergeSort(a, first, mid, temp);    //左边有序
        mergeSort(a, mid + 1, last, temp); //右边有序
        //合并
        mergeArray(a, first, mid, last, temp); //再将二个有序数列合并
    }
}

#pragma mark 快速排序
//快速排序
void quickSort(int *s, int low, int high)
{
    int i, j, key;
    if (low < high)
    {
        i = low;
        j = high;
        key = s[i];
        while (i < j)
        {
            while(i < j && s[j] > key)
                j--; /* 从右向左找第一个小于x的数 */
            if(i < j)
                s[i++] = s[j];
            
            while(i < j && s[i] < key)
                i++; /* 从左向右找第一个大于x的数 */
            if(i < j)
                s[j--] = s[i];
        }
        s[i] = key;
        quickSort(s, low, i-1); /* 递归调用 */
        quickSort(s, i+1, high);
    }
}

#pragma mark 堆排序
//向下调整

//非递归实现
//array是待调整的堆数组，i是待调整的数组元素的位置，nlength是数组的长度
//本函数功能是：根据数组array构建大根堆
void heapDownAdjust(int array[],int i,int nLength)
{
    int nChild;
    //for(;2*i+1 < nLength;i=nChild)
    while(2*i+1 < nLength)
    {
        //子结点的位置=2*（父结点位置）+1
        nChild=2*i+1;//左孩子
        //得到子结点中较大的结点
        if(nChild<nLength-1 && array[nChild+1]>array[nChild])
            ++nChild;
        //如果较大的子结点大于父结点那么把较大的子结点往上移动，替换它的父结点
        if(array[i]<array[nChild])
        {
            swap(array+i,array+nChild);
        }
        else
            break; //否则退出循环
        i=nChild;
    }
}

//递归实现
void heapDownRecursiveAdjust(int array[],int i,int nLength)
{
    int nChild;
    if (2*i+1 < nLength) {
        //子结点的位置=2*（父结点位置）+1
        nChild=2*i+1;//左孩子
        //得到子结点中较大的结点
        if(nChild<nLength-1 && array[nChild+1]>array[nChild])
            ++nChild;
        if(array[i]<array[nChild]){
            swap(array+i,array+nChild);
            heapDownRecursiveAdjust(array, nChild, nLength);
        }
    }
    
}

//向上调整
//非递归实现
void heapUpAdjust(int *array, int index, int nLength){
    int i = index;//子节点
    int j = (i-1)/2;//父结点
    int temp = array[i];
    while(i>0){
        if(temp <= array[j])
            break;
        else
        {
            array[i] = array[j];//比较换高明
            i = j;
            //记录父结点
            j = (j-1)/2;
        }
    }
    array[i] = temp;
}

//递归实现
void heapUpRecursiveAdjust(int array[], int index, int nLength){
    int i = index;
    int j = (i-1)/2;
    if(i>0){
        if(array[i] <= array[j])
            return;
        else
        {
            swap(array+i, array+j);
            heapUpRecursiveAdjust(array, j, nLength);
        }
    }
}


//创建堆
void createHeap(int *array,int length)
{
    int i;
    //调整序列的前半部分元素，调整完之后第一个元素是序列的最大的元素
    //length/2-1是最后一个非叶节点，此处"/"为整除
    for(i=length/2-1;i>=0;--i)
        heapDownAdjust(array,i,length);
        //heapDownRecursiveAdjust(array,0,i);
}

//插入元素
int insertElement(int *array, int length, int element){
    if (length) {
        //放入元素，这里注意数组长度要大于length+1
        array[length]=element;
        ++length;
        //向上调整
        heapUpAdjust(array, length-1, length);
        //heapUpRecursiveAdjust(array, length-1, length);
        return length;
    }
    return -1;
}

//删除堆元素（堆只能删除根元素）
int deleteElement(int *array, int length){
    if (length) {
        //根结点与最后一个结点交换
        swap(array,array+length-1);
        //向下交换
        heapDownAdjust(array,0,length-1);
        return length-1;
    }
    return 0;
}

//堆排序算法
void heapSort(int *array,int length)
{
    int i;
    //从最后一个元素开始对序列进行调整，不断的缩小调整的范围直到第一个元素
    for(i=length-1;i>0;--i)
    {
        //把第一个元素和当前的最后一个元素交换，
        //保证当前的最后一个位置的元素都是在现在的这个序列之中最大的
        swap(array,array+i);
        //不断缩小调整heap的范围，每一次调整完毕保证第一个元素是当前序列的最大值
        heapDownAdjust(array,0,i);
        //heapDownRecursiveAdjust(array,0,i);
    }
}

#pragma mark 计数排序
void countSort(int *input, int *output, int length, int k)//时间复杂度为Ο(n+k)（其中k是整数的范围）
{
    // input为输入数组，output为输出数组，length表示数组长度，k表示有所输入数字都介于0到k之间
    int C[k+1], i, value, pos;
    //初始化
    for(i=0; i<=k; i++)
    {
        C[i] = 0;
    }
    
    //检查每个输入元素，如果一个输入元素的值为input[i],那么c[input[i]]的值加1，此操作完成后，c[i]中存放了值为i的元素的个数
    for(i=0; i< length; i++)
    {
        C[input[i]] ++;
    }
    
    // 通过在c中记录计数和，c[i]中存放的是小于等于i元素的数字个数
    for(i=1; i<=k; i++)
    {
        C[i] = C[i] + C[i-1];
    }
    
    // 从后往前遍历
    for(i=length-1; i>=0; i--)
    {
        value = input[i];
        pos = C[value];
        output[pos-1] = value;
        C[value]--;// 该操作使得下一个值为input[i]的元素直接进入输出数组中input[i]的前一个位置
    }
}


#pragma mark 基数排序
//找到num的从低到高的第pos位的数据
int getNumInPosition(int num,int pos)
{
    int temp = 1;
    for (int i = 0; i < pos - 1; i++)
        temp *= 10;
    
    return (num / temp) % 10;
}

//基数排序
#define RADIX_10 10      //正整形排序
#define KEYNUM_31 10     //正整形位数
void radixSort(int* array, int length)//时间复杂度O(dn)(d即表示最高位数)
{
    //length表示数组长度
    int *radixArrays[RADIX_10];    //分别为0~9的序列空间
    for (int i = 0; i < 10; i++)
    {
        radixArrays[i] = (int *)malloc(sizeof(int) * (length + 1));
        radixArrays[i][0] = 0;    //index为0处记录这组数据的个数
    }
    
    for (int pos = 1; pos <= KEYNUM_31; pos++)
    {
        //分配过程
        for (int i = 0; i < length; i++)
        {
            int num = getNumInPosition(array[i], pos);
            int index = ++radixArrays[num][0];
            radixArrays[num][index] = array[i];
        }
        
        //收集
        for (int i = 0, j =0; i < RADIX_10; i++)
        {
            for (int k = 1; k <= radixArrays[i][0]; k++)
                array[j++] = radixArrays[i][k];
            radixArrays[i][0] = 0;    //复位
        }
    }
}
