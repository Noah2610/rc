export EDITOR='vim'
export VISUAL="$EDITOR"
export BROWSER='waterfox'
if ! which waterfox &> /dev/null; then
  export BROWSER='firefox'
fi

# Calcurse calendar
#PROFILE = h77m-arch || acer
export CALCURSE_CALENDAR='personal'
#PROFILE = aware-desktop
export CALCURSE_CALENDAR='work'
