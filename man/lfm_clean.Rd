% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{lfm_clean}
\alias{lfm_clean}
\title{a "clean" version of the lateformeeting sample data set}
\format{A data frame with 63 rows and 4 variables
\itemize{
  \item {date} {date of observation in POSIXct format}
  \item {dotw} {day of the week in consistent format}
  \item {hours.slept} {number of hours slept}
  \item {on.time} {indicator of on-time arrival to work}
}}
\usage{
lfm_clean
}
\description{
This data is a simulated collection of dates, days of the week, numbers of hours slept and indicators of whether or not the subject was on time for work. All observations appearing in this data set are fictitious, and any resemblance to actual arrival times for work is purely coincidental.
}
\examples{
head(lfm_clean)
}
\keyword{datasets}
