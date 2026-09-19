## Builds the pkgdown site into docs/ (deployed by GitHub Pages from main:/docs).
## pkgdown renders every *.md at the package root, so the local CLAUDE.md is
## moved aside (inside the project, never to tempdir) during the build to keep
## it out of the public site. Everything runs inside a function so on.exit()
## restores the files even if the build fails.
build_site_clean <- function() {
  aside <- character()
  for (f in c("CLAUDE.md", "CLAUDE.local.md")) {
    if (file.exists(f)) {
      hidden <- paste0(".", f, ".building")
      file.rename(f, hidden)
      aside[f] <- hidden
    }
  }
  on.exit(for (f in names(aside)) file.rename(aside[[f]], f), add = TRUE)
  pkgdown::clean_site(force = TRUE)
  pkgdown::build_site(preview = FALSE, new_process = TRUE)
}
build_site_clean()
