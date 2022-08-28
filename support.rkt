#lang racket/base

(require racket/fasl
         (only-in racket/file file->lines)
         json)

(provide read-json-file
         read-csv-file
         read-text-file
         write-fasl-file)

(define (exit-with-error v)
  (displayln v)
  (exit 1))

(define (read-text-file path)
  (when (not (file-exists? path))
    (exit-with-error (format "~a doesn't exist!" path)))
  (file->lines path #:mode 'text))

(define (read-json-file path)
  (when (not (file-exists? path))
    (exit-with-error (format "~a doesn't exist!" path)))
  (call-with-input-file* path
    (λ (in) (read-json in))))

(define (write-fasl-file path v)
  (call-with-output-file* path
    #:exists 'replace
    (λ (out) (s-exp->fasl v out))))

(define (read-csv-file path make-reader)
  (when (not (file-exists? path))
    (exit-with-error (format "~a doesn't exist!" path)))
  (make-reader (open-input-file path)))
