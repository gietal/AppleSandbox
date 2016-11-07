#include <wctype.h>
#include <stdint.h>

#include <xlocale.h>
#include <assert.h>
#include <stdarg.h>
extern const int __wc16_wchar_check[ sizeof(wchar_t) / (sizeof(wchar_t) == 2) ];

#if defined(_WCHAR_H_)
    #error "wchar.h must not be included here"
#endif

//Unimplemented fake functions that will trigger link error if anyone tries to link with 4-byte wchar_t APIs below.
#define NOT_IMPLEMENTED(api)    InvalidAttemptToLinkWith4ByteWchar_##api ()
#define BANNED_STRING_API(api)  InvalidAttemptToUseBannedStringAPI_##api ()

#define LOCAL_API  __attribute__ ((visibility ("hidden")))

extern "C"
{
    /**/
    void NOT_IMPLEMENTED(foo);
    LOCAL_API int foo(int n) { NOT_IMPLEMENTED(foo); return 0; }
    
    void NOT_IMPLEMENTED(wmemcmp);
    LOCAL_API int wmemcmp(const wchar_t * src1, const wchar_t * src2, size_t n) { NOT_IMPLEMENTED(wmemcmp); return 0; }
}
