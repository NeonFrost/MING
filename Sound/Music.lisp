(defstruct track
  path
  stream)

(defvar main-menu-track (make-track :path "Sound/Title.ogg"))
(defvar level-track (make-track :path "Sound/flight-for-your-life.ogg"))

(defun start-level-music (music) ;music is a path
;;;;(let ((music (sdl-mixer:load-music music)));opens that path
;;;;  (setf current-track (sdl-mixer:load-music music))
;;;; (sdl-mixer:play-music current-track :loop t :fade 1000)
  (let ((music (sdl2-mixer:load-music music)))
    (setf (track-stream level-track) music)
    (sdl2-mixer:play-music (track-stream level-track) -1)
    )
  (loop for v from 0 to 128
     do (sdl2-mixer:volume-music v))
  )


(defun start-main-menu-music (music)
  (let ((music (sdl2-mixer:load-music music)))
    (setf (track-stream main-menu-track) music)
    (sdl2-mixer:play-music (track-stream main-menu-track) -1)
    )
  )

(defun stop-music ()
  (sdl2-mixer:halt-music)
  )

(defun resume-level-music ()
  #|  (if post-battle-track
  (progn (sdl2-mixer:halt-music)
  (sdl2-mixer:free-music post-battle-track)
  (setf post-battle-track nil)))|#
  (volume-music 0)
  (sdl2-mixer:play-music (track-stream level-track) -1)
  (loop for v from 0 to 128
     do (sdl2-mixer:volume-music v))
  )

(defun quit-audio ()
  (sdl2-mixer:halt-music)
  (if (track-stream main-menu-track)
      (progn (sdl2-mixer:free-music (track-stream main-menu-track))
	     (setf main-menu-track nil)))
  (if (track-stream level-track)
      (progn (sdl2-mixer:free-music (track-stream level-track))
	     (setf level-track nil)))
  (sdl2-mixer:close-audio)
  (sdl2-mixer:quit)
  )

(defun change-level-track (music)
  "Stops 'level-track' and changes it to another track"
  (loop for v from 128 to 0
     do (sdl2-mixer:volume-music v))
  (sdl2-mixer:halt-music)
  (sdl2-mixer:free-music level-track)
  (setf (track-path level-track) music)
  (start-level-music music)
  )
