;;;;
;; This file is part of the PopStack (Clojure implementation).
;;
;; @license http://mit-license.org/ The MIT license
;; @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
;;;;

(ns popstack.core
    (:gen-class)
    (:require [clj-http.client :as client])
    (:require [clojure.data.json :as json]))

(defn fetch
    [call]
    (json/read-str (:body (client/get (str "http://api.stackexchange.com/2.2/" call "&site=stackoverflow")))))

(defn -main
    [& args]
    (println
        (get (fetch "similar?order=desc&sort=relevance&title=Hibernate+manytomany") "items")))
