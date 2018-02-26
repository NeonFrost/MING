(defun main-menu-loop ()
  (case sub-state
    (scores (render-scores))
    (options (render-options))
    (otherwise (render-main-menu))
    )
  )

(defun change-selection (d)
  (case d
    (0 (if (eq selection 0)
	   (setf selection 4)
	   (decf selection 1)))
    (1 (if (eq selection 4)
	   (setf selection 0)
	   (incf selection 1)))
    ))

(defun confirm-selection ()
  (case state
    (main-menu (case selection
		 (0 (start-game));start game
		 (1 (setf sub-state 'scores))
		 (2 (setf sub-state 'options));options))
		 (3 (setf sub-state 'help));options
		 (4 (quit-game));exit game
		 ))
    (paused (case sub-state 
	      (scores (setf sub-state nil)
		      (setf selection 2))
	      (options (case selection
			 (0 ())
			 (4 (setf sub-state nil)
			    (setf selection 3));Exits options
			 )) ;;;;hypothetical options, i.e. changing volume, resolution, etc.
	      (otherwise (case selection
			   (0 (setf state 'level))
			   (1 (restart-game))
			   (2 (setf sub-state 'scores)
			      (setf selection 0))
			   (3 (setf sub-state 'options)
			      (setf selection 0))
			   (4 (quit-to-main-menu))
			   )
			 )
	      ))
    ))

(defun start-game ()
  (gen-wavelist)
  (gen-enemies)
  (spawn-player)
  (stop-music)
  (start-level-music (track-path level-track))
  (setf state 'level)
  )

(defun restart-game ()
  (reset-player)
  (reset-enemies)
  (start-game)
  )

(defun reset-player ()
  (if player
      (if (entity-sheet-surface player)
	  (free-sheet (entity-sheet-surface player))))
  (setf player (make-player :x (- (/ *screen-width* 2) 16) :y (- *screen-height* 96)
			    :sheet "Graphics/player.png"
			    :cell 3
			    :cell-size '(32 32)
			    :hp 5 :atk 1 :def 1))
  )

(defun reset-enemies ()
  (setf enemies nil)
  )

(defun quit-to-main-menu ()
  (reset-enemies)
  (reset-player)
  (stop-music)
  (start-main-menu-music (track-path main-menu-track))
  (setf state 'main-menu)
  )

(defun level-loop ()
  (when (not enemies)
    (incf (player-waves player) 1)
    )
  (if enemies
      (when (>= accumulator 400)
	(gen-enemies)
	(setf accumulator 0))
      (progn (gen-wavelist)
	     (gen-enemies)))
  (if moving
      (entity-move player :d moving))
  (if firing
      (entity-fire player))
#|  (if (player-bullets player)
      (progn (remove-nil (entity-bullets player))
	     (loop for b in (entity-bullets player)
		do (move-bullet b)
		  (if (or (<= (bullet-y b) -32)
			  (>= (bullet-y b) (+ *screen-height* 32)))
		      (setf b nil))
		  )))|#
  (if enemies
      (progn (loop for type in enemies
		do (loop for group in type
		      do (loop for e in group
			    do (entity-move e))
#|			      (if (entity-bullets e)
				  (progn (loop for b in (entity-bullets e)
					    do (move-bullet b))	 
					 (remove-nil (entity-bullets e)))
				  ))|#
			(if type
			    (remove-group type group))))
	     ))
  (if bullets
      (loop for b in bullets
	 do (if b
		(progn (move-bullet b)
		       (if (or (<= (bullet-y b) -32)
			       (>= (bullet-y b) (+ *screen-height* 32)))
			   (setf (nth (position b bullets) bullets) nil))))))
  (remove-nil bullets)
  (incf accumulator 10)
  (render-level)
  )

(defun paused-loop ()
  (case sub-state
    (options (render-options))
    (scores (render-scores))
    (otherwise (render-pause-menu))
    )
  )

(defun credits-loop ()
  (render-credits)
  )

(defun game-over-loop ()
  (render-game-over)
  (if player
      (setf player nil))
  )

(defun quit-game ()
  )
