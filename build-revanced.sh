#!/bin/bash
#set -x
get_latest_release() {
    echo "downloading ${1}..."
    curl -s  "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"browser_download_url":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' |                                    # Pluck JSON value
    xargs wget -N -o wget_log_$2.txt
}


get_latest_release revanced/revanced-integrations 1
REVANCED_INTEGRATIONS=`ls -rv app-release-unsigned.apk* | head -1`
echo -e "$REVANCED_INTEGRATIONS \n"

get_latest_release revanced/revanced-patches 2
REVANCED_PATCHES=`ls -rv revanced-patches-* | head -1`
echo -e "$REVANCED_PATCHES \n"

get_latest_release revanced/revanced-cli 3
REVANCED_CLI=`ls -rv revanced-cli-* | head -1`
echo -e "$REVANCED_CLI \n"


YOUTUBE=`ls -rv youtube*.apk | head -1`
YOUTUBE_MUSIC=`ls -rv music*.apk | head -1`
echo -e "using $YOUTUBE and $YOUTUBE_MUSIC apks as base apks\n"


YOUTUBE_VERSION=${1:-$(echo $YOUTUBE | sed -E 's/youtube-(.*).apk/\1/')-$(echo $REVANCED_PATCHES | sed -E 's/revanced-patches-(.*).jar/\1/')}

MUSIC_VERSION=${2:-$(echo $YOUTUBE_MUSIC | sed -E 's/music-(.*).apk/\1/')-$(echo $REVANCED_PATCHES | sed -E 's/revanced-patches-(.*).jar/\1/')}

#<<comment
echo "building rv-youtube-${YOUTUBE_VERSION:-NA}.apk..."

#set -x
java \
-jar $REVANCED_CLI \
-a $YOUTUBE \
-c \
-o rv-youtube-${YOUTUBE_VERSION:-NA}.apk \
-b $REVANCED_PATCHES \
-m $REVANCED_INTEGRATIONS \
--exclusive \
-i seekbar-tapping \
-i hide-cast-button \
-i hide-create-button \
-i hide-shorts-button \
-i return-youtube-dislike \
-i premium-heading \
-i disable-fullscreen-panels \
-i old-quality-layout \
-i theme \
-i hide-watermark \
-i sponsorblock \
-i disable-auto-player-popup-panels \
-i tablet-mini-player \
-i minimized-playback \
-i client-spoof \
-i microg-support \
-i settings \
-i custom-playback-speed \
-i hdr-auto-brightness \
-i remember-video-quality \
-i video-ads \
-i general-ads \
-i hide-infocard-suggestions    
#set +x
#comment

echo -e "\n"

#<<comment
echo "building rv-youtube-music-${MUSIC_VERSION:-NA}.apk..."
#set -x
java \
-jar $REVANCED_CLI \
-a $YOUTUBE_MUSIC \
-c \
-o rv-youtube-music-${MUSIC_VERSION:-NA}.apk \
-b $REVANCED_PATCHES \
-m $REVANCED_INTEGRATIONS \
--exclusive \
-i minimized-playback-music \
-i hide-get-premium \
-i upgrade-button-remover \
-i background-play \
-i music-microg-support \
-i music-video-ads \
-i codecs-unlock \
-i exclusive-audio-playback
#set +x
#comment
