#|
Uses vectors to move from one location to the next


|#
(defmacro draw-particle (rect color)
  `(let ((r (car ,color))
	 (g (cadr ,color))
	 (b (caddr ,color))
	 (a (cadddr ,color))
	 )
     (sdl2:set-render-draw-color renderer r g b a)
     (sdl2:render-fill-rect renderer ,rect)
;;;; (blit rect nil screen-surface nil)
     )
  )

(defstruct particle
  vector
  size
  duration
  (lifetime 0)
  color)

#|
On 'z'
it creates a new particle
this particle has no 'name', it just has a gensym as a name
|#

(defmacro create-particle (vector size duration color particles)
  `(push-particle (make-particle :vector ,vector :size ,size :duration ,duration :color ,color) ,particles)
  )
(defmacro decay-particle (particle)
  `(progn (setf (particle-lifetime ,particle) (1+ (particle-lifetime ,particle)))
	  (setf (car (particle-size ,particle)) (+ (vec-2d:vector-2d-x (particle-vector ,particle)) (car (particle-size ,particle))))
	  (setf (cadr (particle-size ,particle)) (+ (vec-2d:vector-2d-y (particle-vector ,particle)) (cadr (particle-size ,particle))))
	  )
  )
(defmacro kill-particle (particle)
  `(setf ,particle nil)
  )
(defmacro push-particle (particle particles)
  `(if ,particles
       (setf ,particles (append ,particles (list ,particle)))
       (setf ,particles (list ,particle))
       ))
#|
(let ((vec (make-vector-2d :x 15 :y 20)))
  (setq particles (list (create-particle vec '(10 20 30 40) 15 '(200 200 200 255))))
  (do-particle (car particles))
  )

(defun do-particle (particle)
  (loop for x from 0 to (particle-duration particle)
     do 
       (decay-particle particle)
       (particle-effect particle)
       (princ (particle-lifetime particle))
       (fresh-line)
       )
  )
|#
(defun particle-effect (particle) ;size is a list of values '(x y w h) for a sdl2 rectangle
  (if particle
      (let* ((vector (particle-vector particle))
	     (color (particle-color particle))
	     (size (particle-size particle))
	     (duration (particle-duration particle))
	     (lifetime (particle-lifetime particle))
	     (rect (sdl2:make-rect (car size)
				   (cadr size)
				   (caddr size)
				   (cadddr size)))
	     (random (car (cdr (cdddr color))))
	     (r (car color))
	     (g (cadr color))
	     (b (caddr color))
	     (a (cadddr color))
	     )
	(if (> duration lifetime)
	    (draw-particle rect (list r g b a)))
	(sdl2:free-rect rect)
	(decay-particle particle)
#|	(if (> lifetime duration)
	    (sdl2:free-rect rect))|#
	)))
