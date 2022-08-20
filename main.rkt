#lang racket/base

;; Generates a random username based on the Periodic Table of Elements
;; and city names or colors

(module+ main
  (require racket/cmdline
           racket/fasl
           racket/runtime-path)

  (define-runtime-path cities-path "data/cities.fasl")
  (define-runtime-path colors-path "data/colors.fasl")
  (define-runtime-path elements-path "data/periodic-table.fasl")

  (define cities (call-with-input-file cities-path fasl->s-exp))
  (define colors (call-with-input-file colors-path fasl->s-exp))
  (define elements (call-with-input-file elements-path fasl->s-exp))

  (define use-color (make-parameter #f))

  (define (get-random-item vec)
    (vector-ref vec (random 0 (vector-length vec))))
  
  (command-line
   #:program "namegen"
   #:once-each
   [("-c" "--color") "Use colors instead of cities" (use-color #t)]
   #:args ()
   (displayln (format
               "~a~a"
               (get-random-item elements)
               (if (use-color)
                   (get-random-item colors)
                   (get-random-item cities))))))
