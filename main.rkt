#lang racket/base

;; Generates a random username based on the Periodic Table of Elements
;; and city names or colors

(module+ main
  (require racket/cmdline
           racket/fasl
           racket/runtime-path)

  (define-runtime-path adjectives-path "data/adjectives.fasl")
  (define-runtime-path cities-path "data/cities.fasl")
  (define-runtime-path colors-path "data/colors.fasl")
  (define-runtime-path elements-path "data/periodic-table.fasl")

  (define adjectives (call-with-input-file adjectives-path fasl->s-exp))
  (define cities (call-with-input-file cities-path fasl->s-exp))
  (define colors (call-with-input-file colors-path fasl->s-exp))
  (define elements (call-with-input-file elements-path fasl->s-exp))

  (define use-color (make-parameter #f))
  (define use-release (make-parameter #f))

  (define (get-random-item vec)
    (vector-ref vec (random 0 (vector-length vec))))

  (define (get-random-list-item ls)
    (list-ref ls (random 0 (length ls))))

  (define (get-adjective-item s as)
    (get-random-list-item (hash-ref as (char-downcase (string-ref s 0)))))

  (command-line
   #:program "namegen"
   #:once-each
   [("-c" "--color") "Use colors instead of cities" (use-color #t)]
   [("-r" "--release") "Generate Ubuntu style release name (ex: chubbyCesium)" (use-release #t)]
   #:args ()
   (let ([element (get-random-item elements)])
     (displayln (format
                 "~a~a"
                 (cond [(use-release) (get-adjective-item element adjectives)]
                       [else element])
                 (cond [(use-color) (get-random-item colors)]
                       [(use-release) element]
                       [else (get-random-item cities)]))))))
