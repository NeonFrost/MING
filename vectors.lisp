(defpackage :vec-2d
  (:use :cl)
  (:export #:make-vector-2d
	   #:vector-2d-x
	   #:vector-2d-y
	   #:vector-add
	   #:vector-sub
	   #:vector-dot
	   #:scalar-multiply))

(in-package :vec-2d)

(defstruct vector-2d
  (x 0)
  (y 0))

(defmacro vector-add (vec1 vec2)
  `(progn (setf (vector-2d-x ,vec1) (+ (vector-2d-x ,vec1) (vector-2d-x ,vec2)))
;	  (setf (vector-2d-y ,vec1) (+ (vector-2d-y ,vec1) (vector-2d-x ,vec2)))
	  (setf (vector-2d-y ,vec1) (+ (vector-2d-y ,vec1) (vector-2d-y ,vec2)))
	  ))
(defmacro vector-sub (vec1 vec2)
  `(progn (setf (vector-2d-x ,vec1) (- (vector-2d-x ,vec1) (vector-2d-x ,vec2)))
;	  (setf (vector-2d-y ,vec1) (- (vector-2d-y ,vec1) (vector-2d-x ,vec2)))
	  (setf (vector-2d-y ,vec1) (- (vector-2d-y ,vec1) (vector-2d-y ,vec2)))	  
	  ))
#|(defmacro vector-cross (vec1 vec2 vec3)
  `(progn (setf (vector-2d-x ,vec3) (
     )) vector-cross products not possible on 2D planes
|#
(defmacro vector-dot (vec1 vec2)
  `(+ (* (vector-2d-x ,vec1) (vector-2d-x ,vec2)) (* (vector-2d-y ,vec1) (vector-2d-y ,vec2)))) ;returns a scalar
(defmacro scalar-multiply (vec1 scalar)
  `(progn (setf (vector-2d-x ,vec1) (* (vector-2d-x ,vec1) ,scalar))
	  (setf (vector-2d-y ,vec1) (* (vector-2d-y ,vec1) ,scalar))
	  ))
