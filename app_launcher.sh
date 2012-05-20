#!/usr/bin/env bash
app_limiter="/usr/bin/run_once.sh"

# quick fix to load all vars
#. ~/.bash-konfiguracija
BROWSER2="opera_launcher"
FM_APP="pcmanfm"
VOIP_APP="skype"
IDE_APP="geany"
OFFICE_APP="libreoffice"
USERTERM="urxvt"
USERTERM_BACKUP="xterm"


case $@ in
  --web-browser               ) $app_limiter $BROWSER          & ;;
  --voip                      ) $app_limiter $VOIP_APP         & ;;
  --office                    ) $app_limiter $OFFICE_APP       & ;;
  --ide                       ) $app_limiter $IDE_APP          & ;;
  --file-manager              ) $app_limiter $FM_APP           & ;;
  --terminal-emulator         ) $USERTERM                      & ;;
  --terminal-emulator-backup  ) $USERTERM_BACKUP               & ;;
esac

exit 0
