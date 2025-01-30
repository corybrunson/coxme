\name{tidy.coxme}
\Rdversion{1.1}
\alias{tidy.coxme}
\title{
Tidy a coxme object
}
\description{
\code{tidy()} summarizes information about the components of a model.
}
\usage{
\method{tidy}{coxme}(x, exponentiate = FALSE, conf.int = FALSE, conf.level = 0.95, ...)
}
\arguments{
  \item{x}{
    an object of class \code{coxme}, from the fit of a mixed effects
    survival model.
  }
  \item{exponentiate}{
    logical; whether to exponentiate the coefficient estimates
    (and the confidence bounds if included).
  }
  \item{conf.int}{
    logical; whether to include a confidence interval.
  }
  \item{conf.level}{
    the confidence level to use for the confidence interval.
  }
  \item{\dots}{
    optional arguments passed to \code{\link{generics::tidy}}}.
}
\author{
Jason Cory Brunson
}
\seealso{\code{\link{coxme}}}
\keyword{survival}
