;;; -*- coding:big5 -*-

;;; 
(defun c:e-get ()
  "選擇一個物件，觀察內部資料"
  (entget (car (entsel))))

;;;
(defun c:app-add-fu ()
  (load "fu-acaddoc.lsp"))

;;; 在線上依長度插入圖塊，使用多點平分段線。
;; 圖塊名稱
(defun *block-name* ()
  ;;圖塊名稱
  "s1")

(defun *l-lengthen* ()
  ;;間隔長度
  3)

(defun c:div-s1 ()
  (princ "多點，PLINE ")
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

;;;　在物件長度小於 3 時，插入頭尾各一的圖塊
;;;
(defun insert-block-fu (entname)
  "插入圖塊"
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
	    ;; lwpolyline 複合點
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
