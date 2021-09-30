#' Export data from OpenRefine
#'
#' This function allows users to pull data from a running OpenRefine instance into R. Users can specify project by name or unique identifier. The function wraps the OpenRefine API query to `/command/core/export-rows` and currently only supports export of data in tabular format.
#'
#' @param project.name Name of project to be exported
#' @param project.id Unique identifier for project to be exported
#' @param format File format of project to be exported; note that the only current supported options are 'csv' or 'tsv'
#' @param col.names Logical indicator for whether column names should be included; default is `TRUE`
#' @param encoding Character encoding for exported data; default is `UTF-8`
#' @param col_types One of NULL, a cols() specification, or a string; default is NULL. Used by \code{\link[readr]{read_csv}} to specify column types.
#' @param ... Additional parameters to be inherited by \code{\link{refine_path}}; allows users to specify `host` and `port` arguments if the OpenRefine instance is running at a location other than `http://127.0.0.1:3333`
#' @return A `tibble` that has been parsed and read into memory using \code{\link[readr]{read_csv}}. If `col.names=TRUE` then the `tibble` will have column headers.
#'
#' @references \url{https://github.com/OpenRefine/OpenRefine/wiki/OpenRefine-API#export-rows}
#' @export
#' @md
#' @examples
#' \dontrun{
#' fp <- system.file("extdata", "lateformeeting.csv", package = "rrefine")
#' refine_upload(fp, project.name = "lfm")
#' refine_export("lfm", format = "csv")
#' }
#'

refine_export <- function(project.name = NULL, project.id = NULL, format = "csv", col.names = TRUE, encoding = "UTF-8", col_types = NULL, ...) {

    ## check that OpenRefine is running
    refine_check(...)

    ## resolve id for project to export from either project.name or the project.id args
    project.id <- refine_id(project.name, project.id, ...)

    ## check that format parameter matches the allowed values
    if(!format %in% c("csv","tsv")) {
        stop(sprintf("Format specified as %s. Currently only 'csv' and 'tsv' export formats are allowed.", format))
    }
    ## export should work without token
    ## NOTE: need to paste0 to append project.id and format args
    query <- paste0(refine_query("export-rows", use_token = FALSE, ...),
                    "/",
                    project.id,
                    ".",
                    format)

    ## post query
    res <- httr::POST(
        query,
        body = c(engine = list(facets = "", mode="row-based"),
                 project = project.id, format = format),
        encode = "form")

    ## check query response status
    res_status <- httr::status_code(res)

    ## if not 200 (success) then assume failure and stop()
    if (res_status != 200)
        stop(sprintf("OpenRefine failed to find project id '%s'", project.id))

    cont <- httr::content(res,
                          type = paste0("text/", format),
                          as = "text",
                          encoding = encoding)

    if(format == "csv") {
        readr::read_csv(cont, col_names = col.names, col_types = col_types)
    } else if (format == "tsv") {
        readr::read_tsv(cont, col_names = col.names, col_types = col_types)
    }

}
