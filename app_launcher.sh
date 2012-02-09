#!/usr/bin/env bash
app_limiter="/usr/bin/run_once.sh"

# quick fix to load all vars
. ~/.bash-konfiguracija

case $@ in
  --web-browser  ) $app_limiter $BROWSER    & ;;
  --voip         ) $app_limiter $VOIP_APP   & ;;
  --office       ) $app_limiter $OFFICE_APP & ;;
  --ide          ) $app_limiter $IDE_APP    & ;;
  --file-manager ) $app_limiter $FM_APP     & ;;
esac

exit 0
