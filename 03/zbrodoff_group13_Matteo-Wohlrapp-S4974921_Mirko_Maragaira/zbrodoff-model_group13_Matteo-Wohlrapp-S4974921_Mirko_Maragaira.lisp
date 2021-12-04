
(clear-all)

(define-model zbrodoff
    
; original values: lf: 0.4, rt: 0.5, ans: 0.5
(sgp :v nil :esc t :lf 0.3 :bll 0.5 :ans 0.2 :rt 0.8 :ncnar nil)

(sgp :show-focus t)

(chunk-type problem arg1 arg2 result)
(chunk-type goal state count target next-let next-num)
(chunk-type number number next visual-rep vocal-rep)
(chunk-type letter letter next visual-rep vocal-rep)

(add-dm
 (zero  ISA number number zero next one visual-rep "0" vocal-rep "zero")
 (one   ISA number number one next two visual-rep "1" vocal-rep "one")
 (two   ISA number number two next three visual-rep "2" vocal-rep "two")
 (three ISA number number three next four visual-rep "3" vocal-rep "three")
 (four  ISA number number four next five visual-rep "4" vocal-rep "four")
 (five  isa number number five)
 (a ISA letter letter a next b visual-rep "a" vocal-rep "a")
 (b ISA letter letter b next c visual-rep "b" vocal-rep "b")
 (c ISA letter letter c next d visual-rep "c" vocal-rep "c")
 (d ISA letter letter d next e visual-rep "d" vocal-rep "d")
 (e ISA letter letter e next f visual-rep "e" vocal-rep "e")
 (f ISA letter letter f next g visual-rep "f" vocal-rep "f")
 (g ISA letter letter g next h visual-rep "g" vocal-rep "g")
 (h ISA letter letter h next i visual-rep "h" vocal-rep "h")
 (i ISA letter letter i next j visual-rep "i" vocal-rep "i")
 (j ISA letter letter j next k visual-rep "j" vocal-rep "j")
 (k isa letter letter k next l visual-rep "k" vocal-rep "k")
 (l isa letter letter l)
 (goal isa goal)
 ; added memory and removed count state
 (attending) (read) (counting) (encode) (memory))

(set-visloc-default screen-x lowest)

; unchanged
; production selected to attend a new object on the screen. 
; Gets selected as the first production -> because of buffer stuffing, no previous request to the visual-location buffer necessary 
(P attend
   =goal>
      ISA         goal
      state       nil
   =visual-location>
   ?visual>
       state      free
==>
   =goal>
      state       attending
   +visual>
      cmd         move-attention
      screen-pos  =visual-location
   )

; unchanged
; production to read the first object, a character. 
; Character is given as the visual representation, request to the retrieval to get actual character
; pattern search from left to right, so not :attend nil necessary 
; request to visual-location and goal state nil, so the attend location is selected next
(P read-first
   =goal>
     ISA         goal
     state       attending
   =visual>
     ISA         visual-object
     value       =char
   ?imaginal>
     buffer      empty
     state       free   
==>
   +imaginal>
   +retrieval>
     isa         letter
     visual-rep  =char
   =goal>
     state       nil
   +visual-location>
     ISA         visual-location
   > screen-x    current
     screen-x    lowest
   - value       "+"
   )

; unchanged
; production to put the in 'read-first' requested char into the imaginal buffer 
; prepare for the reading of visual object 2
(p encode-first
   =goal>
     isa           goal
     state         attending
   =retrieval>
     letter        =let
     vocal-rep     =word
   =imaginal>
     arg1          nil
   ?vocal>
     preparation   free
   ==>
   +vocal>
     cmd           subvocalize
     string        =word
   =imaginal>
     arg1          =let
   =goal>
     state         read
   )

; unchanged
; production to read the second object, a number. 
; Number is given as the visual representation, request to the retrieval to get actual number
; read-second and read-third have same state, however, arg2 in read second is still nil -> selected first
; request to visual-location and goal state nil, so the attend location is selected next
; -> no need to check if next value is not equal to '=' since we select highest x position
(P read-second
   =goal>
     ISA         goal
     state       read
   =visual>
     ISA         visual-object
     value       =char
   =imaginal>
     isa         problem
    - arg1       nil
     arg2        nil
   ==>
   =imaginal>
   +retrieval>
     isa         number
     visual-rep  =char
   
   =goal>
     state       nil
   
   +visual-location>
     ISA         visual-location
     screen-x    highest
   )

; unchanged
; production to put the in 'read-second' requested char into the imaginal buffer 
; imaginal buffer untouched in previous production (attend), so still preserved
; prepare for the reading of character 3
(p encode-second
   =goal>
     isa          goal
     state        attending
   =retrieval>
     number       =num
     vocal-rep    =word
   =imaginal>
    - arg1        nil
     arg2         nil
   ?vocal>
     preparation  free
   ==>
   +vocal>
     cmd          subvocalize
     string       =word
   =imaginal>
     arg2         =num
   =goal>
     state        read
   )

; unchanged
; production to read the third object, a character. 
; Character is given as the visual representation, request to the retrieval to get actual character
; no need to read another character so no more requests to visual location
(P read-third
   =goal>
     ISA         goal
     state       read
   =imaginal>
     isa         problem
     arg1        =arg1
     arg2        =arg2
   =visual>
     ISA         visual-object
     value       =char
   ?visual>
     state       free
==>
   =imaginal>
   +retrieval>
     isa         letter
     visual-rep  =char
   =goal>
     state       encode
   +visual>
     cmd         clear
   )

; changed
; method to get the letter value for the 3rd visual object. 
; The conditions were not modified
; Only the modifications to buffers were changed: 
;   - state of result buffer from count to memory -> that way the newly defined productions are selected next
;   - retrieval request for the previously attended letters -> to check if we have information about this combination saved
(p encode-third
   =goal>
     isa          goal
     state        encode
     target       nil
   =retrieval>
     letter       =let
     vocal-rep    =word
   =imaginal>
     arg1         =a1
     arg2         =a2
   ?vocal>
     preparation  free
   ==>
   +vocal>
     cmd          subvocalize
     string       =word
   =goal>
     target       =let
     state        memory
   +retrieval> 
      isa       problem
      arg1      =a1 
      arg2      =a2 
   =imaginal>
   )

; new
; method which is called if there is a problem chunk saved which has the same result as the last read character (was saved in target at previous production)
; that means the solution in the equation is a correct solution of the problem, assuming that only correct chunks are saved in the buffer
; We modify the goal and the imaginal so that only the final-answer-yes production can be selected next
; We also add the result to the imaginal buffer, so when it gets cleared in the final production, the correct solution is saved in memory 
(P did-memorize-and-correct
  =goal> 
    isa       goal 
    state     memory 
    target    =result
  =retrieval> 
    isa       problem
    arg1      =a1 
    arg2      =a2 
    result    =result
  =imaginal> 
    arg1      =a1 
    arg2      =a2 
==> 
  =goal> 
    isa       goal 
    count     =a2
  =imaginal> 
    result    =result
)

; new
; method which is called if there is a problem chunk saved which has a different result as the last read character (was saved in target at previous production)
; that means the solution in the equation is not a correct solution of the problem, assuming that only correct chunks are saved in the buffer
; We modify the goal and the imaginal so that only the final-answer-no production can be selected next
; To to that, count in goal needs to be the number displayed on the screen before -> result does not match target
; We also add the result to the imaginal buffer, so when it gets cleared in the final production, the correct solution is saved in memory 
(P did-memorize-but-incorrect  
  =goal> 
    isa       goal 
    state     memory 
    target    =let
  =retrieval> 
    isa       problem
    arg1      =a1 
    arg2      =a2
  - result    =let  
    result    =result
  =imaginal> 
    arg1      =a1 
    arg2      =a2 
==> 
  =goal> 
    isa       goal 
    count     =a2
  =imaginal> 
    result    =result
)

; changed
; production which is selected if the combination of character and number was not previously seen, which is indicated by a buffer failure
; in that case we have to count as we did in the original version -> state is set to counting
; prepare counting by setting the result accordingly
(P start-counting
   =goal>
     ISA         goal
     state       memory
   =imaginal>
     isa         problem
     arg1        =a
     arg2        =val
   ?retrieval>
     buffer    failure
==>
   =imaginal>
     result      =a
   =goal>
     state       counting
   +retrieval>
     ISA         letter
     letter      =a
   )

; unchanged
; production to initialize counting by setting count to zero
; requesting isa letter in retrieval is also important to select next production
(p initialize-counting
   =goal>
     isa         goal
     state       counting
     count       nil
   =retrieval>
     isa         letter
     letter      =l
     next        =new
     vocal-rep   =t
   ?vocal>
     state       free
   ==>
   +vocal>
     isa         subvocalize
     string      =t
   =goal>
     next-num    one
     next-let    =new
     count       zero
   +retrieval>
     isa         letter
     letter      =new
   )

; unchanged
; first we update the result, then the counter 
; important that counting is not finished -> count in goal != arg2 in retrieval
; request to retrieval to get new number
(P update-result
   =goal>
     ISA         goal
     count       =val
     next-let    =let
     next-num    =n
   =imaginal>
     isa         problem
    - arg2       =val
   =retrieval>
     ISA         letter
     letter      =let
     next        =new
     vocal-rep   =txt
   ?vocal>
     state       free
   ==>
   =goal>
     next-let    =new
   +vocal>
     cmd         subvocalize
     string      =txt
   =imaginal>
     result      =let
   +retrieval>
     ISA         number
     number      =n
   )

; unchanged
; afer the update of the result, the count needs to be updated
; -> use of in 'update-result' requested chunk from retrieval buffer
(P update-count
   =goal>
     ISA         goal
     next-let    =let
     next-num    =n
   =retrieval>
     ISA         number
     number      =val
     next        =new
     vocal-rep   =txt
   ?vocal>
     state       free
==>
   +vocal>
     cmd         subvocalize
     string      =txt
   =goal>
     count       =val
     next-num    =new
   +retrieval>
     ISA         letter
     letter      =let
   )


; unchanged
; production to press key for correct equation -> 'k'
; selected if we counted enough or set count parameter correctly before
; imaginal holds a correct equation
; imagnal is used and not modified -> gets saved to memory/merged with older chunks 
(P final-answer-yes
   =goal>
     ISA         goal
     target      =let
     count       =val
   =imaginal>
     isa         problem
     result      =let
     arg2        =val
   ?vocal>
     state       free
   
   ?manual>
     state       free
   ==>
   +goal>
     
   +manual>
     cmd         press-key
     key         "k"
   )

; unchanged
; production to press key for incorrect equation -> 'd'
; selected if we counted enough or set count parameter correctly before
; imaginal holds a correct equation because the buffer result was retrieved with either counting, 
; or set to the correct value in the 'did-memorize-but-incorrect' production
; imagnal is used and not modified -> gets saved to memory/merged with older chunks 
(P final-answer-no
    =goal>
     ISA         goal
     count       =val
     target      =let
   =imaginal>
     isa         problem
   - result      =let
   - result      nil
     arg2        =val
   ?vocal>
     state       free
   
   ?manual>
     state       free
   ==>
   +goal>
     
   +manual>
     cmd         press-key
     key         "d"
   )

(set-all-base-levels 100000 -1000)
(goal-focus goal)
)
