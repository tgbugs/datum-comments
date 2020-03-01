;;; datum-comments.el --- Highlight datum comments -*- lexical-binding: t -*-

;; Author: Tom Gillespie
;; URL: https://github.com/tgbugs/datum-comments

;;;; License and Commentary

;; License:
;; This is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version. This is distributed in the hope that it will be
;; useful, but without any warranty; without even the implied warranty
;; of merchantability or fitness for a particular purpose. See the GNU
;; General Public License for more details. See
;; http://www.gnu.org/licenses/ for details.

;;; Commentary:

;; This code is a hacked together combination of `slime''s approach to
;; reader conditional forms (e.g. feature expressions) and `racket-mode''s
;; approach. The license reflects the fact that most of this code was
;; lifted with minimal modifications from both of those.
;; https://github.com/slime/slime
;; https://github.com/greghendershott/racket-mode

;;; Code:

(defun datum-comments--syntax-propertize-function (start end)
  "propertize datum comments as a symbol"
  ;; if this is not done then the bare ";" will be
  ;; detected as a comment and regular comments on the
  ;; same line as a datum comment will not be commented
  ;; out correctly if they contain closing parens, and
  ;; `slime-forward-sexp' will fail as a result
  (goto-char start)
  (funcall
   (syntax-propertize-rules
    ((rx "#;")
     (0 "_")))
   (point)
   end))

(defun datum-comments--font-lock-datum-comments (limit)
  "Font-lock datum comments.

Datum comments behave like feature expressions that are always false,
so we just font lock them, not make them comments syntacitically."
  (when (re-search-forward (rx (group-n 1 "#;" (* " "))
                               (group-n 2 (not (any " "))))
                           limit t)
    (unless (datum-comments--string-or-comment-p  ;issues 388, 408
             (match-beginning 1))
      (ignore-errors
        (let ((md (match-data)))
          (goto-char (match-beginning 2))
          (forward-sexp 1)
          (setf (elt md 5) (point))     ;set (match-end 2)
          (set-match-data md)
          t)))))

(defun datum-comments--ppss-string-p (xs)
  "Non-‘nil’ if inside a string.
More precisely, this is the character that will terminate the
string, or ‘t’ if a generic string delimiter character should
terminate it."
  (elt xs 3))

(defun datum-comments--ppss-comment-p (xs)
  "‘t’ if inside a non-nestable comment (of any comment style;
*note Syntax Flags::); or the comment nesting level if inside a
comment that can be nested."
  (elt xs 4))

(defun datum-comments--string-or-comment-p (pos)
  (let ((state (syntax-ppss pos)))
    (or (datum-comments--ppss-string-p  state)
        (datum-comments--ppss-comment-p state))))

(defconst datum-comments--font-lock-keywords
  (eval-when-compile
    `((,#'datum-comments--font-lock-datum-comments
       (1 font-lock-comment-delimiter-face t)
       (2 font-lock-comment-face t)))))

(define-minor-mode datum-comments-mode
  "Minor mode for working with lisp files that make use of datum comments"
  nil "" nil

  (font-lock-remove-keywords nil datum-comments--font-lock-keywords)
  (when (and datum-comments-mode t) ; fill in the t with the named readtable being active when we get there

    ;; syntax
    (setq-local syntax-propertize-function #'datum-comments--syntax-propertize-function)
    (syntax-propertize (point-max))
    ;; font locking
    (font-lock-add-keywords nil datum-comments--font-lock-keywords 'append)))

(defun datum-comments-mode-enable ()
  (datum-comments-mode 1))
(defun datum-comments-mode-disable ()
  (datum-comments-mode 0))

;;; slime support
(defconst slime-reader-datum-comment-regexp
  (regexp-opt '("#;")))

(defun slime-forward-reader-datum-comment ()
  "Move past datum comments (#;)."
  (when (looking-at slime-reader-datum-comment-regexp)
    (goto-char (match-end 0))
    (slime-forward-sexp)))

;; `slime-forward-cruft' that knows about datum comments
(defun slime-forward-cruft ()
  "Move forward over whitespace, comments, reader conditionals."
  (while (slime-point-moves-p (skip-chars-forward " \t\n")
                              (inline (slime-forward-reader-datum-comment))
                              (forward-comment (buffer-size))
                              (inline (slime-forward-reader-conditional)))))

(defun slime--compile-hotspots-extra ()
  (mapc (lambda (sym)
          (cond ((fboundp sym)
                 (unless (byte-code-function-p (symbol-function sym))
                   (slime--byte-compile sym)))
                (t (error "%S is not fbound" sym))))
        '(slime-forward-cruft
          slime-forward-reader-datum-comment)))

(slime--compile-hotspots-extra)

(provide 'datum-comments)
