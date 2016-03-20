;;;;
;; This file is part of the PopStack (Clojure implementation).
;;
;; @license http://mit-license.org/ The MIT license
;; @copyright 2016 © by Rafał Wrzeszcz - Wrzasq.pl.
;;;;

; TODO:
; code style
; static code analysis
; unit tests
; auto documentation
; use more language features
; logs
; optimize (try to keep some parts of repetitive executions as instanced objects)
; "proper" HTTP client setup (headers, gzip with json coercion)

(ns popstack.core
    (:gen-class)
    (:require [clj-http.client :as client])
    (:require [clojure.data.json :as json])
    (:require [clojure.string :as string])
    (:require [clojure.tools.html-utils :as html-utils]))

(defn fetch
    [call]
    (json/read-str (:body (client/get (str "http://api.stackexchange.com/2.2/" call "&site=stackoverflow")))))

(defn getAnswerId
    [post]
    (get post "accepted_answer_id"))

(defn selectAnswer
    [ids]
    (first (filter (complement nil?) ids)))

(defn ask
    [query]
    (selectAnswer (map getAnswerId (get (fetch (str "similar?order=desc&sort=relevance&title=" query)) "items"))))

(defn extractSnippet
    [body]
    (let [match (nth (re-find #"(?s)<pre><code>(.*?)</code></pre>" body) 1)]
        (if (nil? match)
            nil
            (string/trim (html-utils/xml-decode match)))))

(defn getAnswer
    [id]
    (get (nth (get (fetch (str "answers/" id "?filter=withbody")) "items") 0) "body"))

(defn buildQuery
    [args]
    (html-utils/url-encode (string/join " " args)))

(defn -main
    [& args]
    ; TODO: first make sure there was a snippet extracted
    ; TODO: process more pages maybe?
    (println (try
        (let [answerId (ask (buildQuery args))]
            (if (nil? answerId) "Your only help is http://google.com/ man!" (extractSnippet (getAnswer answerId))))
        (catch Exception error (.getMessage error)))))
