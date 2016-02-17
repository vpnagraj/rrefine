#' helper function to configure and call path to open refine
#'
#' @param file file name to be uploaded
#' @param open.browser boolean for whether or not you want to open browser
#' @return
#' @export
#'
#
refine_upload <- function(file, open.browser = FALSE) {

    # define upload query based on configurations in refine_path()
    refpath <- paste0(refine_path(), "/command/core/create-project-from-upload")

    # check status of server (if open refine is running) before proceeding
    #     http_status(POST(refine_path()))

    # post project to refine
    httr::POST(refpath, body = list(x = httr::upload_file(file)))

    # view open refine in browser
    if (open.browser)
        browseURL(refine_path()) else
            message("Success!")
}
