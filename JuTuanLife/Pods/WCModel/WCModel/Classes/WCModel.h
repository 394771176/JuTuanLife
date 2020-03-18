//
//  WCModel.h
//  WCModule
//
//  Created by cheng on 2020/3/18.
//

#ifndef WCModel_h
#define WCModel_h

#if __has_include(<WCModel/Entity>)

#import "WCBaseEntity.h"
#import "WCDataResult.h"

#endif

#if __has_include(<WCModel/File>)

#import "BPFileUtil.h"
#import "DTFileManager.h"

#endif

#if __has_include(<WCModel/Plist>)

#import "BPAppPreference.h"
#import "DTAppPreferenceManager.h"
#import "DTTodayManager.h"

#endif

#if __has_include(<WCModel/Cache>)

#import "BPCacheManager.h"
#import "BPLocalManager.h"

#endif

#if __has_include(<WCModel/Model>)

#import "DTListDataModel.h"
#import "DTPosListDataModel.h"

#endif

#endif /* WCModel_h */
