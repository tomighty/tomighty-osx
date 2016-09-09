# Building

This is a simple and dirty (very dirty) build script to produce the Tomighty app package
from the command line.

## Running

Simply run build.sh from the build directory. Build artifacts should appear in the `targer`
directory. Existing build artifacts must be deleted before running again.

## Packaging
* Update package.sh to change the VERSION variable to the correct version.
* Run package.sh. Tomighty-VERSION.dmg will be created in the folder `target`

## Other Notes

Right now this doesn't update any application properties before running. Properties (such as version)
need to updated manually before running
