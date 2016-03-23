#' export data from open refine
#'
#' @param project.name name of project to be exported
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

refine_export <- function(project.name = NULL, project.id = NULL, format = "csv", col.names = TRUE, encoding = "UTF-8") {

    if (is.null(project.name) & is.null(project.id)){

        stop("you must supply either a project name or project id")

    }

    if (!is.null(project.id)) {

        project.id <- project.id

    } else {

        resp <- refine_metadata()

        id <- names(rlist::list.mapv(rlist::list.filter(resp[['projects']], name == project.name), name))

        if (length(id) == 1) {

            project.id <- id

        } else if (length(id) == 0) {

            stop(paste0("there are no projects found named '", project.name, "' ... try adjusting the project.name argument or use project.id"))

        } else {

            stop(paste0("there are mulitple projects named '", project.name, "' ... try addding a project.id"))

        }
    }

    httr::content(
        httr::POST(
            paste0(refine_path(), "/command/core/export-rows/", project.id, ".", format), body = c(engine = list(facets = "", mode="row-based"), project = project.id, format = format), encode = 'form'),
        type = "text/csv", as = "parsed", col_names = col.names, col_types = NULL, encoding = encoding)

}
