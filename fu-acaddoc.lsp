;;; -*- coding:big5 -*-

;;; 
(defun c:e-get ()
  "��ܤ@�Ӫ���A�[������"
  (entget (car (entsel))))

;;;
(defun c:app-add-fu ()
  (load "fu-acaddoc.lsp"))

;;; �b�u�W�̪��״��J�϶��A�ϥΦh�I�����q�u�C
;; �϶��W��
(defun *block-name* ()
  ;;�϶��W��
  "s1")

(defun *l-lengthen* ()
  ;;���j����
  3)

(defun c:div-s1 ()
  (princ "�h�I�APLINE ")
  ((lambda (x)
     (defun foo (z)
       (if (not (car z))
	   "done"
	   (if (equal (cons 0 (car z)) (assoc 0 (entget x)))
	       (car z)
	       (foo (cdr z)))))
     
     (if (not (foo (list "LWPOLYLINE" "LINE" "ARC")))
	 "done"
	 ((lambda (y) 
	    (if (< y 2)
		(insert-block-fu x)
		(command "_.divide" x "B" (*block-name*) "Y" y)))
	  (1+ (/ (fix ((lambda ()
			 (command "_.lengthen" x (command) (command))
			 (getvar "perimeter"))))
		 (*l-lengthen*))))))
   (car (entsel))))

;;;�@�b������פp�� 3 �ɡA���J�Y���U�@���϶�
;;;
(defun insert-block-fu (entname)
  "���J�϶�"
  ((lambda (x)
     (cond ((equal (cons 0 "LINE") (assoc 0 x))
	    (insert-one-block (cdr (assoc 10 x)))
	    (insert-one-block (cdr (assoc 11 x)))
	    "done")
	   ((equal (cons 0 "ARC") (assoc 0 x))
	    (insert-one-block (polar (cdr (assoc 10 x))
				     (cdr (assoc 50 x))
				     (cdr (assoc 40 x))))
	    (insert-one-block (polar (cdr (assoc 10 x))
				     (cdr (assoc 51 x))
				     (cdr (assoc 40 x))))
	    "done")
	   ((equal (cons 0 "LWPOLYLINE") (assoc 0 x))
	    ;; lwpolyline �ƦX�I
	    ((lambda (y)
	       (print y)
	       (while (car y)
		 (if (equal (caar y) 10)
		     (insert-one-block (cdar y)))
		 (setq y (cdr y))))
	     (member (cons 100 "AcDbPolyline") x))

	    "done")
	   (t
	    "done")))
   (entget entname)))

(defun insert-one-block (point)
  ((lambda (x)
     (if (not x)
	 "done"
	 (command "_.insert" (*block-name*) x "" "" "")))
   point))
