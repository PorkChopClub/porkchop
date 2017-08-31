(ns pork-chop.test-runner
  (:require
   [doo.runner :refer-macros [doo-tests]]
   [pork-chop.core-test]
   [pork-chop.common-test]))

(enable-console-print!)

(doo-tests 'pork-chop.core-test
           'pork-chop.common-test)
