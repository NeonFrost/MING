#|
Handles changes in the xy coordinates of all entities
Handles deaths
Handles vector changes
Handles particle creation, lifetime, and destruction
|#

(defmacro remove-nil (lst)
  `(setf ,lst (remove nil ,lst))
  )

(defun spawn-player ()
  (defsheet player (entity-sheet player) (entity-cell-size player))
  )

(defun create-entity (e)
  (if (or (eq e 'type-a)
	  (eq e 'type-b)
	  (eq e 'type-c)
	  (eq e 'boss))
      (let* ((x-o (random *screen-width*))
	     (x-pos (if (< x-o 110)
			(entity-x player)
			x-o))
	     (e-list (if (eq e 'type-a)
			 (list (loop for x below 5
				  collect (list (make-type-a :x (- x-pos (* x 16))
							     :y (- -64 (* x 5))))))
			 (if (eq e 'type-b)
			     (list (loop for x below 3
				      collect (list (make-type-b :x (- x-pos (* x 16))
								 :y (- -64 (* x 16))))))
			     (if (eq e 'type-c)
				 (list (list (list (make-type-c :x x-pos
								:y -64
								:path (list :fired-lasers (list (* (+ (player-x player) 240) -1)
												(+ (player-x player) 240)
												(* (+ (player-x player) 240) -1)
												(+ (player-x player) 240)
												(player-x player)))))))
				 (list (list (list (make-boss :x (/ *screen-width* 2)
							:hp (* (+ (player-upgrade player)
								  (player-atk player)
								  (player-weapon player))
							       50)
							:max-hp (* (+ (player-upgrade player)
							      (player-atk player)
								      (player-weapon player))
								   50)
							)))))))))
	#|
	#######################################
	#        If the code needs to be      #
	#               commented             #
	#      Then it is either poor Code    #
	#                   Or                #
	#  You are not experienced enough to  #
	#            Understand it            #
	# I hope my code is simply the latter #
	#######################################
	 |#
	(if (not wavelist)
	    (setf wavelist e-list)
	    (setf wavelist (append wavelist e-list))
	    ))
      ))

(defun gen-enemies ()
  (loop for g in (car wavelist)
     do (loop for e in g
	   do (defsheet e (entity-sheet e) (entity-cell-size e))
	     ))
  (if (not enemies)
      (push (car wavelist) enemies)
      (setf enemies (append (list (car wavelist)) enemies)))
  (setf wavelist (cdr wavelist))
  )

(defun gen-wavelist ()
  (case (player-waves player)
    (0 (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-a))
    (1 (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-c)
       )
    (2 (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-a)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c))
    (3 (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-a)
       (create-entity 'type-a)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       (create-entity 'type-c)
       )
    (4 (create-entity 'type-a)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-b)
       (create-entity 'type-a)
       (create-entity 'type-c)
       (create-entity 'type-a)
       (create-entity 'type-a)
       (create-entity 'type-c)
       (create-entity 'type-b)
       (create-entity 'type-c)
       (create-entity 'type-a)
       (create-entity 'type-c)
       (create-entity 'type-b)
       (create-entity 'type-c)
       )
    (5 (create-entity 'boss)
       )
    )
  )

(defmacro spawn-bullet (e)
  `(let ((particles (cond ((type-a-p ,e)
			   nil)
			  ((type-b-p ,e)
			   t)
			  ((type-c-p ,e)
			   t)
			  ((player-p ,e)
			   (if (> (player-weapon ,e) 1)
			       t))
			  ((boss-p ,e)
			   t))))
     (make-bullet :has-particles particles
		  :x (+ (entity-x ,e) 16)
		  :y (if (player-p ,e)
			 (- (entity-y ,e) 2)
			 (+ (entity-y ,e) 2))
		  :vector (vec-2d:make-vector-2d :x (if (player-p ,e)
							(round (/ (player-speed-x ,e) 4))
							(round (/ (vec-2d:vector-2d-x (enemy-vector ,e)) 4)))
						 :y (if (boss-p ,e)
							24
							(if (player-p ,e)
							    -16
							    (round (/ *screen-height* 40)))))
		  :size '(2 8)
		  :color (if (player-p ,e)
			     (list 0 191 255 255)
			     (list 255 100 180 255))
		  :power (if (player-p ,e)
			     (* (+ (player-upgrade ,e) (entity-atk ,e)) (player-weapon ,e))
			     (entity-atk ,e))
		  :owner-type (if (enemy-p ,e)
				  'enemy
				  'player))
     ))

(defmethod entity-fire (e)
;;;;  (push (spawn-bullet e) (entity-bullets e))
  (push (spawn-bullet e) bullets)
  (play-sound (sample-path (entity-fire-sound e)) (if (player-p e)
						      0
						      1))
  (if (type-b-p e)
      (setf (type-b-charged e) 0))
  (if (type-c-p e)
      (incf (type-c-fired e) 1))
  )

(defmethod entity-fire-missile ((e player))
  )

(defmethod entity-fire-missile ((e boss))
  )

(defmethod entity-move (e &key d)
  (if (player-p e)
      (if (edge-collision e d)
	  (setf (player-speed-x e) 0)
	  (progn (setf (player-speed-x e) (if (eq d 'right)
					      4
					      -4))
		  (incf (entity-x e) (player-speed-x e)))
	  )
      (if (enemy-p e)
	  (if (not (enemy-killed e))
	      (progn (case (car (enemy-attack-pattern e))
		       (:player-x (if (or (eq (entity-x e) (entity-x player))
					  (and (>= (entity-x e) (- (entity-x player) 4))
					       (<= (entity-x e) (entity-x player)))
					  (and (<= (entity-x e) (+ (entity-x player) 4))
					       (>= (entity-x e) (entity-x player))))
				      (entity-fire e)))
		       (:charged (if (and (>= (type-b-charged e) 3)
					  (or (eq (entity-x e) (entity-x player))
					      (and (>= (entity-x e) (- (entity-x player) 32))
						   (<= (entity-x e) (entity-x player)))
					      (and (<= (entity-x e) (+ (entity-x player) 32))
						   (>= (entity-x e) (entity-x player)))))					      
				     (entity-fire e)))
		       )
		     (case (car (enemy-path e))
		       (:follow-player (let ((x-dir 8))
					 (if (<= (entity-y e) 96)
					     (setf (vec-2d:vector-2d-y (enemy-vector e)) 4)
					     (setf (vec-2d:vector-2d-y (enemy-vector e)) 0))
					 (if (< (entity-x e) (entity-x player))
					     (cond ((> (round (/ (entity-max-hp e) 4)) (- (entity-max-hp e) (entity-hp e)))
						    (* x-dir 2))
						   ((> (round (/ (entity-max-hp e) 2)) (- (entity-max-hp e) (entity-hp e)))
						    (* x-dir 3))
						   ((> (round (* (/ (entity-max-hp e) 4) 3)) (- (entity-max-hp e) (entity-hp e)))
						    (* x-dir 4))
						   (t
						    x-dir))
					     (cond ((> (round (/ (entity-max-hp e) 4)) (- (entity-max-hp e) (entity-hp e)))
						    (* (* x-dir 2) -1))
						   ((> (round (/ (entity-max-hp e) 2)) (- (entity-max-hp e) (entity-hp e)))
						    (* (* x-dir 3) -1))
						   ((> (round (* (/ (entity-max-hp e) 4) 3)) (- (entity-max-hp e) (entity-hp e)))
						    (* (* x-dir 4) -1))
						   (t
						    (* x-dir -1))
						   ))))
		       (:edge (if (edge-collision e (if (> (vec-2d:vector-2d-x (enemy-vector e)) 0)
							'right
							'left))
				  (setf (vec-2d:vector-2d-x (enemy-vector e)) (* (vec-2d:vector-2d-x (enemy-vector e)) -1))))
		       (:fired-lasers (if (>= (type-c-fired e) 10)
					  (setf (type-c-path-num e) 0))
				      (if (and (>= (type-c-fired e) 5)
					       (<= (vec-2d:vector-2d-x (enemy-vector e)) 5)
					       (<= (entity-y e) 64))
					  (progn (setf (vec-2d:vector-2d-x (enemy-vector e)) (round (/ (nth (type-c-path-num e) (cadr (enemy-path e))) 100)))
						 (setf (vec-2d:vector-2d-y (enemy-vector e)) 12) ;;;;(round (/ (- (entity-y player) (entity-y e)) 10)))
						 (incf (type-c-path-num e) 1))
					  )
				      
				      ))
		     (if (type-c-p e)
			 (progn (if (< (type-c-path-num e) 1)
				    (progn (if (<= (entity-y e) 32)
					       (setf (vec-2d:vector-2d-y (enemy-vector e)) 12)
					       (if (and (>= (entity-y e) 48)
							(<= (entity-y e) 64))
						   (setf (vec-2d:vector-2d-y (enemy-vector e)) 0)))
					   (if (< (entity-x e) (entity-x player))
					       (setf (vec-2d:vector-2d-x (enemy-vector e)) 8)
					       (setf (vec-2d:vector-2d-x (enemy-vector e)) -8)))
				    (if (>= (entity-y e) (entity-y player))
					(vec-2d:scalar-multiply (enemy-vector e) -1)
					    #|(progn (setf (vec-2d:vector-2d-x (enemy-vector e)) (* (vec-2d:vector-2d-x (enemy-vector e)) -1))
					    (setf (vec-2d:vector-2d-y (enemy-vector e)) (* (vec-2d:vector-2d-y (enemy-vector e)) -1))|#
					))))
		     (if (and (entity-sheet-surface e)
			      (entity-sheet-surface player))
			 (if (enemy-collision e)
			     (progn (decf (entity-hp player) 2)
				    (kill-entity e))
			     (progn (incf (entity-x e) (vec-2d:vector-2d-x (enemy-vector e)))
				    (incf (entity-y e) (vec-2d:vector-2d-y (enemy-vector e)))
				    (if (type-b-p e)
					(incf (type-b-charged e) 1))
				    )
			     ))))
	  )))

(defun enemy-collision (e) ;tests collision with player
  (let ((p-x-m (caddr (car (sprite-sheet-cells (entity-sheet-surface player)))))
	(p-y-m (cadddr (car (sprite-sheet-cells (entity-sheet-surface player)))))
	(e-x-m (caddr (car (sprite-sheet-cells (entity-sheet-surface e)))))
	(e-y-m (cadddr (car (sprite-sheet-cells (entity-sheet-surface e)))))
	)
    (if (or (and (<= (entity-y player)
		     (entity-y e));test the y position of entity and player
		 (>= (+ (entity-y player) p-y-m)
		     (entity-y e)))
	    (and (<= (entity-y player)
		     (+ (entity-y e) e-y-m))
		 (>= (+ (entity-y player) p-y-m)
		     (+ (entity-y e) e-y-m)))
	    )
	(if (or (and (<= (entity-x player)
			 (entity-x e))
		     (>= (+ (entity-x player) p-x-m)
			 (entity-x e)))
		(and (<= (entity-x player)
			 (+ (entity-x e) e-x-m))
		     (>= (+ (entity-x player) p-x-m)
			 (+ (entity-x e) e-x-m)))
		)
	    t))))

(defun edge-collision (e d)
  (case d
    (right (if (>= (+ (entity-x e) 32) *screen-width*) ;get rid of that hard coded number in the near future
	       t))
    (left (if (<= (entity-x e) 0)
	      t))
    )
  )

(defun generate-explosions (x y num)
  (loop for explosion below num
     do (let ((x-o (+ (+ x 16) (random 4)))
	      (y-o (+ (+ y 16) (random 4))))
	  (create-particle (vec-2d:make-vector-2d :x (if (> x-o (+ x 16))
							 4
							 -4)
						  :y (if (> y-o (+ y 16))
							 4
							 -4))
			   (list x-o y-o 4 4)
			   8
			   '(200 180 0 255)
			   explosions)
	  ))
  )

(defmethod kill-entity ((e enemy))
  (if (<= (entity-hp e) 0)
      (progn (generate-explosions (entity-x e) (entity-y e) 16);do some explosions
	     (setf (enemy-killed e) t)
	     (incf (player-kills player) 1)
	     (setf (entity-y e) (+ *screen-height* 32))
	     (free-sheet (entity-sheet-surface e)))
      (progn (free-sheet (entity-sheet-surface e))
	     (setf e nil)))
  ); explosion at + entity-x (/ size-x entity 2) and + entity-y (/ size-y entity 2)

(defmethod kill-entity ((e boss))
  (generate-explosions (entity-x e) (entity-y e) 64)
;;;;Causes explosions at 'random' places on the boss
  (free-sheet (entity-sheet-surface e))
  (setf e nil)
  ;;;;Get rid of the entity after all the explosions are processed
  (setf state 'credits)
;;;;sets the state to credits (unless it's an 'endless' mode, then just increases the diff)
  )

(defmethod kill-entity ((e player))
  (generate-explosions (entity-x e) (entity-y e) 4)
  (setf state 'game-over)
  (free-sheet (entity-sheet-surface e))
  )

(defmethod remove-group (type group)
  (let ((t-p (position type enemies)))
    #|
    #######################################
    Why t-p? Because when it does the setf of t-p of enemies to nil, and then proceeds to use (position type enemies)
    the code runs into a interesting little error. You see, (position type enemies) returns a number. If the (nth (position type enemies) enemies) is nil, then...
    It returns nil for the position
    It's like erasing milk from a grocery list and then trying to find where milk is on the grocery list
    You can't find it because it got erased, so you get absolutely confused about why you were asked to find milk on the list when it was erased
    A good way to avoid this in code that is not this, is to do (if (position item seq) &body) so that it checks to make sure that point is not nil
    I do believe that solution was put into my RPG engine, but I forgot about it, I guess. If not, I'll put it in there.
    #######################################
    |#
    (if t-p
	(progn (if (every #'enemy-is-killed group)
		   (progn (incf (player-groups player) 1)
			  (setf (nth (position group (nth t-p enemies))
				     (nth t-p enemies)
				     ) nil)
			  (remove-nil (nth t-p enemies))
			  (remove-nil group))
		   (if (every #'enemy-dead group)
		       (progn (setf (nth (position group (nth t-p enemies))
					 (nth t-p enemies)
					 ) nil)
			      (remove-nil (nth t-p enemies))
			      (remove-nil group))
		       )))))
  (remove-nil enemies)
  ) ;loops through the enemies list and checks if a sub-list is all killed

(defun enemy-is-killed (e)
  (if (enemy-p e)
      (enemy-killed e)
      )
  )

(defun enemy-dead (e)
  (or (enemy-is-killed e)
      (> (entity-y e) (+ *screen-height* 96))
      (< (entity-y e) -392)
      (> (entity-x e) (+ *screen-width* 256))
      (< (entity-x e) -256)
      )
  )		  

(defmethod move-bullet (b)
  (let ((x-dir (if (eq (vec-2d:vector-2d-x (bullet-vector b)) 0)
		   nil
		   t)))
    (if (bullet-collision b)
	(setf (nth (position b bullets) bullets) nil)
	(progn (incf (bullet-x b) (vec-2d:vector-2d-x (bullet-vector b)))
	       (incf (bullet-y b) (vec-2d:vector-2d-y (bullet-vector b)))
	       )
	)))

(defmethod entity-hit (e b)
  (let ((e-t (if (enemy-p e)
		 'enemy
		 'player))
	(b-t (bullet-owner-type b)))
    (if (not (eq e-t b-t))
	(progn (decf (entity-hp e) (bullet-power b))
	       (if (<= (entity-hp e) 0)
		   (kill-entity e)))
	)
    ))

(defmethod bullet-collision (b)
  (if (eq (bullet-owner-type b) 'enemy)
      (if (entity-sheet-surface player)
	  (if (bullet-collide b player)
	      (progn (entity-hit player b)
		     t)
	      ))
      (loop named test-bullet for type in enemies
	 do (loop for group in type
	       do (loop for e in group
		     do (if (entity-sheet-surface e)
			    (if (bullet-collide b e)
				(progn (entity-hit e b)
				       (return-from test-bullet t))
				))))
      )))

(defmethod bullet-collide (b e)
  (let ((e-x (entity-x e))
	(e-y (entity-y e))
	(e-x-m (caddr (car (sprite-sheet-cells (entity-sheet-surface e)))))
	(e-y-m (cadddr (car (sprite-sheet-cells (entity-sheet-surface e)))))
	(b-x (bullet-x b))
	(b-y (bullet-y b))
	(b-x-m (car (bullet-size b)))
	(b-y-m (cadr (bullet-size b)))
	)
    (if (or (and (<= e-y
		     b-y);test the y position of entity and player
		 (>= (+ e-y e-y-m)
		     b-y))
	    (and (<= e-y
		     (+ b-y b-y-m))
		 (>= (+ e-y e-y-m)
		     (+ b-y b-y-m)))
	    )
	(if (or (and (<= e-x
			 b-x)
		     (>= (+ e-x e-x-m)
			 b-x))
		(and (<= e-x
			 (+ b-x b-x-m))
		     (>= (+ e-x e-x-m)
			 (+ b-x b-x-m)))
		)
	    t))))

(defmethod show-bullet-particles (b)
  (if (< (length (bullet-particles b)) 16)
      (let ((x (bullet-x b))
	    (y (bullet-y b)))
	(create-particle (vec-2d:make-vector-2d :x (if (eq (random 2) 0)
						       (* (random 8) -1)
						       (random 8))
						:y (* (random 16) -1))
			 (list x y 4 4)
			 16
			 (list 210 10 10 255)
			 (bullet-particles b))
	))
  (render-particles (bullet-particles b))
  (remove-nil (bullet-particles b))
  #|  (loop for particle in (bullet-particles b) ;;;;generalize this into a function eventually
  do (if particle
  (particle-effect particle))
  (loop for x below (1- (length particles))
  do (let ((lifetime (particle-lifetime (nth x particles)))
  (duration (particle-duration (nth x particles))))
  (if (>= lifetime duration)
  (progn (setf (nth x particles) nil); (kill-particle particle)
  (remove-nil particles)))))
  ))
  |#
  )
