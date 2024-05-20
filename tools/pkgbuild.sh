#!/bin/sh
set -e

BASEDIR=$(readlink -f "$(dirname "$0")/..")

pkgbuild_command=
pkgbuild_name=

pkgbuild_builddir=
pkgbuild_pkgdir=
pkgbuild_source_name=
pkgbuild_srcdir=
pkgbuild_tarball_name=
pkgbuild_tarball_url=

info() {
    echo "\e[36m[INFO] $1\e[m"
}

error() {
    echo "\e[31m[ERROR] $1\e[m"
    exit 1
}

validate_empty() {
    [ ! -z "$1" ] || error "${2:-"Validation failed"}"
}

parse_params() {
    pkgbuild_name=$1;
    validate_empty "$pkgbuild_name" "No package name parameter provided"

    pkgbuild_pkgdir=$BASEDIR/pkgs/$pkgbuild_name
    [ -d "$pkgbuild_pkgdir" ] || error "Package $pkgbuild_name not found"
    [ -f "$pkgbuild_pkgdir/pkgbuild" ] || error "Package $pkgbuild_name pkgbuild file not found"

    pkgbuild_command=${2:-build};
    case $pkgbuild_command in
    build|install) ;;
    *)
        error "Unknown command $pkgbuild_command"
    esac

    pkgbuild_builddir=$pkgbuild_pkgdir/.build
    pkgbuild_srcdir=$pkgbuild_pkgdir/.src
    pkgbuild_outdir=$pkgbuild_pkgdir/.out
}

parse_pkgbuild() {
    . $pkgbuild_pkgdir/pkgbuild

    validate_empty "$pkgbuild_tarball_url" "Package $pkgbuild_name pkgbuild file doesn't define pkgbuild_tarball_url"

    command -v pkgbuild_build >/dev/null 2>&1 || error "Package $pkgbuild_name pkgbuild file doesn't define pkgbuild_build"
    command -v pkgbuild_install >/dev/null 2>&1 || error "Package $pkgbuild_name pkgbuild file doesn't define pkgbuild_install"
}

prepare_sources() {
    if [ ! -d "$pkgbuild_pkgdir/.src" ] || ! (cd "$pkgbuild_pkgdir" && sha512sum -c $pkgbuild_pkgdir/sources.sha512sum >/dev/null 2>&1); then
        info "Downloading $pkgbuild_name sources..."
        local tarball=$pkgbuild_srcdir/$pkgbuild_tarball_name
        mkdir -p $pkgbuild_srcdir
        wget -q -O $tarball $pkgbuild_tarball_url
        tar -xf $tarball -C $pkgbuild_srcdir
    fi
}

build_sources() {
    info "Building $pkgbuild_name..."
    (cd $pkgbuild_pkgdir && pkgbuild_build)
}

install_package() {
    info "Installing $pkgbuild_name..."
    (cd $pkgbuild_pkgdir && pkgbuild_install)
}

parse_params "$@"
parse_pkgbuild

prepare_sources

case $pkgbuild_command in
    build)
        build_sources;;
    install)
        build_sources
        install_package;;
esac
