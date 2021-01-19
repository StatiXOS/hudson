echo "--- Sync"
cd /stx
rm -rf .repo/local_manifests
repo sync -d -c --force-sync --no-tags --no-clone-bundle -f -j8
echo "--- Build setup"
. build/envsetup.sh
echo "--- Sanitize outdir"
lunch statix_$DEVICE-$BUILDTYPE
m installclean
echo "--- Build"
m bacon
echo "--- Upload"
rsync --progress -a --include "statix_$DEVICE-*-$STATIX_BUILD_TYPE.zip" --exclude "*" out/target/product/$DEVICE/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11/$DEVICE/
