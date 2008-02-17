;;; rdebug-watch.el --- Ruby debugger (short and simple) key bindings
;;; and minor mode.

;; Copyright (C) 2008 Rocky Bernstein (rocky@gnu.org)
;; Copyright (C) 2008 Anders Lindgren

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

;; This file contains code which add short simple key bindings to buffers
;; which are part of an part of an rdebug session. It also handles
;; minor mode setting of these buffers.

;;; Code:
;; -------------------------------------------------------------------
;; Source short key mode.
;;
;; When this minor mode is active and the debugger is running, the
;; source window displaying the current debugger frame is marked as
;; read-only and the short keys of the secondary windows can be used,
;; for example, you can use the space-bar to single-step the program.

;; Implementation note:
;;
;; This is presented to the user as one global minor mode. However,
;; under the surface the real work is done by another, non-global,
;; minor mode named "local short key mode". This is activated and
;; deactivated appropriately by the Rdebug filter functions.

;; Implementation note: This is the user-level command. It only
;; controls if `rdebug-internal-short-key-mode' should be activated or
;; not.

(define-minor-mode rdebug-short-key-mode
  "When enabled, short keys can be used in source buffers in `rdebug'."
  :group 'rdebug
  :global t
  :init-value nil
  ;; Unless the debugger is running, activating this doesn't do
  ;; anything.
  (if (featurep 'rdebug-core)
      (with-no-warnings
        (rdebug-short-key-mode-maybe-activate))))

(defvar rdebug-internal-short-key-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "b" 'gud-break)
    (define-key map "t" 'rdebug-toggle-source-breakpoint-enabled)
    (define-key map [insert] 'rdebug-short-key-mode)
    ;;(define-key map "p" 'gud-print)
    (rdebug-populate-secondary-buffer-map-plain map)
    map)
  "Keymap used in `rdebug-internal-short-key-mode'.")

(defvar rdebug-original-read-only :off
  "The value `buffer-read-only' should be restored to after short key mode.

When :off, the mode is not active.")

;; Implementation note: This is the mode that does all the work, it's
;; local to the buffer that is affected.
(define-minor-mode rdebug-internal-short-key-mode
  "Minor mode with short keys for source buffers for the `rdebug' debugger.
The buffer is read-only when the minor mode is active.

Note that this is for internal use only, please use the global
mode `rdebug-short-key-mode'.

\\{rdebug-internal-short-key-mode-map}"
  :group 'rdebug
  :global nil
  :init-value nil
  :lighter " ShortKeys"
  :keymap rdebug-internal-short-key-mode-map
  (make-local-variable 'rdebug-original-read-only)
  ;; Note, without the third state, :off, activating the mode more
  ;; than once would overwrite the real original value.
  (if rdebug-internal-short-key-mode
      (progn
        (if (eq rdebug-original-read-only :off)
            (setq rdebug-original-read-only buffer-read-only))
        (setq buffer-read-only t))
    (setq buffer-read-only rdebug-original-read-only)
    (setq rdebug-original-read-only :off)))


(defun rdebug-buffer-killed-p (buffer)
  "Return t if BUFFER is killed."
  (not (buffer-name buffer)))

(defun rdebug-internal-short-key-mode-on ()
  "Turn on `rdebug-internal-short-key-mode' in the current debugger frame."
  (rdebug-debug-enter "rdebug-internal-short-key-mode-on"
    (save-current-buffer
      (if (and gud-comint-buffer
               (not (rdebug-buffer-killed-p gud-comint-buffer)))
          (set-buffer gud-comint-buffer))
      (let ((frame (or gud-last-frame
                       gud-last-last-frame)))
        (if (and frame
                 rdebug-short-key-mode)
            (ignore-errors
              ;; `gud-find-file' calls `error' if it doesn't find the file.
              (let ((buffer (gud-find-file (car frame))))
                (save-current-buffer
                  (set-buffer buffer)
                  (rdebug-internal-short-key-mode 1)))))))))


(defun rdebug-turn-on-short-key-mode ()
  "Turn on `rdebug-short-key-mode'.

This function is designed to be used in a user hook, for example:

    (add-hook 'rdebug-mode-hook 'rdebug-turn-on-short-key-mode)"
  (interactive)
  (rdebug-short-key-mode 1))


(defun rdebug-short-key-mode-maybe-activate ()
  (if rdebug-short-key-mode
      (rdebug-internal-short-key-mode-on)
    (rdebug-internal-short-key-mode-off)))


(defun rdebug-internal-short-key-mode-off ()
  "Turn off `rdebug-internal-short-key-mode' in all buffers."
  (rdebug-debug-enter "rdebug-internal-short-key-mode-off"
    (save-current-buffer
      (dolist (buf (buffer-list))
        (set-buffer buf)
        (if rdebug-internal-short-key-mode
            (rdebug-internal-short-key-mode -1))))))

(provide 'rdebug-shortkey)

;;; Local variables:
;;; eval:(put 'rdebug-debug-enter 'lisp-indent-hook 1)
;;; End:

;;; rdebug-shortkey.el ends here