# bboot 0.2.1

-   Added checks of input parameters. If, for example, `l_gen == "constant"` and `length(y) == N`, then the convergence is not guaranteed, therefore a warning is generated.

-   Written tests.

------------------------------------------------------------------------

# bboot 0.2.0

-   Added the possibility to obtain simulations containing blocks having the same first index. This feature is available only when N is greater than the number of data.
-   Corrected the code examples.

------------------------------------------------------------------------

# bboot 0.1.1

-   Added dependency to `rlang::is_empty`

------------------------------------------------------------------------

# bboot 0.1.0

-   First (stable) version of `blockboot.R`.
-   Added a `NEWS.md` file to track changes to the package.
