AC_DEFUN([PDNS_WITH_LIBSSL], [
  AC_MSG_CHECKING([whether we will be linking in OpenSSL libssl])
  HAVE_LIBSSL=0
  AC_ARG_WITH([libssl],
    AS_HELP_STRING([--with-libssl],[use OpenSSL libssl @<:@default=auto@:>@]),
    [with_libssl=$withval],
    [with_libssl=auto],
  )
  AC_MSG_RESULT([$with_libssl])

  AS_IF([test "x$with_libssl" != "xno"], [
    AS_IF([test "x$with_libssl" = "xyes" -o "x$with_libssl" = "xauto"], [
      PKG_CHECK_MODULES([LIBSSL], [libssl], [
        [HAVE_LIBSSL=1]
        AC_DEFINE([HAVE_LIBSSL], [1], [Define to 1 if you have OpenSSL libssl])
        save_CFLAGS=$CFLAGS
        save_LIBS=$LIBS
        CFLAGS="$LIBSSL_CFLAGS $CFLAGS"
        LIBS="$LIBSSL_LIBS -lcrypto $LIBS"
        AC_CHECK_FUNCS([SSL_CTX_set_ciphersuites OCSP_basic_sign SSL_CTX_set_num_tickets SSL_CTX_set_keylog_callback SSL_CTX_get0_privatekey SSL_CTX_set_min_proto_version SSL_set_hostflags SSL_CTX_set_alpn_protos SSL_CTX_set_next_proto_select_cb SSL_get0_alpn_selected SSL_get0_next_proto_negotiated SSL_CTX_set_alpn_select_cb])
        CFLAGS=$save_CFLAGS
        LIBS=$save_LIBS

      ], [ : ])
    ])
  ])
  AM_CONDITIONAL([HAVE_LIBSSL], [test "x$LIBSSL_LIBS" != "x"])
  AS_IF([test "x$with_libssl" = "xyes"], [
    AS_IF([test x"$LIBSSL_LIBS" = "x"], [
      AC_MSG_ERROR([OpenSSL libssl requested but libraries were not found])
    ])
  ])
])
