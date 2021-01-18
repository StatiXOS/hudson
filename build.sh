echo "--- Sync"
repo init --depth=1 -u https://github.com/StatiXOS/android_manifest.git -b 11
rm -rf .repo/local_manifests
repo sync -d -c --force-sync --no-tags --no-clone-bundle -f -j8
repo forall -vc "git reset --hard HEAD"
echo "--- Clean"
make clean
make clobber
echo "--- Build"
. build/envsetup.sh
lunch statix_$DEVICE-$BUILDTYPE
m bacon
echo "--- Upload"
rsync --progress -a --include "statix_$DEVICE-*-$STATIX_BUILD_TYPE.zip" --exclude "*" out/target/product/$DEVICE/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11/$DEVICE/
