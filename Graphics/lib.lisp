(defstruct sprite-sheet ;used with characters, tiles, etc
  width
  height
  cells
  file
  surface
  texture)

(defmacro optimize-sheet (var)
  `(progn ;;;(let (;;;;(optimized-surface (sdl2:convert-surface (sprite-sheet-surface ,var) ,pixel-format))
;;;;	 (optimized-sheet (sdl2:create-texture-from-surface renderer (sprite-sheet-surface ,var)))
;;;;	 )
     (setf (sprite-sheet-texture ,var) (sdl2:create-texture-from-surface renderer (sprite-sheet-surface ,var)))
     (sdl2:free-surface (sprite-sheet-surface ,var))
     ;;;;     )
  ))

(defmacro set-sheet-width (sheet width)
  `(setf (sprite-sheet-width ,sheet) ,width)
  )

(defmacro set-sheet-height (sheet height)
  `(setf (sprite-sheet-height ,sheet) ,height)
  )

(defmacro set-cells (sheet tile-size)
  `(let ((cells (loop for y from 0 to (sprite-sheet-height ,sheet) by (cadr ,tile-size)
		   append (loop for x from 0 to (sprite-sheet-width ,sheet) by (car ,tile-size)
			     collect (list x y (car ,tile-size) (cadr ,tile-size))))
	   ))
     (setf (sprite-sheet-cells ,sheet) cells)
     ))

(defmacro set-sheet-surface (sheet surface)
  `(setf (sprite-sheet-surface ,sheet) ,surface))

(defmacro load-sheet (sheet cell-size)
  `(let* ((filename (sprite-sheet-file ,sheet))
	  (surface (sdl2-image:load-image filename))
	  )
     (set-sheet-height ,sheet (sdl2:surface-height surface))
     (set-sheet-width ,sheet (sdl2:surface-width surface))
     (set-cells ,sheet ,cell-size)
     (set-sheet-surface ,sheet surface)
     (optimize-sheet ,sheet)
     ))

(defmacro defsheet (entity file cell-size)
  `(progn (setf (entity-sheet-surface ,entity) (make-sprite-sheet :file ,file))
	  (load-sheet (entity-sheet-surface ,entity) ,cell-size)
	  ))
#|
(defmacro original-blit (src-surface dest-surface)
  `(sdl2:blit-surface ,src-surface nil ,dest-surface nil)
  )
(defmacro clip-blit (src-surface src-rect dest-surface dest-rect)
  `(sdl2:blit-surface ,src-surface ,src-rect ,dest-surface ,dest-rect)
  )
|#
(defmacro tex-blit (tex x y &key (src (cffi:null-pointer)) dest)
  `(sdl2:render-copy renderer
			,tex
			:source-rect ,src
			:dest-rect ,dest)
  )

(defmacro draw-cell (sheet cell x y)
  `(let* ((cells (sprite-sheet-cells ,sheet))
	  (src-rect (sdl2:make-rect (nth 0 (nth ,cell cells))
				    (nth 1 (nth ,cell cells))
				    (nth 2 (nth ,cell cells))
				    (nth 3 (nth ,cell cells))))
	  (tsx (nth 2 (nth ,cell cells)))
	  (tsy (nth 3 (nth ,cell cells)))
	  (dest-rect (sdl2:make-rect ,x
				     ,y
				     tsx
				     tsy))
	  )
     ;;;;(clip-blit (sprite-sheet-surface ,sheet) src-rect screen-surface dest-rect)
     (tex-blit (sprite-sheet-texture ,sheet) ,x ,y :src src-rect :dest dest-rect)
     )
  )

(defmacro free-sheet (sheet)
  `(progn (sdl2:destroy-texture (sprite-sheet-texture ,sheet))
	  (setf ,sheet nil)))

(defmacro render-box (x y w h color)
  `(let ((r (car ,color))
	 (g (cadr ,color))
	 (b (caddr ,color))
	 (a (cadddr ,color))
	 (rect (sdl2:make-rect ,x ,y ,w ,h))
	 )
     (sdl2:set-render-draw-color renderer r g b a)
     (sdl2:render-fill-rect renderer rect)
     (sdl2:free-rect rect)
     ))

(defmacro render-string (str x y)
;;;;  `(sdl:draw-string-at-* ,str ,x ,y))
  `(let* ((surface (sdl2-ttf:render-text-solid *font* ,str (car *font-color*) (cadr *font-color*) (caddr *font-color*) 0))
	  (texture (sdl2:create-texture-from-surface renderer surface)))
     (sdl2:free-surface surface)
     (sdl2:render-copy renderer
		       texture
		       :source-rect (cffi:null-pointer)
		       :dest-rect (sdl2:make-rect ,x ,y
						  (sdl2:texture-width texture)
						  (sdl2:texture-height texture)))
     (sdl2:destroy-texture texture)
     ))

(defun collect-dead ()
  )
