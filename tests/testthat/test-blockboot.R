
y = air$Temperature
N1 = 1050
N2 = 3010
N3 = length(y)
K = 1
L = 2

test_that("simulation length equal to N, sort = FALSE", {
  expect_equal(length(blockboot(y, N1, K, L)), N1)
  expect_equal(length(blockboot(y, N1, K, L, "geometric")), N1)
  expect_equal(length(blockboot(y, N1, K, L, "constant")), N1)

  expect_equal(length(blockboot(y, N2, K, L)), N2)
  expect_equal(length(blockboot(y, N2, K, L, "geometric")), N2)
  expect_equal(length(blockboot(y, N2, K, L, "constant")), N2)

  expect_equal(length(blockboot(y, N3, K, L)), N3)
  expect_equal(length(blockboot(y, N3, K, L, "geometric")), N3)
})

test_that("simulation length equal to N, sort = TRUE", {
  expect_equal(length(blockboot(y, N1, K, L, sort = TRUE)), N1)
  expect_equal(length(blockboot(y, N1, K, L, "geometric", sort = TRUE)), N1)
  expect_equal(length(blockboot(y, N1, K, L, "constant", sort = TRUE)), N1)

  expect_equal(length(blockboot(y, N2, K, L, sort = TRUE)), N2)
  expect_equal(length(blockboot(y, N2, K, L, "geometric", sort = TRUE)), N2)
  expect_equal(length(blockboot(y, N2, K, L, "constant", sort = TRUE)), N2)

  expect_equal(length(blockboot(y, N3, K, L, sort = TRUE)), N3)
  expect_equal(length(blockboot(y, N3, K, L, "geometric", sort = TRUE)), N3)
})

test_that("simulation length equal to N, reject = FALSE", {
  expect_equal(length(blockboot(y, N2, K, L, reject = FALSE)), N2)
  expect_equal(length(blockboot(y, N2, K, L, "geometric", reject = FALSE)), N2)
  expect_equal(length(blockboot(y, N2, K, L, "constant", sort = FALSE)), N2)
})

test_that("errors testing", {
  expect_error(blockboot(y, -10, K, L), "N has to be greater than 0")
  expect_error(blockboot(y, N1, -5, L), "K has to be greater than 0")
  expect_error(blockboot(y, N1, K, -7), "L has to be greater than 0")
  expect_error(blockboot(y, N1, K, N3+2))
  expect_error(blockboot(y, N1, K, L, "chi2"), "invalid chosen distribution")
})

test_that("warnings testing", {
  expect_warning(a <- blockboot(y, N1, K, 4, "constant"))
})
