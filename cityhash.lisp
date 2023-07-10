(in-package #:org.shirakumo.random-state)

(define-generator cityhash-64 64 (hash-generator) ()
  (:copy
   (make-cityhash-64 :%seed (cityhash-64-%seed generator)
                     :index (cityhash-64-index generator)))
  (:hash
   (declare (optimize speed (safety 1)))
   (let ((k2 #x9ae16a3b2f90404f))
     (flet ((hashlen16 (low high &optional (kmul #x9ddfea08eb382d69))
              (declare (type (unsigned-byte 64) low high kmul))
              (let ((a (fit-bits 64 (* kmul (logxor low high)))))
                (update 64 a logxor (ash a -47))
                (let ((b (fit-bits 64 (* kmul (logxor high a)))))
                  (update 64 b logxor (ash b -47))
                  (update 64 b * kmul))))
            (rotate (val shift)
              (declare (type (unsigned-byte 64) val))
              (declare (type (unsigned-byte 32) shift))
              (logior (ash val (- shift))
                      (ash val (- 64 shift)))))
       (declare (inline hashlen16 rotate))
       (let* ((mul (fit-bits 64 (+ k2 (* 8 2))))
              (a (fit-bits 64 (+ index k2)))
              (b (fit-bits 64 index))
              (c (fit-bits 64 (+ a (* mul (rotate b 37)))))
              (d (fit-bits 64 (* mul (+ b (rotate a 25))))))
         (hashlen16 (- (hashlen16 c d mul) k2)
                    seed))))))