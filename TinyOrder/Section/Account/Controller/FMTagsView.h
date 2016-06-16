//
//  FMTagsView.h
//  TinyOrder
//
//  Created by 仙林 on 16/6/14.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuActivityMD;


@protocol FMTagsViewDelegate;

@interface FMTagsView : UIView

@property (nonatomic)UIEdgeInsets contentInserts;// default is (10,10,10,10)
@property (nonatomic)NSArray<MenuActivityMD *> * tagsArray;// 数据源
@property (nonatomic, weak)id<FMTagsViewDelegate> delegate;

@property (nonatomic)CGFloat lineSpacing; // 行间距，默认10
@property (nonatomic)CGFloat interitemSpacing; // 元素之间的间距，默认为5

#pragma mark - ......::::::: 标签定制属性 :::::::......

@property (nonatomic)UIEdgeInsets tagInsets;// // default is (5,5,5,5)
@property (nonatomic)CGFloat tagBorderWidth; // 标签边框宽度，default is 0
@property (nonatomic)CGFloat tagcornerRadius; // defaults is 0
@property (nonatomic, strong)UIColor * tagBorderColor;
@property (nonatomic, strong)UIColor * tagSelectedBorderColor;
@property (nonatomic, strong)UIColor * tagBackgroundColor;
@property (nonatomic, strong)UIColor * tagSelectedBackgroundColor;
@property (nonatomic, strong)UIFont * tagFont;
@property (strong, nonatomic) UIFont *tagSelectedFont;
@property (strong, nonatomic) UIColor *tagTextColor;
@property (strong, nonatomic) UIColor *tagSelectedTextColor;

@property (nonatomic)CGFloat tagHeight; // 标签高度，默认28
@property (nonatomic)CGFloat mininumTagWidth;//tag 最小宽度值, 默认是0，即不作最小宽度限制
@property (nonatomic) CGFloat maximumTagWidth;  //tag 最大宽度值, 默认是CGFLOAT_MAX， 即不作最大宽度限制

#pragma mark - ......::::::: 选中 :::::::......

@property (nonatomic)BOOL allowsSelection; // 是否允许选中，default is YES
@property (nonatomic)BOOL allowsMultipleSelection;// 是否允许多选，default is NO
@property (nonatomic, readonly) NSUInteger selectedIndex;   //选中索引
@property (nonatomic, readonly) NSArray<MenuActivityMD *> *selecedTags;     //多选状态下，选中的Tags

- (void)selectTagAtIndex:(NSUInteger)index animate:(BOOL)animate;
- (void)deSelectTagAtIndex:(NSUInteger)index animate:(BOOL)animate;

#pragma mark - ......::::::: Edit :::::::......
//if not found, return NSNotFount
- (NSUInteger)indexOfTag:(NSString *)tagName;

//- (void)addTag:(NSString *)tagName;
//- (void)insertTag:(NSString *)tagName AtIndex:(NSUInteger)index;

//- (void)removeTagWithName:(NSString *)tagName;
//- (void)removeTagAtIndex:(NSUInteger)index;
//- (void)removeAllTags;

@end
@protocol FMTagsViewDelegate <NSObject>

@optional
- (BOOL)tagsView:(FMTagsView *)tagsView shouldSelectTagAtIndex:(NSUInteger)index;
- (void)tagsView:(FMTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index;

- (BOOL)tagsView:(FMTagsView *)tagsView shouldDeselectItemAtIndex:(NSUInteger)index;
- (void)tagsView:(FMTagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index;

@end