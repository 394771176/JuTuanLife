//
//  JTDefine.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/3.
//  Copyright © 2020 cheng. All rights reserved.
//

#ifndef JTDefine_h
#define JTDefine_h

#define CELL(_cellClass)  \
static NSString *identifier = @#_cellClass; \
_cellClass *cell = [tableView dequeueReusableCellWithIdentifier:identifier]; \
if (!cell) { \
    cell = [[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]; \
}

#define CELL_H(_cellClass)  \
[_cellClass cellHeightWithItem:nil tableView:tableView];

#define CREATE_UI(c, x, y, w, h)     [[c alloc] initWithFrame:RECT(x, y, w, h)]
#define CREATE_UI_V(c, x, y, w, h)    c *v = CREATE_UI(c, x, y, w, h)
#define CREATE_UI_VV(v, c, x, y, w, h)  v = CREATE_UI(c, x, y, w, h)

#define CREATE_ITEM(c)              c *item = [c new];

#define KEY(str)        static NSString * const str = @#str;

//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif

#ifdef DEBUG

#define NSLog(format, ...)  printf("class: <%p %s:(%d) > method: %s \n%s\n", \
self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], \
__LINE__, __PRETTY_FUNCTION__, \
[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

#else

#define NSLog(...) {}

#endif

#endif /* JTDefine_h */
