README.md
================

Export both components as targets with viash. In order to build the
merge component, you will need the development version of viash (viash
0.2.0 rc3). This version is currently not installed on 1104, but the
target at `target/merge/merge_reports` should work there nonetheless.

``` bash
viash export -f src/component1/functionality.yaml -p src/component1/platform_docker.yaml -o target/component1
target/component1/make_vignette ---setup

viash export -f src/merge/functionality.yaml -p src/merge/platform_docker.yaml -o target/merge
target/merge/merge_reports ---setup
```

Generate two reports. By rendering the Rmd’s already as an
`md_document`, the merger can stitch together the different markdown as
needed. Alternatively, the component could generate an Rmd, assuming
that the merger has all the packages and inputs needed to render the Rmd
(which is often unlikely).

``` bash
# make a folder for the output
mkdir output

# run a component
target/component1/make_vignette -t help -o output/output1/report.md -f md_document

# run another component (in this case the same one)
target/component1/make_vignette -m 10 -s 2 -o output/output2/report.md -f md_document
```

Merge the different reports.

``` bash
target/merge/merge_reports -i output/output1/report.md -i output/output2/report.md -o output/book/book.pdf -f "bookdown::pdf_book"
```
