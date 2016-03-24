#' get all project metadata
#'
#' @export
#' @examples
#' \dontrun{
#' refine_metadata()
#' }
#'

refine_metadata <- function() {

    httr::content(httr::GET(paste0(refine_path(),
                                   "/",
                                   "command/core/get-all-project-metadata"))
    )

}
