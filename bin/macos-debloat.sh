#!/bin/sh
# debloat.sh — disable unnecessary macOS services
#
# SAFETY: preserves iCloud, TimeMachine, AirPlay, Handoff,
#         ScreenSharing, FindMy (entries commented out below).
#
# SIP required for system daemons (second block) to persist across reboot.
# Modifications written to /private/var/db/com.apple.xpc.launchd/disabled*.plist
# Revert: sudo rm /private/var/db/com.apple.xpc.launchd/disabled*.plist && reboot
#
# Credit: pwnsdx https://gist.github.com/pwnsdx/d87b034c4c0210b988040ad2f85a68d3

set -eu

_disable_user() {
  launchctl bootout "gui/501/${1}" 2>/dev/null || true
  launchctl disable "gui/501/${1}"
}

_disable_sys() {
  sudo launchctl bootout "system/${1}" 2>/dev/null || true
  sudo launchctl disable "system/${1}"
}

# Iterate helpers — accept service names as arguments
_disable_users() {
  for _s in "$@"; do _disable_user "$_s"; done
}

_disable_systems() {
  for _s in "$@"; do _disable_sys "$_s"; done
}

# ══════════════════════════════════════════════════════════════════
# USER AGENTS (gui/501)
# ══════════════════════════════════════════════════════════════════

# -- Accessibility --
_disable_users \
  'com.apple.accessibility.MotionTrackingAgent' \
  'com.apple.accessibility.axassetsd' \
  'com.apple.universalaccessd'

# -- Advertising / privacy --
_disable_users \
  'com.apple.ap.adprivacyd' \
  'com.apple.ap.promotedcontentd'

# -- Analytics / usage tracking --
_disable_users \
  'com.apple.audioanalyticsd' \
  'com.apple.inputanalyticsd' \
  'com.apple.UsageTrackingAgent'

# -- Assistant / Siri / AI --
_disable_users \
  'com.apple.assistant_service' \
  'com.apple.assistantd' \
  'com.apple.assistant_cdmd' \
  'com.apple.siriactionsd' \
  'com.apple.Siri.agent' \
  'com.apple.siriinferenced' \
  'com.apple.sirittsd' \
  'com.apple.SiriTTSTrainingAgent' \
  'com.apple.macos.studentd' \
  'com.apple.siriknowledged' \
  'com.apple.generativeexperiencesd' \
  'com.apple.intelligenceflowd' \
  'com.apple.intelligencecontextd' \
  'com.apple.intelligenceplatformd' \
  'com.apple.naturallanguaged'

# -- Biome --
_disable_users \
  'com.apple.BiomeAgent' \
  'com.apple.biomesyncd'

# -- Calendar / Contacts / Reminders --
_disable_users \
  'com.apple.calaccessd' \
  'com.apple.CallHistoryPluginHelper' \
  'com.apple.remindd'

# -- Cloud / iCloud (iCloud: preserved) --
#_disable_users \
#  'com.apple.cloudd' \
#  'com.apple.cloudpaird' \
#  'com.apple.cloudphotod' \
#  'com.apple.CloudSettingsSyncAgent' \
#  'com.apple.iCloudNotificationAgent' \
#  'com.apple.icloudmailagent' \
#  'com.apple.iCloudUserNotifications' \
#  'com.apple.icloud.searchpartyuseragent' \
#  'com.apple.protectedcloudstorage.protectedcloudkeysyncing'

# -- Keychain proxy --
_disable_users \
  'com.apple.security.cloudkeychainproxy3'

# -- Data access / sync --
_disable_users \
  'com.apple.campo' \
  'com.apple.chronod' \
  'com.apple.dataaccess.dataaccessd' \
  'com.apple.duetexpertd' \
  'com.apple.financed'

# -- FaceTime / iMessage / Telephony --
_disable_users \
  'com.apple.avconferenced' \
  'com.apple.imagent' \
  'com.apple.imautomatichistorydeletionagent' \
  'com.apple.imtransferagent' \
  'com.apple.telephonyutilities.callservicesd'

# -- Family --
_disable_users \
  'com.apple.familycircled' \
  'com.apple.familycontrols.useragent' \
  'com.apple.familynotificationd'

# -- FindMy (preserved) --
#_disable_users \
#  'com.apple.findmy.findmylocateagent'

# -- Follow-up / Tips --
_disable_users \
  'com.apple.followupd' \
  'com.apple.tipsd'

# -- Game Center --
_disable_users \
  'com.apple.gamed'

# -- Geo / Maps / Navigation / Routing --
_disable_users \
  'com.apple.geoanalyticsd' \
  'com.apple.geodMachServiceBridge' \
  'com.apple.Maps.pushdaemon' \
  'com.apple.Maps.mapssyncd' \
  'com.apple.maps.destinationd' \
  'com.apple.navd' \
  'com.apple.routined'

# -- Help --
_disable_users \
  'com.apple.helpd'

# -- HomeKit --
_disable_users \
  'com.apple.homed'

# -- iTunes / Music / TV / Podcasts --
_disable_users \
  'com.apple.itunescloudd' \
  'com.apple.videosubscriptionsd' \
  'com.apple.watchlistd'

# -- Knowledge / Suggestions --
_disable_users \
  'com.apple.knowledge-agent' \
  'com.apple.knowledgeconstructiond' \
  'com.apple.suggestd' \
  'com.apple.parsecd' \
  'com.apple.parsec-fbf'

# -- Location --
_disable_users \
  'com.apple.CoreLocationAgent'

# -- Managed / MDM --
_disable_users \
  'com.apple.ManagedClientAgent.enrollagent'

# -- Media analysis / Photos --
_disable_users \
  'com.apple.mediaanalysisd' \
  'com.apple.mediastream.mstreamd' \
  'com.apple.photoanalysisd' \
  'com.apple.photolibraryd'

# -- News --
_disable_users \
  'com.apple.newsd'

# -- Passbook / Wallet --
_disable_users \
  'com.apple.passd'

# -- Progress reporting --
_disable_users \
  'com.apple.progressd'

# -- QuickLook --
_disable_users \
  'com.apple.quicklook' \
  'com.apple.quicklook.ui.helper' \
  'com.apple.quicklook.ThumbnailsAgent'

# -- Screen Time --
_disable_users \
  'com.apple.ScreenTimeAgent' \
  'com.apple.SSInvitationAgent'

# -- ScreenSharing (preserved) --
#_disable_users \
#  'com.apple.screensharing.agent' \
#  'com.apple.screensharing.menuextra' \
#  'com.apple.screensharing.MessagesAgent'

# -- Sharing / AirDrop / AirPlay / Handoff (preserved) --
#_disable_users \
#  'com.apple.sharingd' \
#  'com.apple.rapportd-user'

# -- Sidecar --
_disable_users \
  'com.apple.sidecar-hid-relay' \
  'com.apple.sidecar-relay'

# -- Speech / CoreSpeech --
_disable_users \
  'com.apple.corespeechd'

# -- TimeMachine (preserved) --
#_disable_users \
#  'com.apple.TMHelperAgent'

# -- Trials / A/B testing --
_disable_users \
  'com.apple.triald'

# -- Voice banking --
_disable_users \
  'com.apple.voicebankingd'

# -- Weather --
_disable_users \
  'com.apple.weatherd'

# -- OTA update agent --
_disable_users \
  'com.apple.CommCenter-osx'

# ══════════════════════════════════════════════════════════════════
# SYSTEM DAEMONS  (require SIP off to persist across reboot)
# ══════════════════════════════════════════════════════════════════

# -- Analytics --
_disable_systems \
  'com.apple.analyticsd' \
  'com.apple.ecosystemanalyticsd' \
  'com.apple.wifianalyticsd'

# -- TimeMachine (preserved) --
#_disable_systems \
#  'com.apple.backupd' \
#  'com.apple.backupd-helper'

# -- Touch ID / biometrics (preserved) --
#_disable_systems \
#  'com.apple.biomed'

# -- Cloud / iCloud (preserved) --
#_disable_systems \
#  'com.apple.cloudd'

# -- CoreDuet --
_disable_systems \
  'com.apple.coreduetd'

# -- DHCP --
_disable_systems \
  'com.apple.dhcp6d'

# -- Family --
_disable_systems \
  'com.apple.familycontrols'

# -- FindMy (preserved) --
#_disable_systems \
#  'com.apple.findmymac' \
#  'com.apple.findmymacmessenger' \
#  'com.apple.findmy.findmybeaconingd'

# -- FTP proxy --
_disable_systems \
  'com.apple.ftp-proxy'

# -- Game Controller --
_disable_systems \
  'com.apple.GameController.gamecontrollerd'

# -- iCloud FindMy (preserved) --
#_disable_systems \
#  'com.apple.icloud.searchpartyd'

# -- Location --
_disable_systems \
  'com.apple.locationd'

# -- Model manager --
_disable_systems \
  'com.apple.modelmanagerd'

# -- NetBIOS --
_disable_systems \
  'com.apple.netbiosd'

# -- Sharing / AirDrop / AirPlay / Handoff (preserved) --
#_disable_systems \
#  'com.apple.rapportd'

# -- ScreenSharing (preserved) --
#_disable_systems \
#  'com.apple.screensharing'

# -- Trials (system) --
_disable_systems \
  'com.apple.triald.system'