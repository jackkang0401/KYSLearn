//
//  KYSRedBalckTree.m
//  KYSRedBlackTree
//
//  Created by 康永帅 on 16/9/24.
//  Copyright © 2016年 康永帅. All rights reserved.
//

#import "KYSRedBalckTree.h"

#include <stdio.h>
#include <stdlib.h>

//定义颜色类型
typedef enum Color
{
    RED = 0,
    BLACK = 1
}Color;

//定义结点结构
typedef struct Node //
{
    struct Node *parent;
    struct Node *left;
    struct Node *right;
    int value;
    Color color;
}Node, *Tree;

/*
 方便处理边界，结点NIL替代NULL
 所有空都指向它，可以看成外部结点
 */
Node *NIL=NULL;

//左旋：将x的右子树y旋转成x的父母
void LeftRotate(Tree T, Node *x)
{
    if(x->right != NIL) {
        Node *y=x->right;
        //1.修改x的右孩子与y的左孩子的父结点的指针
        x->right=y->left;
        if(y->left != NIL) {
            y->left->parent=x;
        }
        //2.修改y的父结点与x父结点的孩子结点的指针
        y->parent=x->parent;
        if(x->parent == NIL){
            T=y;
        }else{
            if(x == x->parent->left) {
                x->parent->left=y;
            }else{
                x->parent->right=y;
            }
        }
        //3.修改y的左孩子与x的父结点的指针
        y->left=x;
        x->parent=y;
    } else {
        printf("can't execute left rotate due to null right child/n");
    }
}

//右旋：将x的左子树y旋转成x的父母
void RightRotate(Tree T, Node *x)
{
    if( x->left != NIL ) {
        Node *y=x->left;
        //1.修改x的左孩子与y的右孩子的父结点的指针
        x->left=y->right;
        if( y->right != NIL ) {
            y->right->parent=x;
        }
        //2.修改y的父结点与x父结点的孩子结点的指针
        y->parent=x->parent;
        if( x->parent == NIL ) {
            T=y;
        } else {
            if(x == x->parent->left) {
                x->parent->left=y;
            } else {
                x->parent->right=y;
            }
        }
        //3.修改y的右孩子与x的父结点的指针
        y->right=x;
        x->parent=y;
    } else {
        printf("can't execute right rotate due to null left child/n");
    }
}

void InsertFixup(Tree T, Node *z) {
    Node *y;
    //插入结点的父结点为红色时，违反性质4
    while( z->parent->color == RED ) {
        if( z->parent->parent->left == z->parent ) {
            //y指向z的叔叔结点
            y= z->parent->parent->right;
            /*
             情况1:如果y为RED，将y与z的父结点着为BLACK，z的祖父着为红色，此时z的祖父可能违反性质3，将z上移至祖父结点
             */
            if(y->color == RED) {
                y->color=BLACK;
                z->parent->color=BLACK;
                z->parent->parent->color=RED;
                z=z->parent->parent;
            } else {
                /*
                 情况2：如果y为BLACK，且z是右孩子，将z上移到父结点，对z左旋，转化为情况3
                 */
                if(z == z->parent->right) {
                    z=z->parent;
                    LeftRotate(T, z);
                }
                /*
                 情况3：如果y为BLACK，且z是左孩子，将z的父结点着为BLACK，z的祖父结点着为RED，对z的祖父结点右旋
                 */
                z->parent->color=BLACK;
                z->parent->parent->color=RED;
                RightRotate(T,z->parent->parent);
            }
        } else {
            //对称，左右替换即可
            y=z->parent->parent->left;
            if( y->color == RED) {
                y->color=BLACK;
                z->parent->color=BLACK;
                z->parent->parent->color=RED;
                z=z->parent->parent;
            } else {
                if( z == z->parent->left) {
                    z=z->parent;
                    RightRotate(T,z);
                }
                z->parent->color=BLACK;
                z->parent->parent->color=RED;
                LeftRotate(T,z->parent->parent);
            }
        }
    }
    T->color=BLACK;
}


void Insert(Tree T, int val)
{
    if(T == NULL) {
        T=(Tree)malloc(sizeof(Node));
        NIL=(Node*)malloc(sizeof(Node));
        NIL->color=BLACK;
        T->left=NIL;
        T->right=NIL;
        T->parent=NIL;
        T->value=val;
        T->color=BLACK;
    }else{
        Node *x=T;
        Node *p=NIL;
        while(x != NIL) {
            p=x;
            if(val < x->value){
                x=x->left;
            }else if(val > x->value){
                x=x->right;
            }else{
                printf("duplicate value %d/n",val);
                return;
            }
        }
        x=(Node*)malloc(sizeof(Node));
        x->color=RED;
        x->left=NIL;
        x->right=NIL;
        x->parent=p;
        x->value=val;
        if(val < p->value){
            p->left = x;
        }else{
            p->right = x;
        }
        //从x开始调整
        InsertFixup(T, x);
    }
}
    
//右子树最小结点
Node* Successor(Tree T, Node *x)
{
    if(x->right != NIL) {
        Node *p=x->right;
        while( p->left != NIL ) {
            p=p->left;
        }
        //右孩子中最小的结点
        return p;
    }
    return x;
}


void DeleteFixup(Tree T, Node *x) {
    //x是RED直接跳出
    while( x != T && x->color == BLACK ) {
        //x为左子树
        if(x == x->parent->left) {
            //w为x的兄弟结点
            Node *w=x->parent->right;
            /*
             情况1：如果w为RED，由于x为BLACK且删除了一个BLACK结点，所以w必有BLACK孩子。
             此时将w着为BLACK，x父结点着为RED，对x的父结点左旋。x的新兄弟结点w是BLACK，情况1转换为情况2、3或4
            */
            if(w->color == RED){
                w->color=BLACK;
                x->parent->color=RED;
                LeftRotate(T, x->parent);
                w=x->parent->right;
            }
            /*
             情况2：如果w为BLACK，w的左右孩子为BLACK。w着为RED，x上移至父结点
             */
            if(w->left->color == BLACK && w->right->color == BLACK) {
                w->color=RED;
                x=x->parent;
            } else {
                /*
                 情况3：如果w为BLACK，w的左孩子为RED，右孩子为BLACK。
                 交换w与其左孩子的color，对w进行右旋。旋转后x的新兄弟w是一个有RED右孩子的BLACK结点，转换成情况4
                 */
                if(w->right->color == BLACK) {
                    w->color=RED;
                    w->left->color=BLACK;
                    RightRotate(T, w);
                    w=x->parent->right;
                }
                /*
                 情况4：如果w为BLACK，w的右孩子为RED。
                 将w着为x父结点的颜色，x父结点着为BLACK，w右孩子着为BLACK，对x的父结点左旋，x设为根结点
                 */
                w->color=x->parent->color;
                x->parent->color=BLACK;
                w->right->color=BLACK;
                LeftRotate(T,x->parent);
                x=T;
            }
        } else {
            //与前面对称，不再详述
            Node *w=x->parent->left;
            if(w->color == RED) {
                w->color=BLACK;
                x->parent->color=RED;
                RightRotate(T, x->parent);
                w=x->parent->left;
            }
            if(w->left->color == BLACK && w->right->color == BLACK) {
                w->color=RED;
                x=x->parent;
            } else {
                if(w->left->color == BLACK) {
                    w->color=RED;
                    w->right->color=BLACK;
                    LeftRotate(T, w);
                    w=x->parent->left;
                }
                w->color=x->parent->color;
                x->parent->color=BLACK;
                w->left->color=BLACK;
                RightRotate(T,x->parent);
                x=T;
            }
        }
    }
    x->color=BLACK;
}


void Delete(Tree T, Node *z) {
    Node *y;//指向将要被删除的结点
    Node *x;//指向将要被删除的结点的唯一儿子
    //如果有一个子结点为NIL，删除当前结点
    if(z->left == NIL || z->right == NIL){
        y=z;
    } else {
        //删除左子树的最大结点或右子树最小结点
        y=Successor(T, z);//这里是右子树最大结点
    }
    
    //开始删除
    if(y->left != NIL) {
        x=y->left;
    } else {
        x=y->right;
    }
    if (x != NIL){
        x->parent=y->parent;
    }
    if( y->parent == NIL ) {
        T=x;
    } else {
        if( y == y->parent->left ) {
            y->parent->left=x;
        } else {
            y->parent->right=x;
        }
    }
    //交换值
    if( y != z ) {
        z->value=y->value;
    }
    //如果删除的是黑色结点，进行调整
    if( y->color == BLACK ) {
        //没有修改y结点，任意属性的值，可以使用
        DeleteFixup(T,NIL!=x ? x:y);
    }
}


Node* Search(Tree T, int val) {
    if( T != NIL ) {
        if( val < T->value ) {
            Search(T->left, val);
        } else if ( val > T->value ) {
            Search(T->right,val);
        } else {
            return T;
        }
    }
    return T;
}

















    
