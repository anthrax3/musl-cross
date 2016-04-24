#!/bin/bash

sudo rm -fr /opt/musl-cross
sudo mkdir -p /opt/musl-cross
sudo chmod 777 /opt/musl-cross

export MAKEFLAGS=-j4
export GCC_BUILTIN_PREREQS=yes
export CC_PREFIX=/opt/musl-cross
export CFLAGS=-fPIE
export GCC_STAGE1_NOOPT=1

export MUSL_DEFAULT_VERSION=1.1.14
export MUSL_VERSION=git-247c642a
export MUSL_GIT_VERSION=247c642
export MUSL_GIT_REPO='https://github.com/acammack-r7/musl'
export MUSL_GIT=no

build() {
	./clean.sh && ./build.sh
	PREFIX_ESC=$(sed 's/[]\/$*.^|[]/\\&/g' <<<"$CC_PREFIX/$1")
	$CC_PREFIX/bin/$1-gcc -dumpspecs | sed -e '/cpp_options/ { N; N; d; }' > $CC_PREFIX/lib/gcc/$1/5.3.0/specs
	sed "s/BASE/$PREFIX_ESC/g" specs.tpl >> $CC_PREFIX/lib/gcc/$1/5.3.0/specs
}

export ARCH=i486
build $ARCH-linux-musl

export ARCH=x86_64
build $ARCH-linux-musl

export ARCH=powerpc
build $ARCH-linux-musl

export ARCH=arm
export TRIPLE=arm-linux-musleabihf
export GCC_BOOTSTRAP_CONFFLAGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"
export GCC_CONFFLAGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"
build $TRIPLE
unset TRIPLE
unset GCC_BOOTSTRAP_CONFFLAGS
unset GCC_CONFFLAGS

export ARCH=arm
export TRIPLE=arm-linux-musleabi
export GCC_BOOTSTRAP_CONFFLAGS="--with-arch=armv7-a --with-float=softfp"
export GCC_CONFFLAGS="--with-arch=armv7-a --with-float=softfp"
build $TRIPLE
unset TRIPLE
unset GCC_BOOTSTRAP_CONFFLAGS
unset GCC_CONFFLAGS

export ARCH=mips
build $ARCH-linux-musl

export ARCH=mipsel
build $ARCH-linux-musl

rm -fr musl-cross
cp -a /opt/musl-cross .
chmod 755 musl-cross

find musl-cross/bin -type f -executable |xargs strip
find musl-cross/libexec -type f -executable |xargs strip

XZ_OPT=-9 tar cavf musl-cross.tar.xz musl-cross
