(clear-all)

(define-model 1-hit-model 
    
  ;; do not change these parameters
  (sgp :esc t :bll .5 :ol t :sim-hook "1hit-bj-number-sims" :cache-sim-hook-results t :er t :lf 0)
  
  ;; adjusted: mp decresed, rt incresed
  (sgp :v nil :ans .2 :mp 7.0 :rt -40)
  
  ;; This type holds all the game info 
  (chunk-type game-state mc1 mc2 mc3 mstart mtot mresult oc1 oc2 oc3 ostart otot oresult state)
  
  ;; This chunk-type should be modified to contain the information needed
  ;; for your model's learning strategy
  (chunk-type learned-info mstart ostart action)
  
  ;; Declare the slots used for the goal buffer since it is
  ;; not set in the model defintion or by the productions.
  ;; See the experiment code text for more details.
  
  (declare-buffer-usage goal game-state :all)
  
  ;; Create chunks for the items used in the slots for the game
  ;; information and state
  
  (define-chunks win lose bust retrieving start results)
    
  ;; Provide a keyboard for the model's motor module to use
  (install-device '("motor" "keyboard"))
  
  ; first production to be called
  ; uses the m and o start values to try and retrieve already known facts with the same values
  (p start
     =goal>
       isa game-state
       state start
       mstart =m
       ostart =o
    ==>
     =goal>
       state retrieving
     +retrieval>
       isa learned-info
       mstart =m 
       ostart =o
     - action nil)

; if there was no previous game with the same first own card, a buffer failure occurs 
; as a heuristic, we stay if ostart is samller than mstart, meaning that our first two cards are higher than the opponets we stay. 
  (p cant-remember-game-bigm
     =goal>
       isa game-state
       state retrieving
       mstart =m 
     < ostart =m
     ?retrieval>
       buffer  failure
     ?manual>
       state free
    ==>
     =goal>
       state nil
     +manual>
       cmd press-key
       key "s")

; if there was no previous game with the same first own card, a buffer failure occurs 
; as a heuristic, we hit if ostart is bigger than mstart, meaning we picked very low cards for the first two. 
    (p cant-remember-game-smallm
     =goal>
       isa game-state
       state retrieving
       mstart =m 
    >= ostart =m
     ?retrieval>
       buffer  failure
     ?manual>
       state free
    ==>
     =goal>
       state nil
     +manual>
       cmd press-key
       key "h")
  
  ; if the we remember a game with the first own card, we press the action as we did in the already known situation
  ; since partial matching is used, the values don't need to be exactly the same
  (p remember-game
     =goal>
       isa game-state
       state retrieving
     =retrieval>
       isa learned-info
       action =act
     ?manual>
       state free
    ==>
     =goal>
       state nil
     +manual>
       cmd press-key
       key =act
     
     @retrieval>)

; production which is fired if we win. 
; In that case we wants to safe the action we did before into memory
; since mc3 is nil, this means we stayed in the production before, so we want to do that again in the future
    (p results-mWin-stay
     =goal>
       isa game-state
       state results
       mresult win
       mstart  =m 
       ostart  =o 
       mc3     nil 
     ?imaginal>
       state free
    ==>
     !output! (I win)
     =goal>
       state nil
     +imaginal>
       mstart  =m 
       ostart  =o
       action "s")

; production which is fired if we win. 
; In that case we wants to safe the action we did before into memory
; since mc3 is not nil, this means we hit in the production before, so we want to do that again in the future
    (p results-mWin-hit
     =goal>
       isa game-state
       state results
       mresult win
       mstart  =m 
       ostart  =o 
      - mc3     nil 
     ?imaginal>
       state free
    ==>
     !output! (I win)
     =goal>
       state nil
     +imaginal>
       mstart  =m 
       ostart  =o
       action "h")
  
; production which is fired if we bust. 
; In that case we want don't want to hit anymore if mstart is the value seen before
    (p results-mBust
     =goal>
       isa game-state
       state results
       mresult bust
       mstart  =m 
       ostart  =o 
     ?imaginal>
       state free
    ==>
     !output! (I win)
     =goal>
       state nil
     +imaginal>
       mstart  =m 
       ostart  =o
       action "s")

; production which is fired if we lose 
; since a loss means that the opponent got a higher score without busting, we want to hit the next time
(p results-mLose
     =goal>
       isa game-state
       state results
       mresult lose
       mstart  =m 
       ostart  =o 
       mc3     nil 
     ?imaginal>
       state free
    ==>
     !output! (I win)
     =goal>
       state nil
     +imaginal>
       mstart  =m 
       ostart  =o
       action "h")
  
; production which clears the imaginal buffer and therefore safes it into memory
  (p clear-new-imaginal-chunk
     ?imaginal>
       state free
       buffer full
     ==>
     -imaginal>)
  )
