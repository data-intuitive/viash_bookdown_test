### VIASH START
par <- list(
  title = "a title for my plot",
  mean = 0,
  sd = 1,
  output = "output/output.pdf",
  format = "github_document"
)
resources_dir <- "src/component1/"
### VIASH END

# get absolute path to file
if (!file.exists(dirname(par$output))) dir.create(dirname(par$output), recursive = TRUE)
resources_dir <- normalizePath(resources_dir)
path <- file.path(normalizePath(dirname(par$output), mustWork = FALSE), basename(par$output))

# set wd to output dir
orig_wd <- getwd()
on.exit(setwd(orig_wd))
setwd(dirname(path))

# copy template to output dir
rmd <- file.path(".", gsub("\\.[^\\.]*$", ".Rmd", basename(path)))
file.copy(
  file.path(resources_dir, "report.Rmd"), 
  rmd
)
on.exit(file.remove(rmd))

# render markdown
rmarkdown::render(
  input = rmd,
  output_file = basename(path),
  output_format = par$format,
  params = par[c("title", "mean", "sd")]
)
