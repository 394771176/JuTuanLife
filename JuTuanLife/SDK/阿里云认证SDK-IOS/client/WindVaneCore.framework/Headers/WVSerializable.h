/*
 * WVSerializable.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 * 表示支持序列化的协议。
 */
@protocol WVSerializableProtocol <NSObject>

@optional

/**
 * 在被反序列化后调用。
 */
- (void)onDeserialization;

/**
 * 返回指定属性的字符串描述。
 */
- (NSString *)dumpProperty:(NSString *)propertyName withValue:(id)value maxLength:(NSUInteger)length;

/**
 * 默认是通过字典的键和属性的名字进行一一映射，
 * 如果某些键与属性名不是对应的，可以通过重写该方法来映射。
 *
 * @return 映射的字典, 其中 key 值为字典的键名，value 值为对应属性的 keyPath。
 * 示例:
 * DemoObject:                      DemoDictionary:
 *                                  {
 * @property name;                  name:XXX,
 * @property homeAddress;  =====>   home_address:XXX,
 * @property phone;                 contact:{phone:XXX, email:XXX}
 *                                  }
 *
 * 完成上述转换，只需要返回如下字典:
 * {
 *   @"home_address" : @"homeAddress",
 *   @"phone"        : @"contact.phone"
 * }
 */
+ (NSDictionary<NSString *, NSString *> *)keyPathsForProperties;

/**
 * 当作为字典、数组的值使用时，要将字典的键、数组的索引映射到的属性。
 * 仅在反序列化时生效。
 */
+ (NSString *)containerKeyForProperty;

/**
 * 如果某些属性是数组或字典，且里面的元素也可被序列化，需要通过重写该方法来指定元素的类型。
 *
 * @return 数组元素或字典的值对应的可序列化类，键为属性名，值为。
 */
+ (NSDictionary<NSString *, Class> *)subClassForProperties;

@end

#pragma mark - NSObject (WVSerializable)

/**
 * 表示对任意对象的序列化支持。
 */
@interface NSObject (WVSerializable)

/**
 * 复制当前对象。
 */
- (id)wvCopyWithZone:(NSZone *)zone;

/**
 * 将当前对象序列化为字典。
 *
 * @return 序列化的结果。
 */
- (NSMutableDictionary *)wvSerializeToDictionary;

/**
 * 将当前对象序列化为指定基类的字典。
 *
 * @param superClass 当前类型的基类，将按照基类的规范进行序列化。
 *
 * @return 序列化的结果。
 */
- (NSMutableDictionary *)wvSerializeToDictionaryAsSuperClass:(Class)superClass;

/**
 * 将当前对象从指定字典反序列化。
 */
- (void)wvDeserializeWithDictionary:(NSDictionary *)dictionary;

/**
 * 将当前对象从指定字典反序列化。
 */
- (void)wvDeserializeWithDictionary:(NSDictionary *)dictionary withContainerKey:(id)containerKey;

/**
 * 将指定字典反序列化为当前类型。
 *
 * @param dictionary 用于反序列化的字典。
 *
 * @return 反序列化后的实例。
 */
+ (id)wvDeserializeWithDictionary:(NSDictionary *)dictionary;

/**
 * 将指定字典反序列化为当前类型。
 *
 * @param dictionary   用于反序列化的字典。
 * @param containerKey 作为容器的键的值。
 *
 * @return 反序列化后的实例。
 */
+ (id)wvDeserializeWithDictionary:(NSDictionary *)dictionary withContainerKey:(id)containerKey;

/**
 * 返回当前对象的描述。
 */
- (NSString *)wvDumpDescription;

/**
 * 返回当前对象的描述。
 */
- (NSString *)wvDumpDescriptionWithMaxValueLength:(NSUInteger)length withIndent:(int)indent;

@end

#pragma mark - NSMutableDictionary (WVSerializable)

/**
 * 表示对字典的序列化支持。
 */
@interface NSMutableDictionary (WVSerializable)

/**
 * 将当前对象从指定字典反序列化。
 */
- (void)wvDeserializeWithDictionary:(NSDictionary *)dictionary withSubClass:(Class)subClass;

/**
 * 将指定字典反序列化为当前类型。
 *
 * @param dictionary 用于反序列化的字典。
 *
 * @return 反序列化后的实例。
 */
+ (NSMutableDictionary *)wvDeserializeWithDictionary:(NSDictionary *)dictionary withSubClass:(Class)subClass;

@end
