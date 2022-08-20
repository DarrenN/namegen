#lang racket/base

(require racket/cmdline
         racket/string
         csv-reading
         "support.rkt")

;; Convert CSV from https://simplemaps.com/data/world-cities into
;; a simple FASL list of cities

(define in (box "data/worldcities.csv"))
(define out (box "data/cities.fasl"))

(define make-city-csv-reader
  (make-csv-reader-maker
   '((strip-leading-whitespace?  . #t)
     (strip-trailing-whitespace? . #t))))

(define (squeeze-name s)
  (string-join (string-split s) ""))

(define (process in out)
  (write-fasl-file out
   (list->vector
    (csv-map (λ (l) (squeeze-name (car l)))
             (read-csv-file in make-city-csv-reader))))
  (displayln (format "Cities output to ~a" out))
  (exit 0))

(command-line
 #:program "cities-converter"
 #:once-each
 [("-i" "--in") file-in "CSV file to read" (set-box! in file-in)]
 [("-o" "--out") file-out "FASL file to write" (set-box! out file-out)]
 #:args ()
 (process (unbox in) (unbox out)))
