(clear-all)

(define-model subitize

(sgp :v t)

(sgp :show-focus t 
     :visual-num-finsts 10 
     :visual-finst-span 10)

(chunk-type count count state)
(chunk-type number number next vocal-rep)

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
        (start isa chunk) 
        (find-spot isa chunk)
        (attend isa chunk)
        (increment isa chunk)
        (stop isa chunk)
        (goal isa count state start)
)


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
)

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
   +retrieval>
      ISA         number
      number      =num 
)

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
      state       increment
   +visual>
      cmd         move-attention
      screen-pos  =visual-location
)

(P increment
   =goal>
      ISA         count
      state       increment
      count       =num 
   =retrieval>
      ISA         number
      number      =num
      next        =next
==>
   =goal>
      ISA         count
      state       find-spot
      count       =next   
   +retrieval>
      ISA         number
      number      =next 
)

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
