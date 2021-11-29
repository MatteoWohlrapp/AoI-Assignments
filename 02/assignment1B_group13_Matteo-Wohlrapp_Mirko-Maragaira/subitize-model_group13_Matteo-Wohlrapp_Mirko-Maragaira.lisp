(clear-all)

(define-model subitize

(sgp :v t)

(sgp :show-focus t 
     :visual-num-finsts 10 
     :visual-finst-span 10)

(chunk-type count count state)
(chunk-type number number next vocal-rep)
(chunk-type previous number)


(add-dm (zero isa number number zero next one vocal-rep "zero")
        (one isa number number one next two vocal-rep "one")
        (two isa number number two next three vocal-rep "two")
        (three isa number number three next four vocal-rep "three")
        (four isa number number four next five vocal-rep "four")
        (five isa number number five next six vocal-rep "five")
        (six isa number number six next seven vocal-rep "six")
        (seven isa number number seven next eight vocal-rep "seven")
        (eight isa number number eight next nine vocal-rep "eight")
        (nine isa number number nine next ten vocal-rep "nine")
        (ten isa number number ten next eleven vocal-rep "ten")
        (eleven isa number number eleven)
        ; states which are used in the productions
        (start isa chunk) 
        (find-spot isa chunk)
        (attend isa chunk)
        (request isa chunk)
        (increment isa chunk)
        (stop isa chunk)
        (goal isa count state start)
)

; function which is called at the start, initializes the count with zero
; changes the goal state to call the find-spot production
; request to retrieval buffer to cope with zero displayed elements 
(P start
   =goal>
      ISA         count
      state       start 
      count       nil
 ==>
   =goal>
      ISA         count
      state       find-spot 
      count       zero
   +retrieval>
      ISA         number
      number      zero
)

; production to find the next spot on the screen 
; searching for a spot which was not visited and is closest to the current one
; makes it similar to human behaviour
(P find-spot 
   =goal>
      ISA         count
      state       find-spot 
      count       =num
 ==>
   =goal>
      ISA         count
      state       attend
   +visual-location>
      :attended    nil
      :nearest current
)

; if another location was found, we attend it 
; therefore we move the attention of the visual buffer to that position
(P attend-spot
   =goal>
      ISA         count
      state       attend
   =visual-location>
   ?visual>
      state       free
 ==>
   =goal>
      ISA         count
      state       request
   +visual>
      cmd         move-attention
      screen-pos  =visual-location
)

; production to request the next element from the retrieval module
; this way the number which will be stored in 'number' in the buffer can be used to increment later
(P request-next
   =goal>
      ISA         count
      state       request
      count       =num
   =retrieval> 
        ISA     number 
        number  =num 
        next    =next 
 ==>
   =goal>
      ISA         count
      state       increment
   +retrieval>
      ISA         number
      number      =next 
)

; production to increment the number saved in goal 
; we need to use '=retrieval>' so the buffer does not get clearedS
; the incremented number is in the previously requested chunk to the retrieval module
(P increment
   =goal>
      ISA         count
      state       increment
   =retrieval>
      ISA         number
      number      =num
==>
   =goal>
      ISA         count
      state       find-spot
      count       =num  
   =retrieval>
)

; production fired when there is a buffer failure of the visual-location buffer 
; happens when there are no more unattended spots on the screen. 
; if this happens, a request to the vocal buffer is made to speak the number stored in the vocal-rep field of the retrieval buffer. 
(P no-spot-found
   =goal> 
        ISA             count
        state           attend
        count           =num
   =retrieval> 
        ISA             number
        number           =num 
        vocal-rep       =val 
   ?visual-location>
        buffer failure 
   ?vocal>
      state    free
==> 
   =goal> 
        ISA     count 
        state   stop 
   +vocal>
        cmd      speak
        string   =val
   =retrieval>
)

(goal-focus goal)

)
