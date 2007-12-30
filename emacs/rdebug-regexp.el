;;; rdebug-regexp.el --- Ruby debugger regular expressions

;; Copyright (C) 2007 Rocky Bernstein (rocky@gnu.org)
;; Copyright (C) 2007 Anders Lindgren

;; $Id$

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;
;; Introduction:
;;
;; Here we have regular expressions and names for matched patterns
;; of those regular expressions.
;;
(defconst rdebug-annotation-start-regexp
  "\\([a-z]+\\)\n"
  "Regular expression to match the start of an annotation.
Note that in contrast to gud-rdebug-marker-regexp, we don't allow a colon.
That's what distinguishes the two." )

(defconst rdebug-annotation-end-regexp
  "\n"
  "Regular expression to match the end of an annotation.")

(defconst rdebug--breakpoint-regexp
  "^\\ +\\([0-9]+\\) \\([yn]\\) +at +\\(.+\\):\\([0-9]+\\)$"
  "Regexp to recognize breakpoint lines in rdebug breakpoint buffers.")

(defconst gud-rdebug-marker-regexp
  "^\\(\\(?:[a-zA-Z]:\\)?[^:\n]*\\):\\([0-9]*\\).*\n"
  "Regular expression used to find a file location given by rdebug.

Program-location lines look like this:
   /tmp/gcd.rb:29:  gcd
   /tmp/gcd.rb:29
   C:/tmp/gcd.rb:29
   \\sources\\capfilterscanner\\capanalyzer.rb:3:  <module>
")

(defconst rdebug-marker-regexp-file-group 2
  "Group position in `rdebug-position-regexp' that matches the file name.")

(defconst rdebug-marker-regexp-line-group 3
  "Group position in `rdebug-position-regexp' that matches the line number.")

(defconst rdebug-position-regexp
  "\\(\\)\\([-a-zA-Z0-9_/.]*\\):\\([0-9]+\\)"
  "Regular expression for a rdebug position")

(defconst rdebug-traceback-line-re
  "^[ \t]+from \\([^:]+\\):\\([0-9]+\\)\\(in `.*'\\)?"
  "Regular expression that describes a Ruby traceback line.")

(defconst rdebug-dollarbang-traceback-line-re
  "^[ \t]+[[]?\\([^:]+\\):\\([0-9]+\\):in `.*'"
  "Regular expression that describes a Ruby traceback line from $! list.")

(defconst rdebug--stack-frame-1st-regexp
  "^\\(-->\\|   \\) +#\\([0-9]+\\)\\(.*\\)"
  "Regexp to match the first line of a stack frame in rdebug stack buffers.")

(defconst rdebug--stack-frame-2nd-regexp
  "\s+at line +\\([^:]+\\):\\([0-9]+\\)$"
  "Regexp to match the second line of a stack frame in rdebug stack buffers.")

(defconst rdebug--stack-frame-regexp
  (concat rdebug--stack-frame-1st-regexp rdebug--stack-frame-2nd-regexp)
  "Regexp to recognize a stack frame line in rdebug stack buffers.")



(provide 'rdebug-regexp)

;;; Local variables:
;;; eval:(put 'rdebug-debug-enter 'lisp-indent-hook 1)
;;; End:

;;; rdebug-regexp.el ends here
