#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "xshelper.h"

/* split on "=".
   *key contains the key, &key_len contains the length,
   *value contains the value, &valye_len contains the length.
   if "=" is not found, key = the string, value = ''
*/
STATIC_INLINE
void
split_kv(char *start, char *end, char **key, size_t *key_len, char **value, size_t *value_len) {
    char *cur = start;
    int found_eq = 0;
    while (cur != end) {
        if (*cur == '=') {
            found_eq = 1;
            *key = start;
            *key_len = cur - start;
            cur++;
            break;
        }
        cur++;
    }
    if (found_eq) {
        *value = cur;
        *value_len = end - cur;
    } else {
        *key = start;
        *key_len = end - start;
        *value_len = 0;
    }
}

MODULE = Text::QueryString     PACKAGE = Text::QueryString

PROTOTYPES: DISABLE

void
parse(self, qs)
        SV *self;
        char *qs;
    PREINIT:
        char *cur = qs;
        char *prev = qs;
        char *key, *value;
        size_t key_len, value_len;
    PPCODE:
        PERL_UNUSED_VAR(self);
        if (qs == NULL) { /* sanity */
            XSRETURN(0);
        }

        /* First, chop chop until end of string or & or ; */
        while (*cur != '\0') {
            if (*cur == '&' || *cur == ';') {
                /* found end of this pair. look for an = sign */
                split_kv(prev, cur, &key, &key_len, &value, &value_len);
                /* XXX decode first */
                mXPUSHp(key, key_len);
                mXPUSHp(value, value_len);
                cur++;
                prev = cur;
            } else {
                cur++;
            }
        }

        /* do we have something leftover? */
        if (prev != cur) {
            split_kv(prev, cur, &key, &key_len, &value, &value_len);
            mXPUSHp(key, key_len);
            mXPUSHp(value, value_len);
        }


