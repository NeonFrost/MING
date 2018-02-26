(defsystem :MING
    :description "MING is a 'galaga'-like game. MING stands for 'Ming Is Not Galaga'."
    :version "0.1.0"
    :author "Brandon Blundell"
    :license "GPL v2"
    :serial t
    :depends-on ("sdl2" "sdl2-mixer" "sdl2-image")
    :components ((:module "engine"
			 :serial t
			 :components 
			 (:file "vectors")
			 (:file "lib")
			 (:file "library")
			 (:file "Music")
			 (:file "sound")
			 (:file "2D-particles")
			 (:file "logic")
			 (:file "render")
			 (:file "keyboard")
			 (:file "loops"))
		 (:file "main" :depends-on ("engine"))))
