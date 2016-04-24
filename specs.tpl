*cpp_options:
-nostdinc -isystem BASE/include -isystem include%s %(old_cpp_options)

*cc1:
%(cc1_cpu) -nostdinc -isystem BASE/include -isystem include%s

*link_libgcc:
-LBASE/lib -L .%s

*libgcc:
libgcc.a%s %:if-exists(libgcc_eh.a%s)

*startfile:
%{!shared: BASE/lib/%{pie:S}crt1.o} BASE/lib/crti.o %{shared|pie:crtbeginS.o%s;:crtbegin.o%s}

*endfile:
%{shared|pie:crtendS.o%s;:crtend.o%s} BASE/lib/crtn.o

*link:
-dynamic-linker /lib/ld-musl-x86_64.so.1 -nostdlib %{shared:-shared} %{static:-static} %{rdynamic:-export-dynamic}

*esp_link:


*esp_options:


*esp_cpp_options:


