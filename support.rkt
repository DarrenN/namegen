#lang racket/base

(require racket/fasl
         json)

(provide read-json-file
         read-csv-file
         write-fasl-file)

(define (read-json-file path)
  (when (not (file-exists? path))
    (println (format "~a doesn't exist!" path))
    (exit 1))
  (call-with-input-file* path
    (λ (in) (read-json in))))

(define (write-fasl-file path v)
  (call-with-output-file* path
    #:exists 'replace
    (λ (out) (s-exp->fasl v out))))

(define (read-csv-file path make-reader)
  (when (not (file-exists? path))
    (println (format "~a doesn't exist!" path))
    (exit 1))
  (make-reader (open-input-file path)))
