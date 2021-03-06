% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bedrock.R
\name{bedrock}
\alias{bedrock}
\title{The bedrock function}
\usage{
bedrock(x, y = -1, range = "partial")
}
\arguments{
\item{x}{The younger limit of the age interval to plot}

\item{y}{The older limit of the age interval to plot (optional)}

\item{range}{Indicating the temporal overlapping method of the given interval and the bedrock interval. Either "partial" (default) or "entire".}
}
\description{
This function allows you to quickly plot maps showing the bedrock coverage of given ages
}
\examples{
bedrock(66,70,range="entire")
}
\keyword{bedrock}
\keyword{coverage}
