#' helper function to configure and call path to OpenRefine
#'
#' @param host host path for your OpenRefine application
#' @param port port number for your OpenRefine application
#' @return path to be executed

refine_path <- function(host = "127.0.0.1", port ="3333") {

    paste0("http://", host, ":", port)

}

#' get all project metadata from OpenRefine
#'
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
