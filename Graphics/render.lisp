(defun render-main-menu ()
  (render-string "MING" (- (/ *screen-width* 2) 24) 16)
  (render-selector)
  (render-string "Start Game" (- (round (/ *screen-width* 2)) 64) (- (round (/ *screen-height* 2)) 64))
  (render-string "Scores" (- (round (/ *screen-width* 2)) 64) (- (round (/ *screen-height* 2)) 32))
  (render-string "Options" (- (round (/ *screen-width* 2)) 64) (round (/ *screen-height* 2)))
  (render-string "Help" (- (round (/ *screen-width* 2)) 64) (+ (round (/ *screen-height* 2)) 32))
  (render-string "Exit Game" (- (round (/ *screen-width* 2)) 64) (+ (round (/ *screen-height* 2)) 64))
  )

(defun render-selector ()
  (render-box (- (round (/ *screen-width* 2)) 80)
	      (- (+ (- (round (/ *screen-height* 2)) 32)
		    (* selection 32))
		 32)		    
	      16
	      16
	      '(255 255 255 255))
  )

(defun render-level ()
  (if player
      (if (entity-sheet-surface player)
	  (render-entity player)))
#|		   (if (player-bullets player)
		       (loop for b in (entity-bullets player)
			  do (render-bullet b)
			    )))))|#
  (if enemies
      (loop for type in enemies
	 do (loop for group in type
	       do (loop for enemy in group
		     do (if (and (not (enemy-killed enemy))
				 (entity-sheet-surface enemy))
			    (render-entity enemy))
#|		       (if (entity-bullets enemy)
			   (loop for b in (entity-bullets enemy)
			      do (render-bullet b)
		       )))))|#
		       ))))
  (if bullets
      (loop for b in bullets
	 do (render-bullet b)
	   (if (bullet-has-particles b)
	       (show-bullet-particles b))
	       ))
  (if explosions
      (progn (render-particles explosions)
	     (remove-nil explosions)))
  )

(defvar scores '(("Bordiga" 100000000) ("Carmack" 50000000) ("Gabe" 10000000) ("Miyamoto" 1000000)))

(defun render-scores ()
  (render-string "Player Name" (- (round (/ *screen-width* 4)) 32) 16)
  (render-string "Player Score" (- (round (* (/ *screen-width* 4) 3)) 32) 16)
  (let ((x 16)
	(y 48))
    (loop for score in scores
       do (render-string (car score) x y)
	 (render-string (write-to-string (cadr score)) (+ x (round (/ *screen-width* 2))) y)
	 (incf y 16))
    ))

(defun render-entity (e)
  (draw-cell (entity-sheet-surface e) (entity-cell e) (entity-x e) (entity-y e)) ;;;;located in Graphics/lib.lisp
  )

(defun render-particles (particles)
  (loop for particle in particles
     do (if particle
	    (particle-effect particle))
	   (loop for x below (1- (length particles))
	      do (if particle
		     (let ((lifetime (particle-lifetime (nth x particles)))
			   (duration (particle-duration (nth x particles))))
		       (if (>= lifetime duration)
			   (setf (nth x particles) nil)); (kill-particle particle)
		       ))
		)
       (remove-nil particles)
       ))

(defun render-pause-menu ()
  (let ((pause-selection '("Resume Game" "Restart Game" "Scores" "Options" "Main Menu" "Exit"))
	)
    (render-string "MING" (- (/ *screen-width* 2) 24) 16)
    (loop for y below 6
       do (render-string (nth y pause-selection) (- (/ *screen-width* 2) (* (length (nth y pause-selection)) 4)) (+ (/ *screen-height* 8) (* y 16)))
	 )
    ))

(defun render-options ()
  )

(defun render-credits ()
  (case sub-state
    (player-sent-off ())
    (otherwise (render-level))
    )
  )
(defun render-game-over ()
  ;;;;Draw 'Game Over' in the center of the screen
  (render-level)
  (render-string "Game Over" (- (/ *screen-width* 2) 38) (/ *screen-height* 2))
  )

(defun render-bullet (b)
  (let* ((r (car (bullet-color b)))
	 (g (cadr (bullet-color b)))
	 (blue (caddr (bullet-color b)))
	 (a (cadddr (bullet-color b)))
	 (x (bullet-x b))
	 (y (bullet-y b))
	 (rect (sdl2:make-rect x y (car (bullet-size b)) (cadr (bullet-size b))))
	 )
    (sdl2:set-render-draw-color renderer r g blue a)
    (sdl2:render-fill-rect renderer rect)
    (sdl2:free-rect rect)
    ))

