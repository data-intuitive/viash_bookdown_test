### VIASH START
par <- list(
  input = c("output/run1/report.md", "output/run2/report.md"),
  output = "output/book/output.pdf",
  format = "bookdown::pdf_book"
)
resources_dir <- "src/merge/"
### VIASH END

print(par)

cat("get absolute path to file\n")
input <- normalizePath(par$input)
path <- file.path(normalizePath(dirname(par$output), mustWork = FALSE), basename(par$output))
resources_dir <- normalizePath(resources_dir)

cat("set wd to output dir\n")
orig_wd <- getwd()
on.exit(setwd(orig_wd))
setwd(dirname(path))

cat("copy template to output dir\n")
rmd <- file.path(".", gsub("\\.[^\\.]*$", ".Rmd", basename(path)))
file.copy(
  file.path(resources_dir, "index.Rmd"), 
  rmd
)
on.exit(file.remove(rmd))

cat("copy inputs to output dir\n")
new_filenames <- paste0(seq_along(input), "-part.md")
input_dirnames <- gsub("\\.[^\\.]*$", "_files/", input)
new_dirnames <- paste0(seq_along(input), "-part_files/")
for (i in seq_along(input)) {
  mdin <- input[[i]]
  mdout <- new_filenames[[i]]
  file.copy(mdin, mdout, overwrite = TRUE)
  
  dirin <- input_dirnames[[i]]
  dirout <- new_dirnames[[i]]
  if (file.exists(dirin)) {
    if (file.exists(dirout)) {
      unlink(dirout, recursive = TRUE)
    }
    dir.create(dirout)
    file.copy(dirin, dirout, recursive = TRUE, copy.mode = TRUE)
  }
  
  # fix paths in md
  lines <- readLines(mdout)
  substitute_paths <- gsub(paste0("(\\[[^\\)]*\\])\\((", basename(dirin), "[^\\)]*)\\)"), paste0("\\1(", dirout, "\\2)"), lines)
  writeLines(substitute_paths, mdout)
}

bookdown_yaml <- paste0("rmd_files: [\"", paste0(c(rmd, new_filenames), collapse = "\", \""), "\"]\ndelete_merged_file: true")
writeLines(bookdown_yaml, "_bookdown.yml")

cat("render markdown\n")
cat(rmd, "\n")
cat(list.files("."))
bookdown::render_book(
  rmd,
  output_file = basename(path),
  output_format = par$format
)

