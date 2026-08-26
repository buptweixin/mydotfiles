# Fetch gitignore templates: `gi macos node` prints a merged template.
# gitignore.io shut down; the Toptal API is its maintained successor.
gi () {
        curl -L -s "https://www.toptal.com/developers/gitignore/api/${(j:,:)@}"
}
