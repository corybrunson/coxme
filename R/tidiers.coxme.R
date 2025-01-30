# consistent with `survival:::nobs.coxph()`
nobs.coxme <- function(object, ...) object$n[[1L]]

model.frame.coxme <- function(formula, fixed.only = FALSE, ...) {
  
  # borrowed from `stats:::model.frame.default()`
  if (all(c("terms", "call") %in% names(formula))) {
    fcall <- formula$call
    m <- match(
      c("formula", "data", "subset", "weights", "na.action"),
      names(fcall), 0
    )
    fcall <- fcall[c(1, m)]
    fcall[[1L]] <- quote(stats::model.frame)
    # FIXME: This intervention destroyes the 'name' or 'call' class.
    if (! inherits(fcall[[2L]], "formula")) fcall[[2L]] <- eval(fcall[[2L]])
    fcall[[2L]] <- subbar(fcall[[2L]])
    eval.parent(fcall)
  }
  
}

# x$variance; x$hmat; x$u
tidy.coxme <- function(
    x, exponentiate = FALSE, conf.int = FALSE, conf.level = 0.95, ...
) {
  s <- summary(x)
  co <- stats::coef(s)
  
  ret <- as.data.frame(cbind(co[, -2L, drop = FALSE]))
  names(ret) <- c("estimate", "std.error", "statistic", "p.value")
  ret <- cbind(data.frame(term = rownames(co)), ret)
  rownames(ret) <- NULL
  
  if (conf.int) {
    ci <- stats::confint(x, level = conf.level)
    ci <- as.data.frame(ci)
    names(ci) <- c("conf.low", "conf.high")
    rownames(ci) <- NULL
    ret <- cbind(ret, ci)
  }
  if (exponentiate) {
    exp_cols <- intersect(c("estimate", "conf.low", "conf.high"), names(ret))
    ret[, exp_cols] <- exp(ret[, exp_cols])
  }
  
  ret$
  
  ret
}

glance.coxme <- function(x, ...) {
  s <- summary(x)
  chi <- s$chi
  data.frame(
    n = s$n[[2L]],
    # nevent = stats::nobs(x),
    nevent = s$n[[1L]],
    # REVIEW: Alternative naming convention.
    # statistic.chisq1 = chi[1L, 1L],
    # df.chisq1 = chi[1L, 2L],
    # p.value.chisq1 = chi[1L, 3L],
    statistic.chisq.integrated = chi[1L, 1L],
    df.chisq.integrated        = x$df[[1L]],
    p.value.chisq.integrated   = chi[1L, 3L],
    statistic.chisq.penalized  = chi[2L, 1L],
    df.chisq.penalized         = x$df[[2L]],
    p.value.chisq.penalized    = chi[2L, 3L],
    # REVIEW: Alternative calculations; should they be revised?
    # logLik = as.numeric(stats::logLik(x)),
    # AIC = stats::AIC(x), BIC = stats::BIC(x),
    logLik.integrated = s$loglik[[2L]],
    AIC.integrated    = chi[1L, 4L],
    BIC.integrated    = chi[1L, 5L],
    logLik.penalized  = s$loglik[[3L]],
    AIC.penalized     = chi[2L, 4L],
    BIC.penalized     = chi[2L, 5L]
  )
}

# cf `broom:::augment.coxph()` and `broom.mixed:::augment.merMod()`
augment.coxme <- function(
    x, data = stats::model.frame(x), newdata, type.predict = "lp", ...
) {
  if (missing(newdata)) {
    data <- stats::model.frame(x)
  }
  ret <- if (missing(newdata)) data else newdata
  
  type.predict <- match.arg(type.predict, c("lp", "risk"))
  if (missing(newdata)) {
    ret$.fitted <- stats::predict(x, type = type.predict)
  } else {
    predictions <- 
      try(stats::predict(x, ret, type = type.predict), silent = TRUE)
    if (inherits(predictions, "try-error")) {
      if (length(predictions) == nrow(ret)) {
        ret$.fitted <- predictions
      }
    } else {
      warning(predictions)
    }
  }
  
  ret
}
