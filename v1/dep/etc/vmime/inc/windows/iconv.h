/***************************************************************************
 *
 * iconv.h - Win32 implementation of the POSIX iconv facility
 *
 * $Id: //stdlib/dev/source/stdlib/util/iconv.h#5 $
 *
 ***************************************************************************
 *
 * Copyright (c) 1994-2005 Quovadx,  Inc., acting through its  Rogue Wave
 * Software division. Licensed under the Apache License, Version 2.0 (the
 * "License");  you may  not use this file except  in compliance with the
 * License.    You    may   obtain   a   copy   of    the   License    at
 * http://www.apache.org/licenses/LICENSE-2.0.    Unless   required    by
 * applicable law  or agreed to  in writing,  software  distributed under
 * the License is distributed on an "AS IS" BASIS,  WITHOUT WARRANTIES OR
 * CONDITIONS OF  ANY KIND, either  express or implied.  See  the License
 * for the specific language governing permissions  and limitations under
 * the License.
 * 
 **************************************************************************/

#if defined (_WIN32) || defined (_WIN64)

#if !defined WIN_ICONV
#define WIN_ICONV

#ifdef __cplusplus
extern "C" {
#endif

typedef int iconv_t;

iconv_t iconv_open (const char*, const char*);
size_t  iconv (iconv_t, char**, size_t*, char**, size_t*);
int     iconv_close (iconv_t);

#ifdef __cplusplus
}
#endif

#endif   // WIN_ICONV
#endif   // _WIN{32,64}
