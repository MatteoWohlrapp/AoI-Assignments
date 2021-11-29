(clear-all)

(define-model unit2
    
(sgp :v t :show-focus t)


(chunk-type read-letters state)
(chunk-type array letter1 letter2 letter3)

(add-dm 
 (start isa chunk) (attend isa chunk)
 (respond isa chunk) (choose-letter isa chunk) (done isa chunk)
 (goal isa read-letters state start))

 
(P find-unattended-letter
   =goal>
      ISA         read-letters
      state       start
 ==>
   +visual-location>
      :attended    nil
   =goal>
      state       find-location
)

(P attend-letter
   =goal>
      ISA         read-letters
      state       find-location
   =visual-location>
   ?visual>
      state       free
==>
   +visual>
      cmd         move-attention
      screen-pos  =visual-location
   =goal>
      state       attend
)

(P encode-letter-one
   =goal>
      ISA         read-letters
      state       attend
   =visual>
      value       =letter
   ?imaginal>
      state       free 
==>
   =goal>
      ISA       read-letters 
      state     start 
   +imaginal>
      isa         array
      letter1      =letter
)

(P encode-letter-two
   =goal>
      ISA         read-letters
      state       attend
   =visual>
      value       =letter
   ?imaginal>
      state       free
   =imaginal>
      letter1     =let1
      letter2     nil 
==>
   =goal>
      ISA       read-letters 
      state     start 
   +imaginal>
      isa         array
      letter2      =letter
)

(P encode-letter-three
   =goal>
      ISA         read-letters
      state       attend
   =visual>
      value       =letter
   ?imaginal>
      state       free
   =imaginal>
      letter1     =let1
      letter2     =let2 
      letter3     nil 
==>
   =goal>
      ISA       read-letters 
      state     choose-letter 
   +imaginal>
      isa         array
      letter3     =letter
)

(P choose-letter-one
    =goal> 
        ISA     read-letters 
        state   choose-letter 
    ?imaginal>
      state       free
    =imaginal> 
        ISA      array 
        letter1  =let2 
        letter2  =let1 
        letter3  =let1 
==> 
    =goal> 
        ISA     read-letters 
        state    respond 
    +imaginal> 
        isa     array 
        letter1 =let2 
)

(P choose-letter-two
    =goal> 
        ISA     read-letters 
        state   choose-letter 
   ?imaginal>
      state       free
    =imaginal> 
        ISA      array 
        letter1  =let1 
        letter2  =let2 
        letter3  =let1 
==> 
    =goal> 
        ISA     read-letters 
        state    respond 
    +imaginal> 
        isa     array 
        letter1 =let2 
)

(P choose-letter-three
    =goal> 
        ISA     read-letters 
        state   choose-letter 
   ?imaginal>
      state       free
    =imaginal> 
        ISA      array 
        letter1  =let1 
        letter2  =let1 
        letter3  =let2
==> 
    =goal> 
        ISA     read-letters 
        state    respond 
    +imaginal> 
        isa     array 
        letter1 =let2 
)


(P respond
   =goal>
      ISA         read-letters
      state       respond
   =imaginal>
      isa         array
      letter1      =letter
   ?manual>   
      state       free
==>
   =goal>
      state       done
   +manual>
      cmd         press-key
      key         =letter
)


(goal-focus goal)
)
