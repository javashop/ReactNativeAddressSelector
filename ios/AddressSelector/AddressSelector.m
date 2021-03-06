//
//  AddressSelector.m
//  AddressSelector
//
//  Created by LDD on 2017/11/1.
//  Copyright © 2017年 LDD. All rights reserved.
//

#import "AddressSelector.h"
#import "RCTLog.h"
#import "RCTEventDispatcher.h"
#import <UIKit/UIKit.h>
#import <React/RCTRootView.h>
@implementation AddressSelector


//此处不能使用OC的字符串，直接输入就行了
RCT_EXPORT_MODULE(AddressSelectorModule);


//测试方法导出
RCT_EXPORT_METHOD(create:(RCTResponseSenderBlock)callback) {
        self.addressView = [AddressSelectView initWithEvent:^(Region *per, Region *city, Region *region, Region *town) {
        NSString *perStr;
        NSString *cityStr;
        NSString *regionStr;
        NSString *townStr;
        if (per!=nil) {
            NSData *perData=[NSJSONSerialization dataWithJSONObject:[AddressSelectView getObjectData:per] options:NSJSONWritingPrettyPrinted error:nil];
            perStr=[[NSString alloc]initWithData:perData encoding:NSUTF8StringEncoding];
        }else{
            perStr = @"";
        }
        if (city!=nil) {
            NSData *cityData=[NSJSONSerialization dataWithJSONObject:[AddressSelectView getObjectData:city] options:NSJSONWritingPrettyPrinted error:nil];
            cityStr=[[NSString alloc]initWithData:cityData encoding:NSUTF8StringEncoding];
        }else{
            cityStr = @"";
        }
        if (region!=nil) {
            NSData *regionData=[NSJSONSerialization dataWithJSONObject:[AddressSelectView getObjectData:region] options:NSJSONWritingPrettyPrinted error:nil];
            regionStr=[[NSString alloc]initWithData:regionData encoding:NSUTF8StringEncoding];
        }else{
            regionStr = @"";
        }
        if (town!=nil) {
            NSData *townData=[NSJSONSerialization dataWithJSONObject:[AddressSelectView getObjectData:town] options:NSJSONWritingPrettyPrinted error:nil];
            townStr=[[NSString alloc]initWithData:townData encoding:NSUTF8StringEncoding];
        }else{
            townStr = @"";
        }
        callback(@[perStr,cityStr,regionStr,townStr]);
    } setDataSource:^(NSInteger rid, AddressSelectView *asv) {
        [self sendEventWithName:@"AddressDataEvent" body:[NSNumber numberWithInteger:rid]];
    }];
     [self.addressView showView];
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"AddressDataEvent"];
}

- (NSDictionary *)constantsToExport {
   return @{ @"DataEvent": @"AddressDataEvent" };
}

RCT_EXPORT_METHOD(setData:(NSArray*)data){
    if (data==nil || self.addressView==nil) {
        RCTLog(@"视图未初始化，或者数据为空");
        return;
    }
    //RCTLog(@"Native执行");
    NSMutableArray *regionArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in data) {
        Region *region = [Region new];
        region.name = [dic valueForKey:@"name"];
        region.id =  [dic objectForKey:@"id"];
        region.parentId = [dic objectForKey:@"parentId"];
        region.type = [dic objectForKey:@"type"];
        [regionArray addObject:region];
    }
    [self.addressView loadData:regionArray];
}
@end
