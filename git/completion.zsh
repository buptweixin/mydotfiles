# Fetch gitignore templates: `gi macos node` prints a merged template.
# gitignore.io shut down; the Toptal API is its maintained successor.
gi () {
        curl --fail --connect-timeout 10 --max-time 30 -L -s "https://www.toptal.com/developers/gitignore/api/${(j:,:)@}"
}
