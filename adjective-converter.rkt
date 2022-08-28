#lang racket/base

(require racket/cmdline
         racket/function
         "support.rkt")

;; Convert CSV from https://github.com/codebrainz/color-names/blob/master/output/colors.csv into
;; a simple FASL list of colors

(define in (make-parameter "data/english-adjectives.txt"))
(define out (make-parameter "data/adjectives.fasl"))


(define (process in out)
  (write-fasl-file out
    (for/fold ([gs (make-hash)])
              ([a (read-text-file in)])
      (let ([c (string-ref a 0)])
        (hash-update! gs c (curry append (list a)) (list a)))
      gs))
  (displayln (format "Adjectives output to ~a" out))
  (exit 0))

(command-line
 #:program "color-converter"
 #:once-each
 [("-i" "--in") file-in "CSV file to read" (in file-in)]
 [("-o" "--out") file-out "FASL file to write" (out file-out)]
 #:args ()
 (process (in) (out)))
