echo "--- Sync"
cd /stx
rm -rf .repo/local_manifests
repo sync --force-sync --no-clone-bundle --current-branch --no-tags -j$(nproc --all)
echo "--- Build setup"
. build/envsetup.sh
lunch statix_$DEVICE-$BUILDTYPE
echo "--- Build"
m bacon
echo "--- Upload Build (OTA Server, then SourceForge)"
rsync --progress -a --include "statix_$DEVICE-*-$STATIX_BUILD_TYPE.zip" --exclude "*" out/target/product/$DEVICE/ downloads@downloads.statixos.com:/home/downloads/11/$DEVICE
rsync --progress -a --include "statix_$DEVICE-*-$STATIX_BUILD_TYPE.zip" --exclude "*" out/target/product/$DEVICE/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11/$DEVICE/
echo "--- Sanitize outdir (deviceclean)"
m deviceclean
