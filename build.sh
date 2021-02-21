echo "--- Sync"
cd /stx
rm -rf .repo/local_manifests
repo sync --force-sync --no-clone-bundle --current-branch --no-tags -j$(nproc --all)
echo "--- Build setup"
. build/envsetup.sh
lunch statix_$DEVICE-$BUILDTYPE
echo "--- Build"
m bacon

if [[ "$FASTBOOTIMAGES" == "true" ]];
then
    echo "--- Build fastbootimages"
    m updatepackage
fi

echo "--- Upload Build (OTA Server, then SourceForge)"
rsync --progress -a --include "statix_$DEVICE-*-$STATIX_BUILD_TYPE.zip" --exclude "*" $OUT/ downloads@downloads.statixos.com:/home/downloads/11/$DEVICE
rsync --progress -a --include "statix_$DEVICE-*-$STATIX_BUILD_TYPE.zip" --exclude "*" $OUT/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11/$DEVICE/

echo "--- Upload Boot Image (OTA Server, then SourceForge)"
mv $OUT/boot.img $OUT/boot-$DEVICE-$DATE.img
rsync --progress -a --include "boot-$DEVICE-$DATE.img" --exclude "*" $OUT/ downloads@downloads.statixos.com:/home/downloads/11/$DEVICE/bootimages
rsync --progress -a --include "boot-$DEVICE-$DATE.img" --exclude "*" $OUT/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11/$DEVICE/bootimages

if [[ "$FASTBOOTIMAGES" == "true" ]];
then
    echo "--- Upload Fastbootimages (OTA Server, then SourceForge)"
    mv $OUT/statix_$DEVICE-img-eng.buildkite-agent.zip $OUT/statix_$DEVICE-$DATE-img.zip
    rsync --progress -a --include "statix_$DEVICE-$DATE-img.zip" --exclude "*" $OUT/ downloads@downloads.statixos.com:/home/downloads/11/$DEVICE/fastbootimages
    rsync --progress -a --include "statix_$DEVICE-$DATE-img.zip" --exclude "*" $OUT/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11/$DEVICE/fastbootimages
fi

if [[ "$RECOVERY" == "true" ]] && [ -f "$OUT/recovery.img" ];
then
    echo "--- Upload Recovery (OTA Server, then SourceForge)"
    mv $OUT/recovery.img $OUT/recovery-$DEVICE-$DATE.img
    rsync --progress -a --include "recovery-$DEVICE-$DATE.img" --exclude "*" $OUT/ downloads@downloads.statixos.com:/home/downloads/11/$DEVICE/recoveries
    rsync --progress -a --include "recovery-$DEVICE-$DATE.img" --exclude "*" $OUT/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11/$DEVICE/recoveries
fi

echo "--- Sanitize outdir (deviceclean)"
m deviceclean
