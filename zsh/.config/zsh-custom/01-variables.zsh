export EDITOR="$( command -v nvim &> /dev/null && echo -n 'nvim' || echo -n 'vim' )"
export VISUAL="$EDITOR"
export BROWSER='firefox'
command -v "waterfox" &> /dev/null \
    && export BROWSER="waterfox"
command -v "waterfox-classic" &> /dev/null \
    && export BROWSER="waterfox-classic"

# Calcurse calendar
#PROFILE = desktop-manjaro || h77m-arch || acer
##export CALCURSE_CALENDAR='personal'
#PROFILE = aware-desktop
export CALCURSE_CALENDAR='work'

# cdpath on shell startup
export AUTO_CDPATH=1

# fzf default search command (ripgrep)
command -v 'fd' &> /dev/null && export FZF_DEFAULT_COMMAND='fd --type f'
