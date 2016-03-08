#' delete project from open refine
#'
#' @param project.id unique identifier for open refine project to be deleted
#' @export
#' @examples
#' \dontrun{
#' refine_delete(project.id = 1901017388690)
#' }
#'
refine_delete <- function(project.id) {

    x <- readline(prompt = "are you sure you want to delete this project? (Y/N): ")

    if(x == "Y") {
        httr::POST(
            paste0(refine_path(), "/command/core/delete-project"),
            body = list(project = project.id),
            encode = 'form')
        message("project deleted")
    } else
        stop("aborting delete process")

}
