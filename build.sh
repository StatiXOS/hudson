echo "--- Build setup"
cd /stx
. build/envsetup.sh
lunch statix_$DEVICE-$BUILDTYPE
echo "--- Pick"
set -e
if [[ ! -z "${REPOPICK}" ]]; then repopick -f ${REPOPICK}; else echo "No Commits to pick!"; fi
echo "--- Build"
if [[ "$CLEAN" == "true" ]];
then
    m clean
fi
m bacon

if [[ "$FASTBOOTIMAGES" == "true" ]];
then
    echo "--- Build fastbootimages"
    m updatepackage
fi

echo "--- Upload Build (OTA Server, then SourceForge)"
rsync --progress -a --include "statix_$DEVICE-*-$STATIX_BUILD_TYPE.zip" --exclude "*" $OUT/ downloads@downloads.statixos.com:/home/downloads/11-$STATIX_BUILD_TYPE/$DEVICE
rsync --progress -a --include "statix_$DEVICE-*-$STATIX_BUILD_TYPE.zip" --exclude "*" $OUT/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11-$STATIX_BUILD_TYPE/$DEVICE/

echo "--- Upload Boot Image (OTA Server, then SourceForge)"
mv $OUT/boot.img $OUT/boot-$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE.img
rsync --progress -a --include "boot-$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE.img" --exclude "*" $OUT/ downloads@downloads.statixos.com:/home/downloads/11-$STATIX_BUILD_TYPE/$DEVICE/bootimages
rsync --progress -a --include "boot-$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE.img" --exclude "*" $OUT/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11-$STATIX_BUILD_TYPE/$DEVICE/bootimages

if [[ "$FASTBOOTIMAGES" == "true" ]];
then
    echo "--- Upload Fastbootimages (OTA Server, then SourceForge)"
    mv $OUT/statix_$DEVICE-img-eng.buildkite-agent.zip $OUT/statix_$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE-img.zip
    rsync --progress -a --include "statix_$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE-img.zip" --exclude "*" $OUT/ downloads@downloads.statixos.com:/home/downloads/11-$STATIX_BUILD_TYPE/$DEVICE/fastbootimages
    rsync --progress -a --include "statix_$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE-img.zip" --exclude "*" $OUT/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11-$STATIX_BUILD_TYPE/$DEVICE/fastbootimages
fi

if [[ "$RECOVERY" == "true" ]] && [ -f "$OUT/recovery.img" ];
then
    echo "--- Upload Recovery (OTA Server, then SourceForge)"
    mv $OUT/recovery.img $OUT/recovery-$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE.img
    rsync --progress -a --include "recovery-$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE.img" --exclude "*" $OUT/ downloads@downloads.statixos.com:/home/downloads/11-$STATIX_BUILD_TYPE/$DEVICE/recoveries
    rsync --progress -a --include "recovery-$DEVICE-$(date +%Y%m%d)-$STATIX_BUILD_TYPE.img" --exclude "*" $OUT/ deletthiskthx@frs.sourceforge.net:/home/pfs/project/statixos/11-$STATIX_BUILD_TYPE/$DEVICE/recoveries
fi

echo "--- Sanitize outdir (deviceclean)"
m deviceclean
