//
//  WMLSerializable.h
//  Weaver
//
//  Created by lianyu on 2018/12/12.
//  Copyright © 2018 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 表示支持序列化配置的协议。
 */
@protocol WMLSerializableProtocol <NSObject>

@optional

/**
 在对象被反序列化后调用，可以用来在反序列化后执行检查等工作。
 */
- (void)onDeserialization;

/**
 返回指定属性的字符串描述，可以重写以提供自定义的 description 逻辑。
 */
- (NSString * _Nullable)getPropertyDescription:(NSString * _Nonnull)propertyName withValue:(id _Nullable)value;

/**
 默认是通过字典的键和属性的名字进行一一映射，如果某些键与属性名不是对应的，可以通过重写该方法来映射。

 @return 映射的字典, 其中 key 值为属性名称，value 值为字典的键名，支持 keyPath。
 
 示例:
 DemoObject:
 @property homeAddress;
 @property phone;
 
 DemoDictionary:
 {
   home_address:XXX,
   contact:{phone:XXX, email:XXX}
 }

 完成上述转换，只需要返回如下字典:
 {
   @"homeAddress" : @"home_address"
   @"phone"       : @"contact.phone"
 }
 */
+ (NSDictionary<NSString *, NSString *> * _Nullable)propertyKeyPath;

/**
 当作为字典、数组的值使用时，要将字典的键、数组的索引映射到的属性。
 仅在反序列化时生效。
 */
+ (NSString * _Nullable)containerKeyProperty;

/**
 如果某些属性是数组或字典，且里面的元素也可被序列化，需要通过重写该方法来指定元素的类型。

 @return 数组元素或字典的值对应的可序列化类，键为属性名，值为类名。
 
 示例:
 DemoObject:
 @property NSArray<MyContact *> * contacts;
 
 DemoDictionary:
 {
   contacts:[{phone:XXX, email:XXX}]
 }
 
 完成上述转换，只需要返回如下字典:
 {
   @"phone" : [MyContact class],
 }
 */
+ (NSDictionary<NSString *, Class> * _Nullable)propertySubClass;

@end

#pragma mark - WMLSerializable

/**
 为任意对象提供序列化功能。
 */
@interface WMLSerializable : NSObject

/**
 浅复制指定对象。
 */
+ (id _Nonnull)shallowCopy:(id _Nonnull)object withZone:(NSZone * _Nonnull)zone;

/**
 将指定对象序列化为字典。

 @return 序列化的结果。
 */
+ (NSMutableDictionary * _Nonnull)serialize:(id _Nonnull)object;

/**
 将字典反序列化到指定对象。
 */
+ (void)deserialize:(NSDictionary * _Nullable)dictionary toObject:(id _Nonnull)object;

/**
 将字典反序列化到指定类型。
 */
+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dictionary toClass:(Class _Nonnull)clazz;

/**
 返回指定对象的描述。
 */
+ (NSString * _Nonnull)description:(id _Nonnull)object;

@end
