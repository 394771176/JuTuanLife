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

#define PUSH_VC(_xxx_)  \
{ \
UIViewController *vc = [[_xxx_ alloc] init]; \
[WCControllerUtil pushViewController:vc]; \
}

#define RECT(x, y, w, h)             CGRectMake(x, y, w, h)
#define CREATE_UI(c, x, y, w, h)     [[c alloc] initWithFrame:RECT(x, y, w, h)]
#define CREATE_UI_V(c, x, y, w, h)    c *v = CREATE_UI(c, x, y, w, h)
#define CREATE_UI_VV(v, c, x, y, w, h)  v = CREATE_UI(c, x, y, w, h)

#define CREATE_ITEM(c)              c *item = [c new];

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#endif /* JTDefine_h */
