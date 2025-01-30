\name{augment.coxme}
\Rdversion{1.1}
\alias{augment.coxme}
\title{
Augment data with information from a coxme object
}
\description{
\code{augment()} accepts a model object and a dataset
and adds information about each observation in the dataset.
}
\usage{
\method{augment}{coxme}(x, data = stats::model.frame(x), newdata, type.predict = "lp", ...)
}
\arguments{
  \item{x}{
    an object of class \code{coxme}, from the fit of a mixed effects
    survival model.
  }
  \item{data}{
    the original data \code{x} was fitted on;
    if not given, will attempt to be reconstructed.
  }
  \item{newdata}{
    new data to be used for prediction; optional.
  }
  \item{type.predict}{
    character; the type of prediction to use.
  }
  \item{\dots}{
    optional arguments passed to \code{\link{generics::augment}}}.
}
\author{
Jason Cory Brunson
}
\seealso{\code{\link{coxme}}}
\keyword{survival}
