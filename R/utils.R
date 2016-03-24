#' helper function to configure and call path to open refine
#'
#' @param host host path for your open refine application
#' @param port port number for your open refine application
#' @return path to be executed

refine_path <- function(host = "127.0.0.1", port ="3333") {

    paste0("http://", host, ":", port)

}

#' get all project metadata
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
