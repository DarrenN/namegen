#lang racket/base

(require racket/cmdline
         racket/string
         csv-reading
         "support.rkt")

;; Convert CSV from https://github.com/codebrainz/color-names/blob/master/output/colors.csv into
;; a simple FASL list of colors

(define in (box "data/colors.csv"))
(define out (box "data/colors.fasl"))

(define make-city-csv-reader
  (make-csv-reader-maker
   '((strip-leading-whitespace?  . #t)
     (strip-trailing-whitespace? . #t))))

;; I only want single word colors, for aesthetic reasons
(define (filter-colors cs)
  (foldl (λ (c result)
           (if (string-contains? c " ")
               result
               (cons c result)))
         '() cs))

(define (process in out)
  (write-fasl-file out
   (list->vector
    (filter-colors
     (csv-map (λ (l) (cadr l))
              (read-csv-file in make-city-csv-reader)))))
  (displayln (format "Cities output to ~a" out))
  (exit 0))

(command-line
 #:program "color-converter"
 #:once-each
 [("-i" "--in") file-in "CSV file to read" (set-box! in file-in)]
 [("-o" "--out") file-out "FASL file to write" (set-box! out file-out)]
 #:args ()
 (process (unbox in) (unbox out)))
