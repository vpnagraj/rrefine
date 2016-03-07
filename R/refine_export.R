#' export data from open refine
#'
#' @param project.id unique identifier for open refine project to be exported
#' @param format file format of open refine project to be exported, default is 'csv'
#' @param col.names boolean indicator for whether column names should be included.
#' @param encoding character encoding for exported data, default is 'UTF-8'
#' @export
#' @examples
#' \dontrun{
#' refine_export(project.id = 1901017388690, format = "csv")
#' }
#'

refine_export <- function(project.id, format = "csv", col.names = TRUE, encoding = "UTF-8") {

    httr::content(
        httr::POST(
            paste0(refine_path(), "/command/core/export-rows/", project.id, ".", format), body = c(engine = list(facets = "", mode="row-based"), project = project.id, format = format), encode = 'form'),
        type = "text/csv", as = "parsed", col_names = col.names, col_types = NULL, encoding = encoding)

}
