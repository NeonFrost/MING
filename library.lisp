#|
Holds structures, macros, classes, etc.

Behavior of different ai
TYPE A: Vectors: +y at a rate of 0.5, +/- x at a rate of 0.25 until edge of the screen then change 'sign'
TYPE B: Inverse of Type A, faster +/- x, slower +y
TYPE C: Slams downward 5 times after firing 3 lasers, follows player; HP = 5 hits
BOSS: Vectors: +/- x, follows player at 1/4, 1/2, 3/4, and 1.0 players speed at 1.0, 3/4, 1/2, 1/4 health, no Y vector; HP=50 hits
|#

(defvar explosions nil)
(defvar wavelist nil)
(defvar bullets nil)

(defstruct bullet
  has-particles ;t or nil
  particles
  x
  y
  vector
  size
  color
  power ;= (entity-atk ,entity) + upgrade (if applicable)
  owner
  owner-type)

(defstruct entity
  sheet
  sheet-surface
  x
  y
  (cell 0)
  cell-size
  hp
  atk
  def
  size
  fire-sound ;make-sample :path "/path/to/sound"
  bullets
  max-hp);;;;only used with boss, but in entity for portability

(defstruct (enemy (:include entity))
  path ;describes how the vectors change
  vector ;describes the movement, changes handeled by (ai-path ai), updates x and y of entity
  attack-pattern ;ex: type-c: Slams toward the bottom-left, back to 'start pos', then bottom-right, rep, with 5th one being straight down.
;;;;  lifetime ;the lifetime of the enemy = the y of the enemy, when the 'lifetime' of the enemy is greater than *screen-height* + 64, then it cleans up that enemy.
  killed) ;either nil or t, t if and only if the player's bullets hit them and their hp = 0

(defstruct (type-a (:include enemy
			     (atk 1)
			     (def 1)
			     (hp 1)
			     (y -64)
			     (fire-sound (make-sample :path "Sound/enemy-fire.ogg"))
			     (path '(:edge '(-1 0)))
			     (vector (vec-2d:make-vector-2d :x 8 :y 8))
			     (attack-pattern '(:player-x (fire 'type-a)))
			     (sheet "Graphics/Type-A.png")
			     (cell-size '(32 32))
			     ))
  )

(defstruct (type-b (:include enemy
			     (atk 1)
			     (def 1)
			     (hp 2)
			     (y -64)
			     (fire-sound (make-sample :path "Sound/enemy-fire.ogg"))
			     (path '(:edge '(-2 0)))
			     (vector (vec-2d:make-vector-2d :x 16 :y 2))
			     (attack-pattern '(:charged (fire 'type-b)))
			     (sheet "Graphics/Type-B.png")
			     (cell-size '(32 32))
			     ))
  (charged 0)
  )

(defstruct (type-c (:include enemy
			     (atk 2)
			     (def 1)
			     (hp 4)
			     (y -64)
			     (fire-sound (make-sample :path "Sound/enemy-fire.ogg"))
			     (path '(:fired-lasers nil))
			     (vector (vec-2d:make-vector-2d :x 0 :y 0))
			     (attack-pattern '(:player-x))
			     (sheet "Graphics/Type-C.png")
			     (cell-size '(32 32))))
  (fired 0)
  (path-num 0)
  )

(defstruct (boss (:include enemy
			   (y -128)
			   (fire-sound (make-sample :path "Sound/boss-fire.ogg"))
			   (path '(:follow-player))
			   (vector (vec-2d:make-vector-2d :x 0 :y 0))
			   (attack-pattern '(:player-x (fire 'boss)))
			   (sheet "Graphics/Boss.png")
			   (cell-size '(64 128)))) ;on make-boss, it gets the player's current upgrade, weapon and atk (i.e. power of one player 'bullet') and mults it by 50, this is HP I guess
  (missile 10) ;boss missile has a radius of 240
  )

(defstruct (player (:include entity
			     (fire-sound (make-sample :path "Sound/player-fire.ogg"))
			     ))
  (groups 0)
  (kills 0)
  (waves 0)
  (speed-x 0)
  (speed-y 0)
  (weapon 1)
  (shield 0) ;shield allows for more hits on the player
  (missile 0) ;missile is shot with c or something, has an explosion of radius 240 pixels
  (upgrade 0)) ;upgrade increases the amount of damage the player can do (i.e. (setf (bullet-power player-bullet) (+ (player-upgrade player) (player-atk player)))

(defvar player (make-player :x (- (/ *screen-width* 2) 16) :y (- *screen-height* 96)
			    :sheet "Graphics/player.png"
			    :cell 3
			    :cell-size '(32 32)
			    :hp 5 :atk 1 :def 1))
(defvar enemies '()) ;list of enemies, used as a 'grouping' kind of thing
