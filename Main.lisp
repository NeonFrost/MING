#|
starting sequence
(ql:quickload :sdl2) (ql:quickload :sdl2-mixer) (ql:quickload :sdl2-ttf) (ql:quickload :sdl2-image) (load "Main.lisp")
(main)
|#

(proclaim '(optimize (speed 3) (debug 0)))

(defvar screen-surface nil)
(defvar *screen-width* 1024)
(defvar *screen-height* 720)
(defvar state 'main-menu)
(defvar sub-state nil)
(defvar renderer nil)
(defvar accumulator 0)
(defvar selection 0)
(defvar *font* nil)
(defvar *font-color* (list 255 255 255 0))

(defun init-engine ()
  (load "engine.lisp")
  )

(defun main ()
  (sdl2:with-init (:everything) ;audio, etc.
    (sdl2:with-window (window :title "Title"
			      :w *screen-width*
			      :h *screen-height*
			      :flags '(:shown))
      (sdl2:with-renderer (default-renderer window)
	(sdl2-image:init '(:png))
	(sdl2-ttf:init)
	(sdl2-mixer:init :ogg)
	(sdl2-mixer:open-audio 44100 :s16sys 2 1024)
	(setf renderer (sdl2:get-renderer window))
	(setf *font* (sdl2-ttf:open-font "Test.ttf" 16))
	(init-engine) ;start sdl-mixer somewhere
	(start-main-menu-music (track-path main-menu-track))
	(sdl2:with-event-loop (:method :poll)
	  (:keydown (:keysym keysym)
		    (keydown-check (sdl2:scancode keysym))
		    )
	  (:keyup (:keysym keysym)
		  (keyup-check (sdl2:scancode keysym))
		  )
	  (:idle ()
		 (sdl2:set-render-draw-color renderer 0 0 0 255)
		 (sdl2:render-clear renderer)
		 (game-loop)
		 (sdl2:render-present renderer)
		 (sdl2:delay 50)
		 (gc :full t)
		 )
	  (:quit ()
		 ;;;;(close-font)
		 (quit-audio)
		 t)
	  )))))

(defun game-loop ()
  (case state ;state management
    (main-menu (main-menu-loop))
    (level (level-loop))
    (paused (paused-loop))
    (credits (credits-loop))
    (game-over (game-over-loop))
    )
  )
