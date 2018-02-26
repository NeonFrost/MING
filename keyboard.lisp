(defvar moving nil)
(defvar firing nil)

(defun quit-game ()
  (sdl2:push-event :quit)
  )

(defun keydown-check (key)
  (case state
    (main-menu (main-menu-keys-down key))
    (paused (paused-keys-down key))
    (credits (credits-keys-down key))
    (level (level-keys-down key))
    (game-over (game-over-keys-down key))
    )
  )

(defun keyup-check (key)
  (case state
    (main-menu (main-menu-keys-up key))
    (paused (paused-keys-up key))
    (credits (credits-keys-up key))
    (level (level-keys-up key))
    )
  )

(defun main-menu-keys-down (key)
  (case key
    (:scancode-up (change-selection 0))
    (:scancode-down (change-selection 1))
;;;;    (:scancode-z (confirm-selection choice))
    )
  )

(defun main-menu-keys-up (key)
  (case key
;;;;    (:scancode-up (change-selection 0))
;;;;    (:scancode-down (change-selection 1))
    (:scancode-z (confirm-selection))
    (:scancode-escape (quit-game))
    )
  )

(defun paused-keys-down (key)
  (case key
    (:scancode-up (change-selection 0))
    (:scancode-down (change-selection 1))
    )
  )

(defun paused-keys-up (key)
  (case key
    (:scancode-z (confirm-selection))
    (:scancode-x (case sub-state
		   (options (setf sub-state nil)
			    (setf selection 3))
		   (scores (setf sub-state nil)
			   (setf selection 2))
		   (otherwise (setf state 'level)
			      (setf selection 0))
		   ))
    )
  )

(defun level-keys-down (key)
  (case key
    (:scancode-return (setf state 'paused))
    (:scancode-left (setf moving 'left) ;;;;(entity-move player :d 'left)
		    (setf (player-cell player) 4))
    (:scancode-right (setf moving 'right)
		     (setf (player-cell player) 2))
    (:scancode-z (setf firing t))
;;;;		 (entity-fire player))
    (:scancode-c (entity-fire-missile player))
    )
  )

(defun level-keys-up (key)
  (case key
    (:scancode-left (setf moving nil)
		    (setf (player-speed-x player) 0)
		    (setf (player-cell player) 3))
    (:scancode-right (setf moving nil)
		     (setf (player-speed-x player) 0)
		     (setf (player-cell player) 3))
    (:scancode-z (setf firing nil))    
    )
  )

(defun game-over-keys-down (key)
  (case key
    (:scancode-return (quit-to-main-menu))
    ))
