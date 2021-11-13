# rrefine

[![CRAN Status](http://www.r-pkg.org/badges/version/rrefine)](https://cran.r-project.org/package=rrefine)
![](http://cranlogs.r-pkg.org/badges/rrefine)
![](https://cranlogs.r-pkg.org/badges/grand-total/rrefine)

## Introduction

[**OpenRefine**](https://openrefine.org/) (formerly **Google Refine**) is a popular, open source data cleaning software. **rrefine** enables users to programmatically trigger data transfer between R and **OpenRefine**. Using the functions available in this package, you can import, export or delete a project in **OpenRefine** directly from R. There are [several client libraries for automating **OpenRefine** tasks via Python, nodeJS and Ruby](https://docs.openrefine.org/technical-reference/openrefine-api#third-party-software-libraries). **rrefine** extends this functionality to R users.

## Installation

The development version of **rrefine** is available on [GitHub](https://github.com/vpnagraj/rrefine) and can be installed via **devtools**:

```
# install.packages("devtools")
devtools::install_github("vpnagraj/rrefine")
library(rrefine)
```

**rrefine** is also available on [CRAN](https://cran.r-project.org/package=rrefine):

```
install.packages("rrefine")
library(rrefine)
```
## Functions

The package includes the following functionality to interface with **OpenRefine** projects:

- `refine_upload()`: Upload data to a proejcet
- `refine_export()`: Export data from a project
- `refine_delete()`: Delete a project
- `refine_metadata()`: Retrieve metadata from all projects
- `refine_operations()`: Apply arbitrary operations to a project
- `refine_remove_column()`: Remove a column from a project
- `refine_add_column()`: Add a column to a project
- `refine_rename_column()`: Rename an existing column in a project
- `refine_move_column()`: Move a column to a new index
- `refine_transform()`: Apply arbitrary text transformations
- `refine_to_lower()`: Coerce text to lowercase
- `refine_to_upper()`: Coerce text to uppercase
- `refine_to_title()`: Coerce text to title case
- `refine_to_null()`: Set values to `NULL`
- `refine_to_empty()`: Set text values to empty string (`""`)
- `refine_to_text()`: Coerce value to string
- `refine_to_number()`: Coerce value to numeric
- `refine_to_date()`: Coerce value to date
- `refine_trim_whitespace()`: Remove leading and trailing whitespaces
- `refine_collapse_whitespace()`: Collapse consecutive whitespaces to single whitespace
- `refine_unescape_html()`: Unescape HTML in string

Descriptions and examples of usage are available in the package [manual](https://cran.r-project.org/package=rrefine/rrefine.pdf) and [vignette](https://cran.r-project.org/package=rrefine/vignettes/rrefine-vignette.html).

## Issues

Feature requests, bug reports or other questions should be directed to the [issue queue](https://github.com/vpnagraj/rrefine/issues). 
