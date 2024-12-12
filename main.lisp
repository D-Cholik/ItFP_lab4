(defun insertion-sort (list &key (key #'identity) (test #'<))
  (let ((reversed-list (reverse list))
        (result nil))
    (dolist (element reversed-list (nreverse result)) 
      (let ((mapped-element (funcall key element))
            (sorted nil)
            (remaining result))
        (loop for x in result
              while (funcall test mapped-element (funcall key x))
              do (progn
                   (push (pop remaining) sorted)))
        (setf result (append (nreverse sorted) (list element) remaining))))))

(defun check-insertion-sort (name input expected &key (key #'identity) (test #'<))
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (insertion-sort input :key key :test test) expected)
          name))

(defun test-insertion-sort ()
  (check-insertion-sort "test 1" '(3 1 4 1 5 9 2) '(1 1 2 3 4 5 9))
  (check-insertion-sort "test 2" '(10 5 7 2 8) '(2 5 7 8 10))
  (check-insertion-sort "test 3" '("b" "c" "a") '("a" "b" "c") :key #'identity :test #'string<)
  (check-insertion-sort "test 4" '(3 1 4 1 5 9 2) '(9 5 4 3 2 1 1) :test #'>))

(defun remove-each-rnth-reducer (n &key (key #'identity))
  (let ((count 0)) 
    (lambda (acc item)
      (setq count (1+ count)) 
      (if (and (zerop (mod count n))(funcall key item))     
          acc                       
          (cons item acc)))))        

(defun check-remove-each-rnth-reducer (name input expected &key (key #'identity))
  (let ((result (reduce (remove-each-rnth-reducer 2 :key key) (reverse input) :initial-value '()))) 
    (format t "~:[FAILED~;passed~]... ~a~%" (equal result expected) name)))

(defun test-remove-each-rnth-reducer ()
  (check-remove-each-rnth-reducer "test 1" '(1 2 3 4 5) '(1 3 5)) 
  (check-remove-each-rnth-reducer "test 2" '(1 2 2 2 3 4 4 4 5) '(1 2 3 4 5)) 
  (check-remove-each-rnth-reducer "test 3" '(1 2 3 4 5 6 7 8 9 10) '(2 4 6 8 10)) 
  (check-remove-each-rnth-reducer "test 4: key=evenp" '(1 2 3 4 5 6 7 8 9 10 11) '(1 3 5 7 9 11) :key #'evenp) 
  (check-remove-each-rnth-reducer "test 5: key=oddp" '(1 2 3 4 5 6 7 8 9 10) '(2 4 6 8 10) :key #'oddp)) 

(defun run-all-tests ()
  "Виконує всі тести."
  (format t "=== Tests for insertion-sort ===~%")
  (test-insertion-sort)
  (format t "=== Tests for remove-each-rnth-reducer ===~%")
  (test-remove-each-rnth-reducer))

(run-all-tests)
