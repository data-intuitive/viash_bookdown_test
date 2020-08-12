README.md
================

``` bash
viash export -f src/component1/functionality.yaml -p src/component1/platform_docker.yaml -o target/component1
viash export -f src/merge/functionality.yaml -p src/merge/platform_docker.yaml -o target/merge
target/component1/make_vignette ---setup
target/merge/merge_reports ---setup
```

``` bash
# make a folder for the output
mkdir output

# run a component
target/component1/make_vignette -t help -o output/output1/report.md -f github_document

# run another component (in this case the same one)
target/component1/make_vignette -m 10 -s 2 -o output/output2/report.md -f github_document
```
