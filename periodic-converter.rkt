#lang racket/base

(require racket/cmdline
         racket/list
         "support.rkt")

;; Convert JSON from https://pubchem.ncbi.nlm.nih.gov/periodic-table/ into a
;; simple FASL list of elements

(define in (box "data/PubChemElements_all.json"))
(define out (box "data/periodic-table.fasl"))


(define (get-cells v)
  (hash-ref (hash-ref v 'Table) 'Row))

(define (get-elements ls)
  (map (λ (l) (last (take (hash-ref l 'Cell) 3))) ls))

(define (process in out)
  (write-fasl-file
   out (list->vector (get-elements (get-cells (read-json-file in)))))
  (displayln (format "Elements output to ~a" out))
  (exit 0))

(command-line
 #:program "periodic-converter"
 #:once-each
 [("-i" "--in") file-in "JSON file to read" (set-box! in file-in)]
 [("-o" "--out") file-out "FASL file to write" (set-box! out file-out)]
 #:args ()
 (process (unbox in) (unbox out)))
