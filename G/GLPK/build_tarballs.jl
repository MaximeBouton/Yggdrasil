using BinaryBuilder, Pkg

name = "GLPK"
version = v"5.0"

# Collection of sources required to build GLPK
sources = [
    ArchiveSource("http://ftpmirror.gnu.org/gnu/glpk/glpk-$(version.major).$(version.minor).tar.gz",
                  "4a1013eebb50f728fc601bdd833b0b2870333c3b3e5a816eeba921d95bec6f15"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/glpk*
if [[ ${target} == *mingw* ]]; then
    export CPPFLAGS="-I${prefix}/include -D__WOE__=1"
else
    export CPPFLAGS="-I${prefix}/include"
fi
autoreconf -vi
./configure --prefix=${prefix} --host=${target} --build=${MACHTYPE} --with-gmp
make -j${nproc}
make install
"""

# Build for all platforms
platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    LibraryProduct("libglpk", :libglpk)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency("GMP_jll", v"6.1.2"),
]

# Build the tarballs, and possibly a `build.jl` as well.
# Use the same preferred_gcc_version as GMP.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; preferred_gcc_version=v"6")
