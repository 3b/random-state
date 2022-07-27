#|
 This file is a part of random-state
 (c) 2015 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.random-state)

(define-generator kiss11 32 (stateful-generator)
  ((q (32bit-seed-array 4194304 0) :type (simple-array (unsigned-byte 32) (4194304)))
   (carry 0 :type (unsigned-byte 32))
   (j 4194303 :type (unsigned-byte 32))
   (cng 123456789 :type (unsigned-byte 32))
   (xs 362436069 :type (unsigned-byte 32)))
  (:reseed
   (setf q (32bit-seed-array 4194304 seed)))
  (:next
   (setf cng (fit-bits 32 (+ (* cng 69069) 13579)))
   (update 32 xs logxor (ash xs +13))
   (update 32 xs logxor (ash xs -17))
   (update 32 xs logxor (ash xs +5))
   (setf j (logand (1+ j) 4194303))
   (let* ((x (aref q j))
          (tt (fit-bits 32 (+ carry (ash x 28)))))
     (setf carry (- (ash x -4) (ash tt x)))
     (setf (aref q j) (- tt x)))
   (+ (aref q j) cng xs)))