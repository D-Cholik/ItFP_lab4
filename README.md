<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 4</b><br/>
"Функції вищого порядку та замикання"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент</b>: Чоловенко Дмитро КВ-13</p>
<p align="right"><b>Рік</b>: 2024</p>

## Загальне завдання
Завдання складається з двох частин:
1. Переписати функціональну реалізацію алгоритму сортування з лабораторної роботи 3 з такими змінами: 
* використати функції вищого порядку для роботи з послідовностями (де це доречно);
* додати до інтерфейсу функції (та використання в реалізації) два ключових параметра: ```key``` та ```test``` , що працюють аналогічно до того, як працюють параметри з такими назвами в функціях, що працюють з послідовностями. При цьому ```key``` має виконатись мінімальну кількість разів.
2. Реалізувати функцію, що створює замикання, яке працює згідно із завданням за варіантом (див. п 4.1.2). Використання псевдо-функцій не забороняється, але, за можливості, має бути мінімізоване.

## Варіант першої частини 4(20)
Алгоритм сортування вставкою No2 (з лінійним пошуком справа) за незменшенням.
## Лістинг реалізації першої частини завдання
```lisp
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
```
### Тестові набори та утиліти першої частини
```lisp
(defun check-insertion-sort (name input expected &key (key #'identity) (test #'<))
  (format t "~:[FAILED~;passed~]... ~a~%"
          (equal (insertion-sort input :key key :test test) expected)
          name))

(defun test-insertion-sort ()
  (check-insertion-sort "test 1" '(3 1 4 1 5 9 2) '(1 1 2 3 4 5 9))
  (check-insertion-sort "test 2" '(10 5 7 2 8) '(2 5 7 8 10))
  (check-insertion-sort "test 3" '("b" "c" "a") '("a" "b" "c") :key #'identity :test #'string<)
  (check-insertion-sort "test 4" '(3 1 4 1 5 9 2) '(9 5 4 3 2 1 1) :test #'>))

  (defun run-all-tests ()
  (format t "=== Tests for insertion-sort ===~%")
  (test-insertion-sort)
  (format t "=== Tests for remove-each-rnth-reducer ===~%")
  (test-remove-each-rnth-reducer))

(run-all-tests)
```
### Тестування першої частини
```lisp
=== Tests for insertion-sort ===
passed... test 1
passed... test 2
passed... test 3
passed... test 4
```
## Варіант другої частини 8(20)
Написати функцію remove-each-rnth-reducer , яка має один основний параметр n та
один ключовий параметр — функцію key . remove-each-rnth-reducer має повернути
функцію, яка при застосуванні в якості першого аргумента reduce робить наступне: при
обході списку з кінця, кожен n -ний елемент списку-аргумента reduce , для якого
функція key повертає значення t (або не nil ), видаляється зі списку. Якщо
користувач не передав функцію key у remove-each-rnth-reducer , тоді зі списку
видаляється просто кожен n -ний елемент. Обмеження, які накладаються на
використання функції-результату remove-each-rnth-reducer при передачі у reduce
визначаються розробником (тобто, наприклад, необхідно чітко визначити, якими мають
бути значення ключових параметрів функції reduce from-end та initial-value )..

```lisp
CL-USER> (reduce (remove-each-rnth-reducer 2)

'(1 2 3 4 5)
:from-end ...
:initial-value ...)

(1 3 5)
CL-USER> (reduce (rpropagation-reducer :key #'evenp)

'(1 2 2 2 3 4 4 4 5)
:from-end ...
:initial-value ...)

(1 2 3 4 4 5)
```
## Лістинг реалізації другої частини завдання
```lisp
(defun remove-each-rnth-reducer (n &key (key #'identity))
  (let ((count 0)) 
    (lambda (acc item)
      (setq count (1+ count)) 
      (if (and (zerop (mod count n))(funcall key item))     
          acc                       
          (cons item acc)))))  
```
### Тестові набори та утиліти другої частини
```lisp
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
  (format t "=== Tests for insertion-sort ===~%")
  (test-insertion-sort)
  (format t "=== Tests for remove-each-rnth-reducer ===~%")
  (test-remove-each-rnth-reducer))

(run-all-tests)

```
### Тестування другої частини
```lisp
=== Tests for remove-each-rnth-reducer ===
passed... test 1
passed... test 2
passed... test 3
passed... test 4: key=evenp
passed... test 5: key=oddp
```
