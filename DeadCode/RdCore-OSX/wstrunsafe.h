//
//  wstrunsafe.hpp
//  RdCore-OSX
//
//  Created by Gieta Laksmana on 9/29/16.
//  Copyright © 2016 gietal. All rights reserved.
//

#ifndef wstrunsafe_h
#define wstrunsafe_h

#if __cplusplus
extern "C" {
#endif
    int vswprintf(
              wchar_t *ws,
              size_t n,
              const wchar_t *format,
              va_list argList
              );
#if __cplusplus
}
#endif

#endif /* wstrunsafe_hpp */
