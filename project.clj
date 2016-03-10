;;;;
;; This file is part of the PopStack (Clojure implementation).
;;
;; @license http://mit-license.org/ The MIT license
;; @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
;;;;

(defproject popstack "0.1.0-SNAPSHOT"
    :dependencies [
        [org.clojure/clojure "1.7.0"],
        [org.clojure/data.json "0.2.6"],
        [clj-http "2.1.0"]
    ]
    :main ^:skip-aot popstack.core
    :target-path "target/%s"
    :profiles {:uberjar {:aot :all}})
