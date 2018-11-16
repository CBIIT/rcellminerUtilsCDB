context("rcellminerUtils validation")

test_that("Objects in rcellminerUtils and rcellminerUtils identical", {
  
  # expect_identical(rcellminerUtilsCDB::cellLineMatchTab, rcellminerUtils::cellLineMatchTab)
  expect_identical(rcellminerUtilsCDB::drugSynonymTab, rcellminerUtils::drugSynonymTab)
  
  expect_identical(rcellminerUtilsCDB::geneToChromBand, rcellminerUtils::geneToChromBand)
})