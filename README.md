# rrefine

## Introduction

*OpenRefine* (formerly *Google Refine*) is a popular, open source data cleaning software. **rrefine** enables users to programmatically trigger data transfer between R and *OpenRefine*. Using the functions avaialable in this package, you can import, export or delete a project in *OpenRefine* directly from an R script. There are several client libraries for automating *OpenRefine* tasks via Python, nodeJS and Ruby[^2]. **rrefine** extends this functionality to R users.

## Installation

The latest version of **rrefine** is availabe on [Github](https://github.com/vpnagraj/rrefine) and can be installed via **devtools**:

```
# install.packages("devtools")
devtools::install_github("vpnagraj/rrefine")
library(rrefine)
```

**rrefine** is also available on CRAN:

```
install.packages("rrefine")
library(rrefine)
```
## Functions

The package includes the following functionality:

- `refine_upload()` (upload data to *OpenRefine* from R)
- `refine_export()` (export data to R from *OpenRefine*)
- `refine_delete()` (delete *OpenRefine* project)

Descriptions and examples of usage are available in the package [manual](https://cran.r-project.org/web/packages/rrefine/rrefine.pdf) and [vignette](https://cran.r-project.org/web/packages/rrefine/vignettes/rrefine-vignette.html).

## Issues

Feature requests, bug reports or other questions should be directed to the [issue queue](https://github.com/vpnagraj/rrefine/issues). 

## References

[^1]: <http://openrefine.org/>
[^2]: <https://github.com/OpenRefine/OpenRefine/wiki/Documentation-For-Developers#known-client-libraries-for-refine>
